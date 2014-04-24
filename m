Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbaDXKBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:01:48 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:53699 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbaDXKBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvyPCwo-d92QK9qAR5=gmRS4p24tYs9PiOApBGfrKdxJ5Q@mail.gmail.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397824031-4892-14-git-send-email-lftan@altera.com>
	<CAFLxGvyPCwo-d92QK9qAR5=gmRS4p24tYs9PiOApBGfrKdxJ5Q@mail.gmail.com>
Date: Thu, 24 Apr 2014 18:01:43 +0800
X-Google-Sender-Auth: qmctBbPTAhl_-tIn34wn56Fko3I
Message-ID: <CAFiDJ5-q5hzR+1BDCmCzwqbuVZOUdjX_-omR4u3rnC8xqdQZLA@mail.gmail.com>
Subject: Re: [PATCH 17/28] nios2: Signal handling support
From: Ley Foon Tan <lftan@altera.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2014 at 3:29 AM, Richard Weinberger
<richard.weinberger@gmail.com> wrote:

>> +
>> +       /* Default to using normal stack.  */
>> +       usp = regs->sp;
>> +
>> +       /* This is the X/Open sanctioned signal stack switching.  */
>> +       if ((ka->sa.sa_flags & SA_ONSTACK) && (current->sas_ss_sp != 0)) {
>> +               if (!on_sig_stack(usp))
>> +                       usp = current->sas_ss_sp + current->sas_ss_size;
>> +       }
>
> You can use sigsp() here.
Okay.


>> +
>> +       push_cache((unsigned long) &frame->retcode);
>> +
>> +       /* Set up registers for signal handler */
>> +       regs->sp = (unsigned long) frame;
>> +       regs->r4 = (unsigned long) (current_thread_info()->exec_domain
>> +                       && current_thread_info()->exec_domain->signal_invmap
>> +                       && sig < 32
>> +                       ? current_thread_info()->exec_domain->signal_invmap[sig]
>> +                       : sig);
>
> Does nios2 really need signal translation and supports execution domains?
Nios2 have one default "default_exec_domain" only. So, we can change
this to "regs->r4 = sig;".
BTW, most of the architectures have similar code.



>> +
>> +/*
>> + * Note that 'init' is a special process: it doesn't get signals it doesn't
>> + * want to handle. Thus you cannot kill init even with a SIGKILL even by
>> + * mistake.
>> + */
Will remove this.


>> +
>> +asmlinkage void do_notify_resume(struct pt_regs *regs, sigset_t *oldset,
>> +                               int in_syscall)
>> +{
>> +       pr_debug("--> ENTERING %s\n", __func__);
>
> Please remove such printk()s.
> If you need to know which functions get called, use ftrace.
Okay, will remove this.


Regards
Ley Foon
