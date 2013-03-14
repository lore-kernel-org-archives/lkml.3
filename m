Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab3CNXL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 19:11:57 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:44647 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab3CNXL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 19:11:56 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBTQCce3ve9cP-Ajbtb7FSVggB_bL7Dmpq8KeG_7Gfx0Og@mail.gmail.com>
References: <20130226070247.GA14094@gmail.com>
	<CA+55aFxdR6_8734T9y2Edyotf0u-SgPPgjazFuQa1atSUGK9LA@mail.gmail.com>
	<CA+55aFziwaP21NVyVb_UP3okiX7fXoo4DQ7zudhxAwPM10_Tuw@mail.gmail.com>
	<CABPqkBR2HeDmuTVg5RA=5D0xXJbXxqSxMDf7MW0iCGnurQb7jw@mail.gmail.com>
	<CA+55aFzDMwHyPxqxNKRz0Y3vFhZOqtHMvPbvNXAD6C+-_=UAhg@mail.gmail.com>
	<CABPqkBTTY7RBSXJw4kqdd0c07Ykz-Wy8TFUQ+hzBSn=5v2yz2w@mail.gmail.com>
	<CABPqkBTh1Fph=GTOzN_2Q9coqLpiR3hcqVk1PBubUUEO7D=zsA@mail.gmail.com>
	<CABPqkBTQCce3ve9cP-Ajbtb7FSVggB_bL7Dmpq8KeG_7Gfx0Og@mail.gmail.com>
Date: Fri, 15 Mar 2013 00:11:55 +0100
Message-ID: <CABPqkBRuKzbxTr73LDpgLnq4WhadZf9VErjjcTMHoMWRwzhDGw@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
From: Stephane Eranian <eranian@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 11:53 PM, Stephane Eranian <eranian@google.com> wrote:
> On Thu, Mar 14, 2013 at 11:42 PM, Stephane Eranian <eranian@google.com> wrote:
>> On Thu, Mar 14, 2013 at 11:19 PM, Stephane Eranian <eranian@google.com> wrote:
>>> On Thu, Mar 14, 2013 at 11:17 PM, Linus Torvalds
>>> <torvalds@linux-foundation.org> wrote:
>>>> On Thu, Mar 14, 2013 at 3:09 PM, Stephane Eranian <eranian@google.com> wrote:
>>>>>
>>>>> Could be related to suspend/resume. But were you running perf across
>>>>> that resume/suspend cycle?
>>>>
>>>> No.
>>>>
>>>> In most cases I was running a perf record before and after (but not
>>>> *while* suspending)
>>>>
>>>> In at least one other crash, I didn't run perf before at all, so the
>>>> first time I used perf was after the resume.
>>>>
>>>> So in no cases did I actually have any perf stuff active over the
>>>> suspend itself.
>>>>
>>> Ok, simpler test case then.
>>>
>>>>> Let's see if we can reproduce the problem on the same ChromeBook you
>>>>> have. Don't have one myself.
>>>>
>>>> I don't imagine it should be about chromebook per se, because afaik
>>>> all of pmu suspend/resume is done by the kernel, no firmware involved.
>>>>
>>>> So I'd assume it should happen with any IvyBridge.
>>>>
>>> Will try on a desktop IvyBridge too.
>>
>> Ok, it happens on my IVB desktop too, so I can investigate...
>
> It's not specific to IVB either, it hangs on my Nehalem desktop as well.

Looks related to PEBS. If I drop the :pp the machine does not hang. Even
a single :p hangs it. So it is possible something is not properly
restored in the
DS state after a resume or is corrupted by the suspend.
