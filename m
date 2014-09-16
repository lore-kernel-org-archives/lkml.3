Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaIPGet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 02:34:49 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:58923 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaIPGer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 02:34:47 -0400
Date: Tue, 16 Sep 2014 08:34:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, schwidefsky@de.ibm.com,
        luto@amacapital.net, keescook@chromium.org, linux@arm.linux.org.uk,
        ralf@linux-mips.org, heiko.carstens@de.ibm.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/seccomp] seccomp,x86,arm,mips,s390: Remove nr parameter
 from secure_computing
Message-ID: <20140916063442.GA14807@gmail.com>
References: <tip-a4412fc9486ec85686c6c7929e7e829f62ae377e@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-a4412fc9486ec85686c6c7929e7e829f62ae377e@git.kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Andy Lutomirski <tipbot@zytor.com> wrote:

> Commit-ID:  a4412fc9486ec85686c6c7929e7e829f62ae377e
> Gitweb:     http://git.kernel.org/tip/a4412fc9486ec85686c6c7929e7e829f62ae377e
> Author:     Andy Lutomirski <luto@amacapital.net>
> AuthorDate: Mon, 21 Jul 2014 18:49:14 -0700
> Committer:  Kees Cook <keescook@chromium.org>
> CommitDate: Wed, 3 Sep 2014 14:58:17 -0700
> 
> seccomp,x86,arm,mips,s390: Remove nr parameter from secure_computing

So, this commit in -tip, combined with Linus's latest 
(v3.17-rc5), produces this build failure or arch/parisc 
defconfig:

/home/mingo/tip/arch/parisc/kernel/ptrace.c: In function 'do_syscall_trace_enter':
/home/mingo/tip/arch/parisc/kernel/ptrace.c:274: error: implicit declaration of function 'secure_computing'
make[2]: *** [arch/parisc/kernel/ptrace.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [arch/parisc/kernel] Error 2

My guess is that the interaction was caused by:

  c90f06943e05 parisc: Wire up seccomp, getrandom and memfd_create syscalls

Thanks,

	Ingo
