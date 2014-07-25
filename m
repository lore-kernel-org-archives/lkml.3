Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437AbaGYJku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:40:50 -0400
Received: from router.aksignal.cz ([188.175.113.102]:56943 "EHLO
	router.aksignal.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154AbaGYJks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:40:48 -0400
Message-ID: <53D22611.6010804@aksignal.cz>
Date: Fri, 25 Jul 2014 11:40:33 +0200
From: =?UTF-8?B?SmnFmcOtIFByY2hhbA==?= <jiri.prchal@aksignal.cz>
Reply-To: jiri.prchal@aksignal.cz
Organization: AK signal Brno
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        devicetree@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, Bo Shen <voice.shen@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: at91sam9x5: sets NPCS0 (PA14) back to GPIO
References: <1405074175-22444-1-git-send-email-voice.shen@atmel.com>	<53D10C50.50305@aksignal.cz>	<20140724162645.4e19c26c@bbrezillon>	<53D12103.3020103@aksignal.cz>	<20140724175848.44f5da10@bbrezillon>	<53D1F5D0.1080006@aksignal.cz>	<20140725083053.GD9532@piout.net>	<53D2174B.4020403@aksignal.cz>	<20140725085436.GF9532@piout.net>	<53D21C57.3010805@aksignal.cz> <20140725111033.49a0e7e8@bbrezillon>
In-Reply-To: <20140725111033.49a0e7e8@bbrezillon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dne 25.7.2014 v 11:10 Boris BREZILLON napsal(a):
> On Fri, 25 Jul 2014 10:59:03 +0200
> Jiří Prchal <jiri.prchal@aksignal.cz> wrote:
>
>>
>>
>> Dne 25.7.2014 v 10:54 Alexandre Belloni napsal(a):
>>> On 25/07/2014 at 10:37:31 +0200, Jiří Prchal wrote :
>>>>
>>>>
>>>> Dne 25.7.2014 v 10:30 Alexandre Belloni napsal(a):
>>>>> Hi,
>>>>>
>>>>> On 25/07/2014 at 08:14:40 +0200, Jiří Prchal wrote :
>>>>>> I'm using custom board. My spi node:
>>>>>> 			spi0: spi@f0000000 {
>>>>>
>>>>> You should override the pinctrl here as you are using gpios for the cs.
>>>>> 				pinctrl-0 = <&pinctrl_spi0_custom>;
>>>>>
>>>>>> 				status = "okay";
>>>>>> 				cs-gpios = <&pioA 23 0
>>>>>> 					    &pioA 22 0
>>>>>> 					    &pioC 29 0
>>>>>> 					    &pioA 14 0>;
>>>>>>
>>>>>
>>>>> 		pinctrl@fffff400 {
>>>>> 				spi0 {
>>>>> 					 pinctrl_spi0_custom: spi0-custom {
>>>>> 							 atmel,pins =
>>>>> 									 <AT91_PIOA 23 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>,
>>>>> 									 <AT91_PIOA 22 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>,
>>>>> 									 <AT91_PIOC 29 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>,
>>>>> 									 <AT91_PIOA 14 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
>>>>> 					 };
>>>>> 				};
>>>>> 		};
>>>>>
>>>> Of course, it's the way, but in all other drivers, for example LEDS,
>>>> it's not needed. And in other way, if I will not use PA14 at all,
>>>> the pin will goes down every spi transfer.
>>>
>>> You must not assumed that the pins are muxed to their default state
>>> which is gpio and you should set the pinctrl accordingly for each
>>> device.
>>>
>>> If you don't use PA14 at all, then you don't really care about its
>>> state...
>> Yes and no, what about on board is populated some chip on PA14, but for some reason at this time I don't need it and not
>> defined in DT?
>
> As long as it's populated you should define it in the DT (the DT should
> represent your hardware) and if you don't want to use the populated
> device, just set the status property to "disabled" (I'm not sure it
> works for spi subdevices though).
OK, that's good idea.

But, I again try my patch in at91sam9x5.dtsi, it works.
/ # dmesg | grep fm25
[    1.238281] fm25 spi0.0: 128 KByte fm25 fram
/ # dmesg | grep "enable pin"
[    0.343750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 45 as GPIO
[    0.343750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 45 as PIOB13 0x2000
[    0.343750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 47 as GPIO
[    0.343750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 47 as PIOB15 0x8000
[    0.347656] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 82 as GPIO
[    0.347656] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 82 as PIOC18 0x40000
[    0.347656] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 84 as GPIO
[    0.347656] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 84 as PIOC20 0x100000
[    0.351562] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 80 as GPIO
[    0.351562] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 80 as PIOC16 0x10000
[    0.351562] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 28 as GPIO
[    0.351562] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 28 as PIOA28 0x10000000
[    0.351562] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 21 as GPIO
[    0.351562] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 21 as PIOA21 0x200000
[    0.355468] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 3 as GPIO
[    0.355468] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 3 as PIOA3 0x8
[    0.355468] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 92 as GPIO
[    0.355468] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 92 as PIOC28 0x10000000
[    0.359375] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 90 as GPIO
[    0.359375] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 90 as PIOC26 0x4000000
[    0.359375] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 94 as GPIO
[    0.359375] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 94 as PIOC30 0x40000000
[    0.359375] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 30 as GPIO
[    0.363281] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 30 as PIOA30 0x40000000
[    0.363281] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 31 as GPIO
[    0.363281] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 31 as PIOA31 0x80000000
[    0.367187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 29 as GPIO
[    0.367187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 29 as PIOA29 0x20000000
[    0.367187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 89 as GPIO
[    0.367187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 89 as PIOC25 0x2000000
[    0.968750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 101 as GPIO
[    0.968750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 101 as PIOD5 0x20
[    0.968750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 100 as GPIO
[    0.968750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 100 as PIOD4 0x10
[    1.234375] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 23 as GPIO
[    1.234375] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 23 as PIOA23 0x800000
[    1.242187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 22 as GPIO
[    1.242187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 22 as PIOA22 0x400000
[    1.246093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 93 as GPIO
[    1.246093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 93 as PIOC29 0x20000000
[    1.250000] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 14 as GPIO
[    1.250000] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 14 as PIOA14 0x4000
[    1.656250] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 117 as GPIO
[    1.656250] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 117 as PIOD21 0x200000
[    1.746093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 50 as GPIO
[    1.746093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 50 as PIOB18 0x40000
[    1.746093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 48 as GPIO
[    1.746093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 48 as PIOB16 0x10000
[    1.750000] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 46 as GPIO
[    1.750000] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 46 as PIOB14 0x4000
[    1.750000] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 44 as GPIO
[    1.750000] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 44 as PIOB12 0x1000

When I try it in my boerd dts, it works too.
				spi0 {
					pinctrl_spi0_cs: spi0-cs {
						atmel,pins =
						<AT91_PIOA 23 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>,
						<AT91_PIOA 22 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>,
						<AT91_PIOC 29 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>,
						<AT91_PIOA 14 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
					};
				};

			spi0: spi@f0000000 {
				status = "okay";
				pinctrl-0 = <&pinctrl_spi0 &pinctrl_spi0_cs>;
				cs-gpios = <&pioA 23 0
					    &pioA 22 0
					    &pioC 29 0
					    &pioA 14 0>;

/ # dmesg | grep fm25
[    1.234375] fm25 spi0.0: 128 KByte fm25 fram
/ # dmesg | grep "enable pin"
[    0.332031] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 45 as GPIO
[    0.332031] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 45 as PIOB13 0x2000
[    0.332031] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 47 as GPIO
[    0.332031] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 47 as PIOB15 0x8000
[    0.332031] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 82 as GPIO
[    0.332031] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 82 as PIOC18 0x40000
[    0.335937] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 84 as GPIO
[    0.335937] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 84 as PIOC20 0x100000
[    0.335937] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 80 as GPIO
[    0.335937] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 80 as PIOC16 0x10000
[    0.339843] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 28 as GPIO
[    0.339843] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 28 as PIOA28 0x10000000
[    0.339843] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 21 as GPIO
[    0.339843] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 21 as PIOA21 0x200000
[    0.339843] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 3 as GPIO
[    0.339843] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 3 as PIOA3 0x8
[    0.343750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 92 as GPIO
[    0.343750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 92 as PIOC28 0x10000000
[    0.343750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 90 as GPIO
[    0.343750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 90 as PIOC26 0x4000000
[    0.347656] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 94 as GPIO
[    0.347656] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 94 as PIOC30 0x40000000
[    0.347656] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 30 as GPIO
[    0.347656] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 30 as PIOA30 0x40000000
[    0.351562] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 31 as GPIO
[    0.351562] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 31 as PIOA31 0x80000000
[    0.351562] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 29 as GPIO
[    0.351562] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 29 as PIOA29 0x20000000
[    0.351562] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 89 as GPIO
[    0.351562] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 89 as PIOC25 0x2000000
[    0.964843] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 101 as GPIO
[    0.964843] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 101 as PIOD5 0x20
[    0.964843] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 100 as GPIO
[    0.964843] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 100 as PIOD4 0x10
[    1.230468] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 23 as GPIO
[    1.230468] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 23 as PIOA23 0x800000
[    1.238281] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 22 as GPIO
[    1.238281] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 22 as PIOA22 0x400000
[    1.242187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 93 as GPIO
[    1.242187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 93 as PIOC29 0x20000000
[    1.246093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 14 as GPIO
[    1.246093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 14 as PIOA14 0x4000
[    1.652343] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 117 as GPIO
[    1.652343] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 117 as PIOD21 0x200000
[    1.742187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 50 as GPIO
[    1.742187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 50 as PIOB18 0x40000
[    1.742187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 48 as GPIO
[    1.742187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 48 as PIOB16 0x10000
[    1.746093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 46 as GPIO
[    1.746093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 46 as PIOB14 0x4000
[    1.746093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 44 as GPIO
[    1.746093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 44 as PIOB12 0x1000

When not, it doesn't work.
			spi0: spi@f0000000 {
				status = "okay";
				/*pinctrl-0 = <&pinctrl_spi0 &pinctrl_spi0_cs>;*/
				cs-gpios = <&pioA 23 0
					    &pioA 22 0
					    &pioC 29 0
					    &pioA 14 0>;

/ # dmesg | grep fm25
/ # dmesg | grep "enable pin"
[    0.328125] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 45 as GPIO
[    0.328125] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 45 as PIOB13 0x2000
[    0.328125] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 47 as GPIO
[    0.328125] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 47 as PIOB15 0x8000
[    0.328125] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 82 as GPIO
[    0.328125] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 82 as PIOC18 0x40000
[    0.332031] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 84 as GPIO
[    0.332031] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 84 as PIOC20 0x100000
[    0.332031] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 80 as GPIO
[    0.332031] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 80 as PIOC16 0x10000
[    0.335937] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 28 as GPIO
[    0.335937] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 28 as PIOA28 0x10000000
[    0.335937] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 21 as GPIO
[    0.335937] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 21 as PIOA21 0x200000
[    0.339843] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 3 as GPIO
[    0.339843] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 3 as PIOA3 0x8
[    0.339843] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 92 as GPIO
[    0.339843] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 92 as PIOC28 0x10000000
[    0.343750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 90 as GPIO
[    0.343750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 90 as PIOC26 0x4000000
[    0.343750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 94 as GPIO
[    0.343750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 94 as PIOC30 0x40000000
[    0.347656] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 30 as GPIO
[    0.347656] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 30 as PIOA30 0x40000000
[    0.347656] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 31 as GPIO
[    0.347656] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 31 as PIOA31 0x80000000
[    0.347656] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 29 as GPIO
[    0.347656] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 29 as PIOA29 0x20000000
[    0.351562] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 89 as GPIO
[    0.351562] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 89 as PIOC25 0x2000000
[    0.968750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 101 as GPIO
[    0.968750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 101 as PIOD5 0x20
[    0.968750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 100 as GPIO
[    0.968750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 100 as PIOD4 0x10
[    1.238281] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 23 as GPIO
[    1.238281] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 23 as PIOA23 0x800000
[    1.238281] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 22 as GPIO
[    1.238281] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 22 as PIOA22 0x400000
[    1.242187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 93 as GPIO
[    1.242187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 93 as PIOC29 0x20000000
[    1.246093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 14 as GPIO
[    1.246093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 14 as PIOA14 0x4000
[    1.652343] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 117 as GPIO
[    1.652343] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 117 as PIOD21 0x200000
[    1.742187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 50 as GPIO
[    1.742187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 50 as PIOB18 0x40000
[    1.742187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 48 as GPIO
[    1.742187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 48 as PIOB16 0x10000
[    1.746093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 46 as GPIO
[    1.746093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 46 as PIOB14 0x4000
[    1.746093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 44 as GPIO
[    1.746093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 44 as PIOB12 0x1000

>
>
>
>
