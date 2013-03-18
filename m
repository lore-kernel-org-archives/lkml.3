Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab3CRJJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:09:40 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:54220 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3CRJJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:09:39 -0400
MIME-Version: 1.0
In-Reply-To: <5146D326.4080905@ti.com>
References: <1363429052-1081-1-git-send-email-prabhakar.csengg@gmail.com>
 <1363429052-1081-2-git-send-email-prabhakar.csengg@gmail.com> <5146D326.4080905@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 18 Mar 2013 14:39:17 +0530
Message-ID: <CA+V-a8sFeMOnd=iKWran+Y8pTcSD1pxEF+pcAWqgY6pw6Fq7Zg@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] ARM: davinci: dm355: add support for v4l2 video display
To: Sekhar Nori <nsekhar@ti.com>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sekhar,

On Mon, Mar 18, 2013 at 2:11 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On 3/16/2013 3:47 PM, Prabhakar lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> Create platform devices for various video modules like venc,osd,
>> vpbe and v4l2 driver for dm355.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> Comments on the DM365 series apply to this one too. In addition:
>
OK.

>> +static int dm355_vpbe_setup_pinmux(enum v4l2_mbus_pixelcode if_type,
>> +                         int field)
>>  {
>> -     vpfe_capture_dev.dev.platform_data = cfg;
>> +     switch (if_type) {
>> +     case V4L2_MBUS_FMT_SGRBG8_1X8:
>> +             davinci_cfg_reg(DM355_VOUT_FIELD_G70);
>> +             break;
>> +
>> +     case V4L2_MBUS_FMT_YUYV10_1X20:
>> +             /*
>> +              * This was VPBE_DIGITAL_IF_YCC16. Replace the enum
>
> "was VPBE_DIGITAL_IF_YCC16" when? This is the first time this code is
> getting in.
>
>> +              * accordingly when the right one gets into open source
>
> What is the "right one"? And "open source" == kernel? Then may be just
> call it that.
>
Ah this comment doesn't make any sense ' V4L2_MBUS_FMT_YUYV10_1X20'
is the correct one itself. I'll remove this comment.

>> +              */
>> +             if (field)
>> +                     davinci_cfg_reg(DM355_VOUT_FIELD);
>> +             else
>> +                     davinci_cfg_reg(DM355_VOUT_FIELD_G70);
>> +             break;
>> +
>> +     default:
>> +             return -EINVAL;
>> +     }
>> +
>> +     davinci_cfg_reg(DM355_VOUT_COUTL_EN);
>> +     davinci_cfg_reg(DM355_VOUT_COUTH_EN);
>> +
>> +     return 0;
>>  }
>>
>> +static inline u32 dm355_reg_modify(void *reg, u32 val, u32 mask)
>> +{
>> +     u32 new_val = (readl(reg) & ~mask) | (val & mask);
>> +
>> +     writel(new_val, reg);
>> +
>> +     return new_val;
>> +}
>
> This function needs to be removed.
>
Ah missed, I wonder how the compiler didn't catch it!

Regards,
--Prabhakar

> Thanks,
> Sekhar
