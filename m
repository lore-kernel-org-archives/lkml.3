Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3KMFUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 00:20:46 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33449 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3KMFUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 00:20:38 -0500
MIME-Version: 1.0
In-Reply-To: <52827DBC.9040606@gmail.com>
References: <1384268572-27055-1-git-send-email-kasimling@gmail.com> <52827DBC.9040606@gmail.com>
From: kasim ling <kasimling@gmail.com>
Date: Wed, 13 Nov 2013 13:20:17 +0800
Message-ID: <CAHaF_kgg5uizqQOBvG4a_PBXjgsafdq7Jsw+LP97d=h3z1baoQ@mail.gmail.com>
Subject: Re: ARM: dts: add board dts file for EXYNOS4412 based TINY4412 board
To: Rob Herring <robherring2@gmail.com>
Cc: mark.rutland@arm.com, linux@arm.linux.org.uk, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 3:13 AM, Rob Herring <robherring2@gmail.com> wrote:
> On 11/12/2013 09:02 AM, Alex Ling wrote:
>> Add a minimal board dts file for EXYNOS4412 based FriendlyARM's
>> TINY4412 board. This patch including adds the node to support
>> peripherals like UART, SD card on SDMMC2 port, and this patch
>> adds GPIO connected LEDS and configure its properties like
>> following:
>> LED1: use 'heartbeat' trigger, blinking while the board is running.
>> LED4: use 'mmc0' trigger, on when mmc0 is accessing.
>> LED2 and LED3 can be controlled from userspace.
>
> Please send patches with [PATCH] prefix.
Well noted. Thanks.
>
>> Signed-off-by: Alex Ling <kasimling@gmail.com>
>> ---
>>  arch/arm/boot/dts/Makefile                |    1 +
>>  arch/arm/boot/dts/exynos4412-tiny4412.dts |   89 +++++++++++++++++++++++++++++
>>  2 files changed, 90 insertions(+)
>>  create mode 100644 arch/arm/boot/dts/exynos4412-tiny4412.dts
>>
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index 802720e..91671a2 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -59,6 +59,7 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
>>       exynos4412-odroidx.dtb \
>>       exynos4412-origen.dtb \
>>       exynos4412-smdk4412.dtb \
>> +     exynos4412-tiny4412.dtb \
>>       exynos4412-trats2.dtb \
>>       exynos5250-arndale.dtb \
>>       exynos5250-smdk5250.dtb \
>> diff --git a/arch/arm/boot/dts/exynos4412-tiny4412.dts b/arch/arm/boot/dts/exynos4412-tiny4412.dts
>> new file mode 100644
>> index 0000000..78ace14
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/exynos4412-tiny4412.dts
>> @@ -0,0 +1,89 @@
>> +/*
>> + * FriendlyARM's Exynos4412 based TINY4412 board device tree source
>> + *
>> + * Copyright (c) 2013 Alex Ling <kasimling@gmail.com>
>> + *
>> + * Device tree source file for FriendlyARM's TINY4412 board which is based on
>> + * Samsung's Exynos4412 SoC.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> +*/
>> +
>> +/dts-v1/;
>> +#include "exynos4412.dtsi"
>> +
>> +/ {
>> +     model = "FriendlyARM TINY4412 board based on Exynos4412";
>> +     compatible = "friendlyarm,tiny4412", "samsung,exynos4412";
>
> The compatible string needs to be documented.
Could you please advise where this should be documented to? I'm not
sure if "Documentation/devicetree/bindings/arm/samsung-boards.txt" is
a proper place or not.
>
> Rob
>
>> +
>> +     memory {
>> +             reg = <0x40000000 0x40000000>;
>> +     };
>> +
>> +     leds {
>> +             compatible = "gpio-leds";
>> +             led1 {
>> +                     label = "led1:heart";
>> +                     gpios = <&gpm4 0 1>;
>> +                     default-state = "off";
>> +                     linux,default-trigger = "heartbeat";
>> +             };
>> +             led2 {
>> +                     label = "led2";
>> +                     gpios = <&gpm4 1 1>;
>> +                     default-state = "off";
>> +             };
>> +             led3 {
>> +                     label = "led3";
>> +                     gpios = <&gpm4 2 1>;
>> +                     default-state = "off";
>> +             };
>> +             led4 {
>> +                     label = "led4:mmc0";
>> +                     gpios = <&gpm4 3 1>;
>> +                     default-state = "off";
>> +                     linux,default-trigger = "mmc0";
>> +             };
>> +     };
>> +
>> +     rtc@10070000 {
>> +             status = "okay";
>> +     };
>> +
>> +     sdhci@12530000 {
>> +             bus-width = <4>;
>> +             pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_cd &sd2_bus4>;
>> +             pinctrl-names = "default";
>> +             status = "okay";
>> +     };
>> +
>> +     serial@13800000 {
>> +             status = "okay";
>> +     };
>> +
>> +     serial@13810000 {
>> +             status = "okay";
>> +     };
>> +
>> +     serial@13820000 {
>> +             status = "okay";
>> +     };
>> +
>> +     serial@13830000 {
>> +             status = "okay";
>> +     };
>> +
>> +     fixed-rate-clocks {
>> +             xxti {
>> +                     compatible = "samsung,clock-xxti";
>> +                     clock-frequency = <0>;
>> +             };
>> +
>> +             xusbxti {
>> +                     compatible = "samsung,clock-xusbxti";
>> +                     clock-frequency = <24000000>;
>> +             };
>> +     };
>> +};
>>
>

BR,
Alex
