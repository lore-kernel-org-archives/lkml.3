Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbaGRU7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:59:54 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:39465 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbaGRU7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:59:53 -0400
Date: Fri, 18 Jul 2014 16:59:50 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@redhat.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 4/4] (RFC) X86: add IPI tracepoints
In-Reply-To: <20140718162750.62cbf965@gandalf.local.home>
Message-ID: <alpine.LFD.2.11.1407181656160.3647@knanqh.ubzr>
References: <1405660735-13408-1-git-send-email-nicolas.pitre@linaro.org> <1405660735-13408-5-git-send-email-nicolas.pitre@linaro.org> <20140718162750.62cbf965@gandalf.local.home>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014, Steven Rostedt wrote:

> On Fri, 18 Jul 2014 01:18:55 -0400
> Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> 
>  
> > diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> > index be8e1bde07..e154d176cf 100644
> > --- a/arch/x86/kernel/smp.c
> > +++ b/arch/x86/kernel/smp.c
> > @@ -31,6 +31,12 @@
> >  #include <asm/apic.h>
> >  #include <asm/nmi.h>
> >  #include <asm/trace/irq_vectors.h>
> > +
> > +#define CREATE_TRACE_POINTS
> > +#undef TRACE_INCLUDE_PATH
> > +#undef TRACE_INCLUDE_FILE
> 
> I'm curious to why you added the #undefs. I wouldn't think they were
> needed.

They are needed because asm/trace/irq_vectors.h included prior that 
point defines them for itself and that makes the inclusion of 
trace/events/ipi.h fail.

> -- Steve
> 
> > +#include <trace/events/ipi.h>
> > +
> >  /*
> >   *	Some notes on x86 processor bugs affecting SMP operation:
> >   *
> 
> 
