Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaAOKkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:40:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33300 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaAOKkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:40:10 -0500
Date: Wed, 15 Jan 2014 11:39:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, raistlin@linux.it,
        juri.lelli@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
Message-ID: <20140115103949.GZ31570@twins.programming.kicks-ass.net>
References: <52D64676.4040000@linaro.org>
 <20140115092245.GA15190@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115092245.GA15190@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 10:22:45AM +0100, Ingo Molnar wrote:
> 3)
> 
> On ARM:
> 
> -#define __NR_syscalls  (380)
> +#define __NR_syscalls  (384)
> 
> but:
> 
>  #define __NR_finit_module              (__NR_SYSCALL_BASE+379)
> +#define __NR_sched_setattr             (__NR_SYSCALL_BASE+380)
> +#define __NR_sched_getattr             (__NR_SYSCALL_BASE+381)
>  
>  /*
> 
> 
> Why is the syscall table increased by 4, while we only add 2 new 
> syscalls?

arch/arm/kernel/entry-common.S:.ifne NR_syscalls - __NR_syscalls
arch/arm/kernel/calls.S:.equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls

Totally confusing, I know.
