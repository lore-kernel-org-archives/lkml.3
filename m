Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaIPW6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:58:14 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:42614 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbaIPW6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:58:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140916063442.GA14807@gmail.com>
References: <tip-a4412fc9486ec85686c6c7929e7e829f62ae377e@git.kernel.org> <20140916063442.GA14807@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 16 Sep 2014 15:57:50 -0700
Message-ID: <CALCETrVFgfSUQk4w4AvPeAb7iMbSR7F-=NfZQGTtfvtOUFOk2Q@mail.gmail.com>
Subject: Re: [tip:x86/seccomp] seccomp,x86,arm,mips,s390: Remove nr parameter
 from secure_computing
To: Ingo Molnar <mingo@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 11:34 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * tip-bot for Andy Lutomirski <tipbot@zytor.com> wrote:
>
>> Commit-ID:  a4412fc9486ec85686c6c7929e7e829f62ae377e
>> Gitweb:     http://git.kernel.org/tip/a4412fc9486ec85686c6c7929e7e829f62ae377e
>> Author:     Andy Lutomirski <luto@amacapital.net>
>> AuthorDate: Mon, 21 Jul 2014 18:49:14 -0700
>> Committer:  Kees Cook <keescook@chromium.org>
>> CommitDate: Wed, 3 Sep 2014 14:58:17 -0700
>>
>> seccomp,x86,arm,mips,s390: Remove nr parameter from secure_computing
>
> So, this commit in -tip, combined with Linus's latest
> (v3.17-rc5), produces this build failure or arch/parisc
> defconfig:
>
> /home/mingo/tip/arch/parisc/kernel/ptrace.c: In function 'do_syscall_trace_enter':
> /home/mingo/tip/arch/parisc/kernel/ptrace.c:274: error: implicit declaration of function 'secure_computing'
> make[2]: *** [arch/parisc/kernel/ptrace.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [arch/parisc/kernel] Error 2
>
> My guess is that the interaction was caused by:
>
>   c90f06943e05 parisc: Wire up seccomp, getrandom and memfd_create syscalls

I guess this something like this was unavoidable.  Here's a fix:

http://lkml.kernel.org/g/db9b257536558b5f068e97717bb0f25bcc603ae4.1410883257.git.luto@amacapital.net

--Andy
