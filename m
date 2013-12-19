Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab3LSVKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:10:51 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:50967 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756000Ab3LSVKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:10:49 -0500
Date: Thu, 19 Dec 2013 15:10:45 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: David Daney <ddaney.cavm@gmail.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 29/40] mips: Replace __get_cpu_var uses
In-Reply-To: <52B330F3.4090603@gmail.com>
Message-ID: <alpine.DEB.2.10.1312191506370.17603@nuc>
References: <20131219155015.443763038@linux.com> <20131219155033.834416420@linux.com> <52B330F3.4090603@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013, David Daney wrote:

> > 16:07:58.244398747 -0600
> > @@ -43,7 +43,7 @@ DECLARE_PER_CPU(struct mips_fpu_emulator
> >   #define MIPS_FPU_EMU_INC_STATS(M)					\
> >   do {
> > \
> >   	preempt_disable();						\
> > -	__local_inc(&__get_cpu_var(fpuemustats).M);			\
> > +	__this_cpu_inc(fpuemustats.M);					\
> >   	preempt_enable();						\
> >   } while (0)
> >
>
> Something seems to be incorrect in this bit.

Hrmm.. yes this is a local_t so the this_cpu_inc would not work unless
fpuemustats is defined differently.

Use

__local_inc(this_cpu_ptr(fpuemustats.M);

instead until then.

