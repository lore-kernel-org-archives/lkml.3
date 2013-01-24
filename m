Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab3AXKJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:09:18 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:42732 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab3AXKJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:09:11 -0500
MIME-Version: 1.0
In-Reply-To: <5101144B.1090600@denx.de>
References: <1359018740-6399-1-git-send-email-prabhakar.lad@ti.com> <5101144B.1090600@denx.de>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 24 Jan 2013 15:38:49 +0530
Message-ID: <CA+V-a8uq++Fi80eTTXpDmYG_mpWr0HbTJhH1vSnHPCyAbgVB3A@mail.gmail.com>
Subject: Re: [PATCH RFC] media: tvp514x: add OF support
To: Heiko Schocher <hs@denx.de>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LDOC <linux-doc@vger.kernel.org>, devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Thu, Jan 24, 2013 at 4:30 PM, Heiko Schocher <hs@denx.de> wrote:
> Hello Prabhakar,
>
> On 24.01.2013 10:12, Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>
>> add OF support for the tvp514x driver.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> ---
>>  This patch is on top of following patches:
>>  1: https://patchwork.kernel.org/patch/1930941/
>>  2: http://patchwork.linuxtv.org/patch/16193/
>>  3: https://patchwork.kernel.org/patch/1944901/
>>
>>  .../devicetree/bindings/media/i2c/tvp514x.txt      |   30 ++++++++++
>>  drivers/media/i2c/tvp514x.c                        |   60 ++++++++++++++++++--
>>  2 files changed, 85 insertions(+), 5 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp514x.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp514x.txt b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
>> new file mode 100644
>> index 0000000..3cce323
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
>> @@ -0,0 +1,30 @@
>
> [...]
>> diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
>> index a4f0a70..0e2b15c 100644
>> --- a/drivers/media/i2c/tvp514x.c
>> +++ b/drivers/media/i2c/tvp514x.c
>> @@ -12,6 +12,7 @@
>>   *     Hardik Shah <hardik.shah@ti.com>
>>   *     Manjunath Hadli <mrh@ti.com>
>>   *     Karicheri Muralidharan <m-karicheri2@ti.com>
>> + *     Prabhakar Lad <prabhakar.lad@ti.com>
>>   *
>>   * This package is free software; you can redistribute it and/or modify
>>   * it under the terms of the GNU General Public License version 2 as
>> @@ -930,6 +931,50 @@ static struct tvp514x_decoder tvp514x_dev = {
>>
>>  };
>>
>> +#if defined(CONFIG_OF)
>> +static const struct of_device_id tvp514x_of_match[] = {
>> +     {.compatible = "ti,tvp514x-decoder", },
>> +     {},
>> +}
>
> Missing semicolon here. Without, gcc throws here an error
> when compiling this driver as a module.
>
Thanks for the catch, i had built it along with the kernel, I remember
similar issue with one of your patch missed it to apply here :).
I'll fix it in v2 version.

Regards,
--Prabhakar

>> +MODULE_DEVICE_TABLE(of, tvp514x_of_match);
>> +
> [...]
>
> bye,
> Heiko
> --
> DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
