Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbaGXPGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:06:52 -0400
Received: from router.aksignal.cz ([188.175.113.102]:45103 "EHLO
	router.aksignal.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759127AbaGXPGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:06:48 -0400
Message-ID: <53D12103.3020103@aksignal.cz>
Date: Thu, 24 Jul 2014 17:06:43 +0200
From: =?UTF-8?B?SmnFmcOtIFByY2hhbA==?= <jiri.prchal@aksignal.cz>
Reply-To: jiri.prchal@aksignal.cz
Organization: AK signal Brno
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Bo Shen <voice.shen@atmel.com>, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: at91sam9x5: sets NPCS0 (PA14) back to GPIO
References: <1405074175-22444-1-git-send-email-voice.shen@atmel.com>	<53D10C50.50305@aksignal.cz> <20140724162645.4e19c26c@bbrezillon>
In-Reply-To: <20140724162645.4e19c26c@bbrezillon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Dne 24.7.2014 v 16:26 Boris BREZILLON napsal(a):
> Hello Jiří,
>
> First of all, please try to use git format-patch when submitting a
> patch to any kernel mailing list.
Sorry for that.
>
> On Thu, 24 Jul 2014 15:38:24 +0200
> Jiří Prchal <jiri.prchal@aksignal.cz> wrote:
>
>> After ROMBOOT tries boot from flash on SPI0 NPCS0, this NPCS0 (PA14) remains set to PERIPH_A.
>> Because of that, this pin is unusable to something else.
>> This patch sets it back to GPIO.
>
> The policy is to leave pins in an unknown state till some peripheral
> need them.
>
> What are you trying to use this pin for ?
For chip select, but #3. And when SPI communicate with cs0 (PA22), it goes down too (PA14), so 2 devices on bus were 
selected.
> If you just want to use it as a chip select for an spi device, take a
> look at [1].
At [1] it's OK until as cs0 is for example PA22 and cs1 is PA14.
>
> Here the gpio is requested by the spi core when defining the cs-gpios
> property. The gpio controller then request the listed pins to the pin
> controller (pinctrl driver).
GPIO is not set in driver as GPIO, at least I didn't find it.
>
> You can explicitly define a new pinctrl state (by defining a new
> pinctrl_spi0_cs0 subnode in your dts file) and reference it in the
> spi0 node, though this is not mandatory.
>
> Best Regards,
>
> Boris
>
> [1]http://lxr.free-electrons.com/source/arch/arm/boot/dts/at91sam9x5ek.dtsi#L85
>
