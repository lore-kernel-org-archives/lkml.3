Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572AbaJ3QeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:34:19 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:33145 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867AbaJ3QeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:34:17 -0400
Message-ID: <54526862.4000700@gmail.com>
Date: Thu, 30 Oct 2014 18:33:38 +0200
From: Giedrius Statkevicius <giedriuswork@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Darren Hart <dvhart@infradead.org>
CC: eric.piel@tremplin-utc.net, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform: hp_accel: add a i8042 filter to remove HPQ6000
 data from kb bus stream
References: <1414610182-28702-1-git-send-email-giedriuswork@gmail.com> <20141030014056.GD14609@vmdeb7> <20141030162852.GA36444@dtor-ws>
In-Reply-To: <20141030162852.GA36444@dtor-ws>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.10.30 18:28, Dmitry Torokhov wrote:
> On Wed, Oct 29, 2014 at 06:40:56PM -0700, Darren Hart wrote:
>> On Wed, Oct 29, 2014 at 09:16:22PM +0200, Giedrius Statkevicius wrote:
>>> Add a i8042 filter to hp_accel to remove accelerometer's data with acpi
>>> id HPQ6000 from keyboard bus stream. The codes sent by accelerometer are
>>> e0 25, e0 26, e0 27 and e0 28. The relevant information is already
>>> passed through /dev/freefall so no need to send these undocumented weird
>>> signals through the keyboard bus. Also, unclogs `dmesg` because atkbd
>>> complained about weird scan codes, saves processing power and disk
>>> space.
>>>
>>> Signed-off-by: Giedrius Statkevičius <giedriuswork@gmail.com>
>>> ---
>>> First of all, any Tested-Bys are very welcome by people who also have a
>>> accelerometer with acpi id HPQ6000. If it happens with HPQ6007 too we
>>> can easily modify this to install the filter when HPQ6007 is detected.
>>> For the time being the filter is only installed when HPQ6000 is
>>> detected. 
>>>
>>> Now moving to what was changed since the RFC. I reworked the filter
>>> function to hopefully make it more clear what it is doing. Since the
>>> codes sent by the accelerometer are extended then we need to filter all
>>> of 0xe0's and then send one 0xe0 back when the actual key isn't in the
>>> range of 0x25-0x28. Also, I've removed the check for errors for
>>> i8042_install_filter() because it's unnecessary to check if it failed.
>>> If multiple HPQ6000's are in the system then no issue occurs even if
>>> multiple i8042_install_filter() are issued because this is handled by
>>> i8042 and it's smart enough not to install the same filter two or more
>>> times.
>>>
>>>  drivers/platform/x86/hp_accel.c | 45 ++++++++++++++++++++++++++++++++++++++++-
>>>  1 file changed, 44 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
>>> index 13e14ec..a751621 100644
>>> --- a/drivers/platform/x86/hp_accel.c
>>> +++ b/drivers/platform/x86/hp_accel.c
>>> @@ -38,6 +38,8 @@
>>>  #include <linux/atomic.h>
>>>  #include <linux/acpi.h>
>>>  #include "../../misc/lis3lv02d/lis3lv02d.h"
>>> +#include <linux/i8042.h>
>>> +#include <linux/serio.h>
>>
>> Please include before the relative path includes.
>>
>> Otherwise, I'm happy with this - but I'd like a serio / i8042 person to weigh
>> in.... Dmitry?
> 
> Yes, this is fine. Such uses with platform injecting weird bits into
> keyboard/mouse data stream was the reason for introducing i8042 filter
> facility.
> 
> I ma not sure what is more efficient, a case with 5 branches or
> strchr(), but regardless:
> 
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> Thanks.
> 

I'll resend the v2 in a minute. The changes in that patch:
* Move the two new includes before the relative include of lis3lv02d.h
* Remove a unnecessary deletion of a blank line

Thanks,
Giedrius
