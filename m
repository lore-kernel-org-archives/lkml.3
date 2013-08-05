Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3HERRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:17:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19435 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3HERRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:17:16 -0400
Date: Mon, 5 Aug 2013 13:16:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Gleb Natapov <gleb@redhat.com>, Mukesh Rathor <mukesh.rathor@oracle.com>,
        Mike Rapoport <mike.rapoport@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, xen-devel@lists.xensource.com
Subject: Re: [QUERY] lguest64
Message-ID: <20130805171653.GA22372@phenom.dumpdata.com>
References: <51E97779.3020103@zytor.com>
 <87zjte9iah.fsf@rustcorp.com.au>
 <CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com>
 <51F9005F.30501@zytor.com>
 <20130731131757.GB22124@phenom.dumpdata.com>
 <51F91030.9060606@zytor.com>
 <20130802190934.GA4354@phenom.dumpdata.com>
 <20130804123708.GM6042@redhat.com>
 <20130805165040.GC22093@phenom.dumpdata.com>
 <51FFD9D8.3000704@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FFD9D8.3000704@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>          struct pv_cpu_ops pv_cpu_ops;                                           
> >>> 		[only end up using cpuid. This one is a tricky one. We could
> >>> 		 arguable remove it but it does do some filtering - for example
> >>> 	 	 THERM is turned off, or MWAIT if a certain hypercall tells us to
> >>> 		 disable that. Since this is now a trapped operation this could be
> >>> 		 handled in the hypervisor - but then it would be in charge of
> >>> 		 filtering certain CPUID - and this is at bootup - so there is not
> >>> 		 user interaction. This needs a bit more of thinking]
> >>>
> >> read_msr/write_msr in this one make all msr accesses safe. IIRC there
> >> are MSRs that Linux uses without checking cpuid bits.
> >> IA32_PERF_CAPABILITIES for instance is used without checking PDCM bit.
> > 
> > Right, those are needed as well. Completly forgot about them.
> 
> CPUID is not too bad.  RDMSR/WRMSR is actually worse since there are
> some MSRs which are performance-critical.  The really messy pvops are
> the memory-related ones, as they don't match the hardware behavior.

Would you have a by any chance a nice test-case to demonstrate the
rdmsr/wrmsr paths which performance-critical under baremetal?
> 
> Similarly, beyond pvops, what new assumptions does this code add to the
> code base?

We have not yet narrowed down on how to "negotiate" the GDT values - as
the VMX code in the hypervisor has setup those before it loads the kernel.
I think Mukesh was thinking to extend the .Xen.note to enumerate some of the
ones that are needed and somehow the hypervisor slurps them in.

