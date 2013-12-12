Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab3LLFCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 00:02:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58588 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3LLFCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 00:02:11 -0500
Message-ID: <1386824397.6056.21.camel@marge.simpson.net>
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
From: Mike Galbraith <bitbucket@online.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Date: Thu, 12 Dec 2013 05:59:57 +0100
In-Reply-To: <52A94065.1050103@zytor.com>
References: <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de>
	 <20131211113839.GF21683@pd.tnic>
	 <20131211115239.GA21999@twins.programming.kicks-ass.net>
	 <1386764955.12005.60.camel@marge.simpson.net>
	 <20131211124352.GB21999@twins.programming.kicks-ass.net>
	 <20131211134048.GH21683@pd.tnic> <20131211145655.GB4510@gmail.com>
	 <20131211164318.GA2480@laptop.programming.kicks-ass.net>
	 <20131211175036.GC12431@gmail.com> <52A8F073.9040500@zytor.com>
	 <20131211231425.GD8863@pd.tnic> <52A908DB.60902@zytor.com>
	 <1386822357.6056.12.camel@marge.simpson.net> <52A94065.1050103@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:63x3OsbRlS7u9PjnbQLXjVzu73Nf3J19hdqyg1VDXWj
 irPi4ewCAd5WIHsfp8Vw5U1G+hU61xO9wvs29/1JoBRUs3D/eS
 nODNXlyIIGvEeTtC5PN5FlV9yQ1BYlYvlA1ZvF6YucRsekaIV/
 Uhq8Ww+8UbGrE1hqDMcFkBiX7YXFW7eWytv4Xx4lMQ/a1mLVzW
 RPvF21/0GrqJrlwa8gSeiGNYcQuwWpHK9K6vpc/uqDLGoyFQDQ
 Mp+dZUdBulNX1R87clp0V1NPrvrIncOnOtM3oOf5jXvTk1L0Vf
 LAZAbqEaHHukGkBGYyGlgoZGhe1Ivz1TO61c7T7rgp2Rk6Tw86
 cJEhgCxP1tAQZes8+HL8Sto6/ISelDNQpfkcjUaPnFRNejL1X1
 lVvcS5oXU9JGA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-11 at 20:49 -0800, H. Peter Anvin wrote: 
> On 12/11/2013 08:25 PM, Mike Galbraith wrote:
> >  arch/x86/include/asm/mwait.h   |    4 ++--
> >  arch/x86/kernel/cpu/common.c   |    7 ++++---
> >  arch/x86/kernel/setup_percpu.c |    1 +
> >  3 files changed, 7 insertions(+), 5 deletions(-)
> > 
> > Index: linux-2.6/arch/x86/kernel/cpu/common.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/kernel/cpu/common.c
> > +++ linux-2.6/arch/x86/kernel/cpu/common.c
> > @@ -65,13 +65,14 @@ void __init setup_cpu_local_masks(void)
> >  }
> >  
> >  /* allocate percpu area for mwait doorbell */
> > -char __percpu *mwait_doorbell;
> > +DEFINE_PER_CPU(char *, mwait_doorbell);
> > +EXPORT_PER_CPU_SYMBOL(mwait_doorbell);
> >  
> 
> Sorry, this is wrong.  This is NOT a percpu variable, it is a pointer to
> a percpu allocation, but the variable itself is not a percpu variable.
> This explains your boom.

Yeah, I know, I already slapped myself upside the head.

(what were you thinking mikie...la la la la la:)

-Mike

