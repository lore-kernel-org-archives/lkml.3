Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab3CNI7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:59:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47189 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab3CNI7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:59:07 -0400
Message-ID: <5141914F.2070203@ti.com>
Date: Thu, 14 Mar 2013 14:28:55 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH v5 2/2] ARM: davinci: dm365 EVM: add support for VPBE
 display
References: <1354522904-22501-1-git-send-email-prabhakar.lad@ti.com> <1354522904-22501-3-git-send-email-prabhakar.lad@ti.com> <50BDF925.3090700@ti.com> <CA+V-a8t8cTqmLb86j1tjT0x-L4_zc-6V+ZZmJiW9xoKSvbTbvQ@mail.gmail.com>
In-Reply-To: <CA+V-a8t8cTqmLb86j1tjT0x-L4_zc-6V+ZZmJiW9xoKSvbTbvQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/2013 2:09 PM, Prabhakar Lad wrote:
> Hi Sekhar,
> 
> On Tue, Dec 4, 2012 at 6:52 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>> On 12/3/2012 1:51 PM, Prabhakar Lad wrote:
>>> From: Manjunath Hadli <manjunath.hadli@ti.com>
>>>
>>> add support for V4L2 video display to DM365 EVM.
>>> Support for SD and ED modes is provided, along with Composite
>>> and Component outputs.
>>>
>>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>>> ---
>>>  arch/arm/mach-davinci/board-dm365-evm.c |  177 ++++++++++++++++++++++++++++++-
>>>  1 files changed, 176 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
>>> index 0c3dae6..10f2a85 100644
>>> --- a/arch/arm/mach-davinci/board-dm365-evm.c
>>> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
>>> @@ -27,6 +27,7 @@
>>>  #include <linux/input.h>
>>>  #include <linux/spi/spi.h>
>>>  #include <linux/spi/eeprom.h>
>>> +#include <linux/v4l2-dv-timings.h>
>>>
>>>  #include <asm/mach-types.h>
>>>  #include <asm/mach/arch.h>
>>> @@ -374,6 +375,180 @@ static struct vpfe_config vpfe_cfg = {
>>>       .ccdc = "ISIF",
>>>  };
>>>
>>> +/* venc standards timings */
>>> +static struct vpbe_enc_mode_info dm365evm_enc_std_timing[] = {
>>> +     {
>>> +             .name           = "ntsc",
>>> +             .timings_type   = VPBE_ENC_STD,
>>> +             .std_id         = V4L2_STD_525_60,
>>> +             .interlaced     = 1,
>>> +             .xres           = 720,
>>> +             .yres           = 480,
>>> +             .aspect         = {11, 10},
>>> +             .fps            = {30000, 1001},
>>> +             .left_margin    = 0x79,
>>> +             .right_margin   = 0,
>>> +             .upper_margin   = 0x10,
>>> +             .lower_margin   = 0,
>>> +             .hsync_len      = 0,
>>> +             .vsync_len      = 0,
>>> +             .flags          = 0,
>>
>> I wonder what makes this entire information board specific? Shouldn't
>> these (or at least most of these) be same across all devices which
>> support NTSC and hence should be coming from some common code instead of
>> being replicated for each platform that supports NTSC?
>>
> most of the structure members are board specific,
> 
> 	struct v4l2_fract aspect;
> 	struct v4l2_fract fps;
> 	unsigned int left_margin;
> 	unsigned int right_margin;
> 	unsigned int upper_margin;
> 	unsigned int lower_margin;
> 	unsigned int hsync_len;
> 	unsigned int vsync_len;
> 	unsigned int flags;
> 
> And as of now there is no ready made structure within v4l2 which
> provides the common data. So I'll be keeping this as it is.

I am fine with this approach.

Regards,
Sekhar
