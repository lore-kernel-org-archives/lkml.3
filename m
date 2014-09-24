Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaIXLtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:49:22 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:46492 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaIXLtU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:49:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140924110602.GI19999@lee--X1>
References: <5439652.jHp5aCCfrZ@lenovobook>
	<20140924110602.GI19999@lee--X1>
Date: Wed, 24 Sep 2014 13:49:18 +0200
Message-ID: <CAJKbBDDpAULVFjr058qRz7rV3y5DEnnxeA9n5xtGW1Fu6YLr=A@mail.gmail.com>
Subject: Re: [PATCH] mfd: tps65217: add compatible string for subdevices
From: Johannes Pointner <johannes.pointner@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, AnilKumar Ch <anilkumar@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-24 13:06 GMT+02:00 Lee Jones <lee.jones@linaro.org>:
> On Mon, 22 Sep 2014, Johannes Pointner wrote:
>
>> The TPS65217 is missing of_compatible string in the mfd_cell for its
>> subdevices. This compatible string is necessary to use functions like
>> of_find_backlight_by_node in backlight.c.
>>
>> Signed-off-by: Johannes Pointner <johannes.pointner@br-automation.com>
>> ---
>>  Documentation/devicetree/bindings/regulator/tps65217.txt            | 5 ++++-
>>  .../devicetree/bindings/video/backlight/tps65217-backlight.txt      | 6 +++---
>>  drivers/mfd/tps65217.c                                              | 2 ++
>>  3 files changed, 9 insertions(+), 4 deletions(-)
>
> [...]
>
>> diff --git a/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt b/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
>> index 5fb9279..c3fb649 100644
>> --- a/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
>> +++ b/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
>> @@ -7,18 +7,18 @@ Required properties:
>>  - compatible: "ti,tps65217"
>>  - reg: I2C slave address
>>  - backlight: node for specifying WLED1 and WLED2 lines in TPS65217
>> +- compatible: "ti,tps65217-bl"
>
> This is now confusing.  Please make it clear that this part of the
> documentation is now referencing the sub-node.

I will add a Subnode properties label, to make it clearer.

>
>>  - isel: selection bit, valid values: 1 for ISEL1 (low-level) and 2 for ISEL2 (high-level)
>>  - fdim: PWM dimming frequency, valid values: 100, 200, 500, 1000
>>  - default-brightness: valid values: 0-100
>>
>> -Each regulator is defined using the standard binding for regulators.
>> -
>>  Example:
>>
>>       tps: tps@24 {
>>               reg = <0x24>;
>>               compatible = "ti,tps65217";
>> -             backlight {
>> +             tps_bl: backlight {
>> +                     compatible = "ti,tps65217-bl";
>>                       isel = <1>;  /* 1 - ISET1, 2 ISET2 */
>>                       fdim = <100>; /* TPS65217_BL_FDIM_100HZ */
>>                       default-brightness = <50>;
>> diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
>
> This shouldn't be in this patch.
>
> Please adhere to: Documentation/devicetree/bindings/submitting-patches.txt

I will split the patch.
>
>> index 3cc4c70..77708f9 100644
>> --- a/drivers/mfd/tps65217.c
>> +++ b/drivers/mfd/tps65217.c
>> @@ -33,9 +33,11 @@
>>  static const struct mfd_cell tps65217s[] = {
>>       {
>>               .name = "tps65217-pmic",
>> +             .of_compatible = "ti,tps65217-pmic",
>>       },
>>       {
>>               .name = "tps65217-bl",
>> +             .of_compatible = "ti,tps65217-bl",
>>       },
>>  };
>>
>
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

Thank you for your feedback. I'll resend the patches with the modifications.
