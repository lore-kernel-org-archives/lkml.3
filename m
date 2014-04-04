Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaDDBlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 21:41:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43250 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaDDBlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 21:41:16 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <533E0A94.5040007@linux.intel.com>
References: <20140403021411.6236996f@gandalf.local.home> <070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com> <533D001A.5030802@linux.intel.com> <20140403094155.04cc00bc@gandalf.local.home> <533D6BE7.3020608@zytor.com> <20140403104721.5f6c32b6@gandalf.local.home> <20140403111711.5bed4ff7@gandalf.local.home> <533D7C4F.4010504@zytor.com> <533D7C93.7080105@zytor.com> <20140403113921.23dceb75@gandalf.local.home> <533D8516.1040803@zytor.com> <20140403121314.246b03a7@gandalf.local.home> <533DED74.6050202@linux.intel.com> <20140403194018.7c67aec7@gandalf.local.home> <533DF455.4040908@linux.intel.com> <533DF8D2.9060508@zytor.com> <533E0A94.5040007@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [BUG] x86: reboot doesn't reboot
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 03 Apr 2014 18:40:51 -0700
To: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Message-ID: <091fb6ee-a7e1-4962-9382-7e3b14792797@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep in mind we already tried CF9 in the default flow and it broke things.  I'm willing to wait for reports about production machines, though, but I fully expect them.

On April 3, 2014 6:27:48 PM PDT, "Li, Aubrey" <aubrey.li@linux.intel.com> wrote:
>On 2014/4/4 8:12, H. Peter Anvin wrote:
>> On 04/03/2014 04:52 PM, Li, Aubrey wrote:
>>> On 2014/4/4 7:40, Steven Rostedt wrote:
>>>> On Fri, 04 Apr 2014 07:23:32 +0800
>>>> "Li, Aubrey" <aubrey.li@linux.intel.com> wrote:
>>>>
>>>>> Can you please send the dmi table out?
>>>>
>>>> I already did as a gz attachment to H. Peter. You were on the Cc,
>did
>>>> you not receive it?
>>>>
>>> Oh, I got it. This is a Preproduction machine.
>>> When reboot failed via a method (=e or =p), there are two case.
>>>
>>> Case 1: this method do nothing, pass the attempt chance to the next
>method
>>> Case 2: this method hangs the system
>>>
>>> I want to know if CF9 is case 1 or case 2. Could you please try the
>following
>>> patch *without* any reboot parameters?
>>>
>>> (1) If we didn't see any string, then EFI hangs your box.
>>> (2) if we see the first string but not the second one, CF9 hangs
>your box
>>> (3) if we see both, couldn't be, because BIOS works on your box.
>>>
>> 
>> Given that this machine doesn't have EFI, it seems kind of obvious,
>no?
>> 
>> 	-hpa
>
>Yes. it should be but I want to confirm.
>
>The current situation is,
>- we have one(do we know more?) preproduction machine hangs by CF9.
>- We have more than one(could be thousand known) production machine
>works by CF9.
>
>So, if I understand correctly(please correct me if I was wrong), I
>don't
>think the justification is enough to revert the patch. The patch
>includes EFI, CF9 and BIOS.
>
>I'm open to make Steven's machine work:
>(1) remove CF9
>(2) add DMI table
>(3) any other idea without a regression.
>
>I prefer (2) or (3) if better because if we do (1) we will probably
>receive some other regression reports.
>
>Thanks,
>-Aubrey

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
