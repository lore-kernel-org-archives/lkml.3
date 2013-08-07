Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab3HGMrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 08:47:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59325 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932819Ab3HGMpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 08:45:35 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: monstr@monstr.eu
Subject: Re: [PATCH] [V2] gpio: New driver for LSI ZEVIO SoCs
References: <1375818804-13053-1-git-send-email-fabian@ritter-vogt.de>
 <5201F2CD.8060301@monstr.eu>
Date: Wed, 07 Aug 2013 14:51:58 +0200
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Linus Walleij" <linus.walleij@linaro.org>, grant.likely@linaro.org,
        pawel.moll@arm.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Fabian Vogt" <fabian@ritter-vogt.de>
Message-ID: <op.w1f50wocu7prd4@fabians-laptop.fritz.box>
In-Reply-To: <5201F2CD.8060301@monstr.eu>
User-Agent: Opera Mail/12.15 (Linux)
X-Provags-ID: V02:K0:scihHDrtbdXwwF1B6JD/Ji5d6ytU5PWIlaiCIuQYSXk
 8tnI2rX1x9nS8WVS8ZtSAFc/Fq71BOBKEjiBoYXGY/CLad600M
 IxwB7cQyMA7hFEUcsjCGcK8PeKEqGIZNCZlLQo4lk6jtWhmNFV
 JiGlf6+xaNXdASOo+GOVhBgBtQeCodQc05ywkeMxf1Y5i0bjtc
 4lhLSs0f13JxFhplZJljRxwmEj4PuzL2dW5JYeGaGHXYoYYRRb
 NznA3LUEtcJZfURFBAM9YI002KloNrojV9mh3HWIptB8J1YDnC
 aANoYOv62z3ep4UluDs6Ob3qV7DH+rlyAPxtBBUYtIDv4sYU51
 Caq0pq4su2VdE9LLx3RuAx+Bi7blsYgmU2eMVkmeh0eQnGUfep
 5au6KZjP2Zugw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/gpio/gpio-zevio.txt
>> @@ -0,0 +1,19 @@
>> +Zevio GPIO controller
>> +
>> +Required properties:
>> +- compatible = "lsi,zevio-gpio"
>> +- reg = <BASEADDR SIZE>
>> +- #gpio-cells = <2>
>> +- gpio-controller;
>> +
>> +Optional:
>> +- #ngpios = <32>: Number of GPIOs. Defaults to 32 if absent
>> +
>> +Example:
>> +	gpio: gpio@90000000 {
>> +		compatible = "lsi,zevio-gpio";
>> +		reg = <0x90000000 0x1000>;
>> +	
>
> <tab> here and I can't see the reason to have this blank line here.
>
>> +		gpio-controller;
>> +		#gpio-cells = <2>;
>> +	};
>> \ No newline at end of file
>
> Doesn't look right.
>
>> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
>> index b2450ba..ba8c357 100644
>> --- a/drivers/gpio/Kconfig
>> +++ b/drivers/gpio/Kconfig
>> @@ -138,6 +138,13 @@ config GPIO_EP93XX
>>  	depends on ARCH_EP93XX
>>  	select GPIO_GENERIC
>>
>> +config GPIO_ZEVIO
>> +	bool "LSI ZEVIO SoC memory mapped GPIOs"
>> +	depends on ARCH_NSPIRE
>> +	select GENERIC_IRQ_CHIP
>> +	help
>> +	  Say yes here to support the GPIO controller in LSI ZEVIO SoCs.
>> +
>
> Not sure how subsystem maintainer handle this but I would prefer
> to keep this sorted as it is done in Makefile.

Yes, but without the gpio-zevio.c file the Kconfig item and the Makefile
entry wouldn't work and vice-versa. The three latest patches which added  
GPIO
drivers weren't split as well.

>> --- a/drivers/gpio/Makefile
>> +++ b/drivers/gpio/Makefile
>> @@ -87,3 +87,4 @@ obj-$(CONFIG_GPIO_WM831X)	+= gpio-wm831x.o
>>  obj-$(CONFIG_GPIO_WM8350)	+= gpio-wm8350.o
>>  obj-$(CONFIG_GPIO_WM8994)	+= gpio-wm8994.o
>>  obj-$(CONFIG_GPIO_XILINX)	+= gpio-xilinx.o
>> +obj-$(CONFIG_GPIO_ZEVIO)	+= gpio-zevio.o
>> \ No newline at end of file
>
> ditto.
>
> The patch contains several trailing whitespace reported by checkpatch.pl
> which should be fixed.
Oh, I accidentially sent the uncleaned version of the patch, sorry.
I'll resend the cleaned version as V3.

Bye,
Fabian
