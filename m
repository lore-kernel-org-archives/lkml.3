Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab3CUSdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:33:04 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:48359 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3CUSdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:33:01 -0400
MIME-Version: 1.0
In-Reply-To: <5149FFDF.6050501@ti.com>
References: <1363075109-27038-1-git-send-email-silviupopescu1990@gmail.com>
	<20130312110557.GF30923@n2100.arm.linux.org.uk>
	<5149FFDF.6050501@ti.com>
Date: Thu, 21 Mar 2013 20:33:01 +0200
Message-ID: <CAPWTe+JYEZJ5Zn6Dt9mmr38raXdM8wc1eWFro2a4Czy-eCzSpQ@mail.gmail.com>
Subject: Re: [PATCH] mach_omap2: use PTR_RET instead of IS_ERR + PTR_ERR
From: Silviu Popescu <silviupopescu1990@gmail.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 8:28 PM, Jon Hunter <jon-hunter@ti.com> wrote:
>
> On 03/12/2013 06:05 AM, Russell King - ARM Linux wrote:
>> On Tue, Mar 12, 2013 at 09:58:29AM +0200, Silviu-Mihai Popescu wrote:
>>> This uses PTR_RET instead of IS_ERR and PTR_ERR in order to increase
>>> readability.
>>>
>>> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
>>> ---
>>>  arch/arm/mach-omap2/devices.c |    4 ++--
>>>  arch/arm/mach-omap2/fb.c      |    5 +----
>>>  arch/arm/mach-omap2/gpmc.c    |    2 +-
>>>  arch/arm/mach-omap2/pmu.c     |    5 +----
>>>  4 files changed, 5 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
>>> index 1ec7f05..2a0816e 100644
>>> --- a/arch/arm/mach-omap2/devices.c
>>> +++ b/arch/arm/mach-omap2/devices.c
>>> @@ -66,7 +66,7 @@ static int __init omap3_l3_init(void)
>>>
>>>      WARN(IS_ERR(pdev), "could not build omap_device for %s\n", oh_name);
>>>
>>> -    return IS_ERR(pdev) ? PTR_ERR(pdev) : 0;
>>> +    return PTR_RET(pdev);
>>
>> This is incorrect.
>>
>> The return value will be tested for < 0.  Kernel pointers in general are
>> all above 3GB, and so are all "< 0".
>>
>> I'm afraid none of these changes stuff is an improvement - they all
>> introduce bugs.
>
> Sorry I am now not sure I follow you here. Someone just pointed out to
> me that PTR_RET() is defined as ...
>
> static inline int __must_check PTR_RET(const void *ptr)
> {
>         if (IS_ERR(ptr))
>                 return PTR_ERR(ptr);
>         else
>                 return 0;
> }
>
> So the above change appears to be equivalent. Is there something that is
> wrong with the current implementation that needs to be fixed?


As the patch message says, it's just for readability purposes.
I used make coccicheck and it suggested this minor change.

--
Silviu Popescu
