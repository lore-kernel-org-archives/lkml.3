Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbaFJITF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:19:05 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:55819 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaFJITB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:19:01 -0400
Message-ID: <5396BF5E.7070805@ahsoftware.de>
Date: Tue, 10 Jun 2014 10:18:38 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: HID: hid-sensor-hub: fix sleeping function called from invalid
 context
References: <53963364.4010104@ahsoftware.de> <alpine.LNX.2.00.1406100038150.2827@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1406100038150.2827@pobox.suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.06.2014 00:40, schrieb Jiri Kosina:
> On Tue, 10 Jun 2014, Alexander Holler wrote:
> 
>> Hello,
>>
>> while rebasing the dozens (currently around 60) of refused, ignored or
>> similiar bugfixes and patches I need to use a Linux kernel, I've noticed that
>> Jiri Kosinas patch here
>>
>> https://lkml.org/lkml/2013/8/9/214
>>
>> doesn't apply anymore.
>>
>> Looking why, I've seen that a similiar patch from Srinivas Pandruvada named
>> like the topic ended up in the kernel.
> 
> Hi Alexander,
> 
> thanks for drawing this one from the boulevard of forgotten patches.
> 
> I am actually not aware of any patch by Srinivas that would conflict with 
> the one I've written -- could you please elaborate where you believe the 
> conflict is?

I actually don't rebase from main-version to main-version (that doesn't
really work), but I'm using format-patch and git am. It's a bit more
strict when that's ok. I haven't looked in deep which changes in 3.15 do
conflict with the patch based on 3.14, but it't can't be that much.

>> Looking at the differences, I wonder if not all spin_lock() calls in 
>> hid-sensor-hub.c should be changed into spin_lock_irqsave() like the 
>> patch from Jiri Kosina did.
> 
> Could you please give me your Tested-by:? I'll then be happily queuing the 
> fix. Thanks.

Sure, but I already did that in the reply to your patch.

>> (sorry for the duplicate message, I've forgotten to add the
>> wanna-be-reviewer-school named lkml to the recipients)
> 
> You want to make it to LWN quotes of the week, don't you? :)

No, I'm just too often the object of their first steps and that's why I
won't post any patches on lkml anymore. It might be fun for them to do
reviews on patches from innocent people, but those victims usually don't
share their view. Maybe I will choose full disclosure or similiar I ever
will have an important patch poor Linux users should really have a need for.

Regards,

Alexander Holler
