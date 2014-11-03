Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaKCWSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:18:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52413 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaKCWSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:18:05 -0500
Message-ID: <5457FEF8.3050603@zytor.com>
Date: Mon, 03 Nov 2014 14:17:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Jan Beulich <jbeulich@suse.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sebastian Lackner <sebastian@fds-team.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, Anish Bhatt <anish@chelsio.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>
CC: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/asm] sched/x86_64: Don't save flags on context switch
References: <bf6fb790787eb95b922157838f52712c25dda157.1412187233.git.luto@amacapital.net> <tip-2c7577a7583747c9b71f26dced7f696b739da745@git.kernel.org> <CALCETrWM2wVynp1rrip9AWtNYDzjC4M8JqKR82ew5dpyrTWMgA@mail.gmail.com>
In-Reply-To: <CALCETrWM2wVynp1rrip9AWtNYDzjC4M8JqKR82ew5dpyrTWMgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2014 01:11 PM, Andy Lutomirski wrote:
> On Tue, Oct 28, 2014 at 4:14 AM, tip-bot for Andy Lutomirski
> <tipbot@zytor.com> wrote:
>> Commit-ID:  2c7577a7583747c9b71f26dced7f696b739da745
>> Gitweb:     http://git.kernel.org/tip/2c7577a7583747c9b71f26dced7f696b739da745
>> Author:     Andy Lutomirski <luto@amacapital.net>
>> AuthorDate: Wed, 1 Oct 2014 11:28:25 -0700
>> Committer:  Ingo Molnar <mingo@kernel.org>
>> CommitDate: Tue, 28 Oct 2014 11:11:30 +0100
>>
>> sched/x86_64: Don't save flags on context switch
>>
>> Now that the kernel always runs with clean flags (in particular,
>> NT is clear), there is no need to save and restore flags on
>> every context switch.
> 
> Just to make myself a little more comfortable with this...
> 
> There is one potentially relevant flag: AC.  I think this is still OK.
> If we schedule with STAC set, then we've already screwed up, I think.
> Even preempt schedules from interrupt context, so if we schedule due
> to preemption or #PF in the middle of uaccess, AC should be saved and
> cleared by whatever interrupt caused the reschedule, right?
> 
> And do we ever have TF set during a context switch?  I hope not.
> 
> Also, what's with 'jmp exit_intr' at the end of retint_kernel?  Why
> isn't that 'jmp retint_kernel'?
> 

AC is saved by interrupts and cleared by IRET.  We execute CLAC in all
the interrupt entry paths.

	-hpa


