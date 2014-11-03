Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaKCVMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:12:18 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:48710 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaKCVMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:12:14 -0500
MIME-Version: 1.0
In-Reply-To: <tip-2c7577a7583747c9b71f26dced7f696b739da745@git.kernel.org>
References: <bf6fb790787eb95b922157838f52712c25dda157.1412187233.git.luto@amacapital.net>
 <tip-2c7577a7583747c9b71f26dced7f696b739da745@git.kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Nov 2014 13:11:51 -0800
Message-ID: <CALCETrWM2wVynp1rrip9AWtNYDzjC4M8JqKR82ew5dpyrTWMgA@mail.gmail.com>
Subject: Re: [tip:x86/asm] sched/x86_64: Don't save flags on context switch
To: Andy Lutomirski <luto@amacapital.net>, Jan Beulich <jbeulich@suse.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sebastian Lackner <sebastian@fds-team.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, Anish Bhatt <anish@chelsio.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 4:14 AM, tip-bot for Andy Lutomirski
<tipbot@zytor.com> wrote:
> Commit-ID:  2c7577a7583747c9b71f26dced7f696b739da745
> Gitweb:     http://git.kernel.org/tip/2c7577a7583747c9b71f26dced7f696b739da745
> Author:     Andy Lutomirski <luto@amacapital.net>
> AuthorDate: Wed, 1 Oct 2014 11:28:25 -0700
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 28 Oct 2014 11:11:30 +0100
>
> sched/x86_64: Don't save flags on context switch
>
> Now that the kernel always runs with clean flags (in particular,
> NT is clear), there is no need to save and restore flags on
> every context switch.

Just to make myself a little more comfortable with this...

There is one potentially relevant flag: AC.  I think this is still OK.
If we schedule with STAC set, then we've already screwed up, I think.
Even preempt schedules from interrupt context, so if we schedule due
to preemption or #PF in the middle of uaccess, AC should be saved and
cleared by whatever interrupt caused the reschedule, right?

And do we ever have TF set during a context switch?  I hope not.

Also, what's with 'jmp exit_intr' at the end of retint_kernel?  Why
isn't that 'jmp retint_kernel'?

--Andy
