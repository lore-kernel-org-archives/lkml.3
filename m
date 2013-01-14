Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab3ANQCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 11:02:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab3ANQCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 11:02:50 -0500
Date: Mon, 14 Jan 2013 17:01:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: u3557@miso.sublimeip.com
Cc: Pedro Alves <palves@redhat.com>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: PTRACE_SYSCALL && vsyscall (Was: arch_check_bp_in_kernelspace:
	fix the range check)
Message-ID: <20130114160153.GA16555@redhat.com>
References: <20121125225533.GA24905@redhat.com> <20121125234834.DAC34592076@miso.sublimeip.com> <20121202193058.GA4264@redhat.com> <841b7a319f9d22402d269eed23d03835.squirrel@mail.sublimeip.com> <20121204175933.GA11537@redhat.com> <50EC527C.5030800@redhat.com> <20130109175203.GA32191@redhat.com> <6dff6dcdbfd7444f0b43d8b8bea6ca7c.squirrel@mail.sublimeip.com> <20130112181258.GA24903@redhat.com> <a370d0f1bac7b2cee0bd2c2eea1ce22f.squirrel@mail.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a370d0f1bac7b2cee0bd2c2eea1ce22f.squirrel@mail.sublimeip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14, u3557@miso.sublimeip.com wrote:
>
> So here again is the patch that I need so badly - clearly it fixes a bug
> and harms nobody:
>
> -----------------------------------------------------------------------
> diff -Naur before/arch/x86/kernel/hw_breakpoint.c
> after/arch/x86/kernel/hw_breakpoint.c
> --- before/arch/x86/kernel/hw_breakpoint.c	2013-01-14 12:45:20.000000000
> +1030
> +++ after/arch/x86/kernel/hw_breakpoint.c	2013-01-14 12:46:24.000000000 +1030
> @@ -200,7 +200,8 @@
>  	va = info->address;
>  	len = get_hbp_len(info->len);
> 
> -	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
> +	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE) &&
> +		!((va >= VSYSCALL_START) && ((va + len - 1) <= VSYSCALL_END));
>  }

I meant this one: http://marc.info/?l=linux-kernel&m=135336050319266
on top of http://marc.info/?l=linux-kernel&m=135248575426474

But nobody bothers to take even the trivial bugfix I sent ;)

Oleg.

