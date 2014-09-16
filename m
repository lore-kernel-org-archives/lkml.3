Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbaIPBdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 21:33:38 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41102 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbaIPBdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 21:33:36 -0400
Date: Mon, 15 Sep 2014 18:33:29 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [V5 PATCH 1/1] x86/xen: Set EFER.NX and EFER.SCE in
 PVH guests
Message-ID: <20140915183329.70666a8d@mantra.us.oracle.com>
In-Reply-To: <20140912204258.GA24846@laptop.dumpdata.com>
References: <1410392166-16388-1-git-send-email-mukesh.rathor@oracle.com>
	<1410392166-16388-2-git-send-email-mukesh.rathor@oracle.com>
	<20140912204258.GA24846@laptop.dumpdata.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 16:42:58 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Wed, Sep 10, 2014 at 04:36:06PM -0700, Mukesh Rathor wrote:

sorry, i didn't realize you had more comments... didn't scroll down :)..

> >  cpumask_var_t xen_cpu_initialized_map;
> >  
> > @@ -99,10 +100,14 @@ static void cpu_bringup(void)
> >  	wmb();			/* make sure everything is
> > out */ }
> >  
> > -/* Note: cpu parameter is only relevant for PVH */
> > -static void cpu_bringup_and_idle(int cpu)
> > +/*
> > + * Note: cpu parameter is only relevant for PVH. The reason for
> > passing it
> > + * is we can't do smp_processor_id until the percpu segments are
> > loaded, for
> > + * which we need the cpu number! So we pass it in rdi as first
> > parameter.
> > + */
> 
> Thank you for expanding on that (I totally forgot why we did that).

sure.

> > +		 * The vcpu comes on kernel page tables which have
> > the NX pte
> > +		 * bit set. This means before DS/SS is touched, NX
> > in
> > +		 * EFER must be set. Hence the following assembly
> > glue code.
> 
> And you ripped out the nice 'N.B' comment I added. Sad :-(
> >  		 */
> > +		ctxt->user_regs.eip = (unsigned
> > long)xen_pvh_early_cpu_init; ctxt->user_regs.rdi = cpu;
> > +		ctxt->user_regs.rsi = true;  /* secondary cpu ==
> > true */
> 
> Oh, that is new. Ah yes we can use that [looking at Xen code].
> I wonder what other registers we can use to pass stuff around.

All GPRs. I commented that we can do that in the Rogers PVH doc.

Looks like David responded to other comments.

Thanks,
Mukesh

