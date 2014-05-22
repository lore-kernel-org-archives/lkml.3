Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaEVKO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 06:14:26 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:42484 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaEVKOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 06:14:25 -0400
Date: Thu, 22 May 2014 12:14:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: more x86 fixes
Message-ID: <20140522101420.GC31816@gmail.com>
References: <20140514151016.GA530@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514151016.GA530@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Ingo, please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
> 
> Based on tip:perf/uprobes
> 
> 
> Denys found another nasty old bug in uprobes/x86: div, mul, shifts with
> count in CL, and cmpxchg are not handled correctly.
> 
> Plus a couple of other minor fixes. Nobody acked the changes in x86/traps,
> hopefully they are simple enough, and I believe that they make sense anyway
> and allow to do more cleanups.
> 
> Denys Vlasenko (2):
>       uprobes/x86: Simplify rip-relative handling
>       uprobes/x86: Fix scratch register selection for rip-relative fixups
> 
> Oleg Nesterov (8):
>       uprobes: Add mem_cgroup_charge_anon() into uprobe_write_opcode()
>       x86/traps: Make math_error() static
>       x86/traps: Use SEND_SIG_PRIV instead of force_sig()
>       x86/traps: Introduce do_error_trap()
>       x86/traps: Introduce fill_trap_info(), simplify DO_ERROR_INFO()
>       x86/traps: Shift fill_trap_info() from DO_ERROR_INFO() to do_error_trap()
>       x86/traps: Kill DO_ERROR_INFO()
>       uprobes/x86: Fix the wrong ->si_addr when xol triggers a trap
> 
>  arch/x86/include/asm/traps.h   |    1 -
>  arch/x86/include/asm/uprobes.h |    3 -
>  arch/x86/kernel/traps.c        |  110 ++++++++++++---------
>  arch/x86/kernel/uprobes.c      |  213 ++++++++++++++++++++++++++--------------
>  include/linux/uprobes.h        |    4 +
>  kernel/events/uprobes.c        |   33 ++++---
>  6 files changed, 225 insertions(+), 139 deletions(-)

Pulled into tip:perf/uprobes, thanks a lot Oleg!

	Ingo
