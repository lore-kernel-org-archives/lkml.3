Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab3HEQvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:51:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44732 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab3HEQvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:51:04 -0400
Date: Mon, 5 Aug 2013 12:50:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Mukesh Rathor <mukesh.rathor@oracle.com>,
        Mike Rapoport <mike.rapoport@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, xen-devel@lists.xensource.com
Subject: Re: [QUERY] lguest64
Message-ID: <20130805165040.GC22093@phenom.dumpdata.com>
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com>
 <51E97779.3020103@zytor.com>
 <87zjte9iah.fsf@rustcorp.com.au>
 <CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com>
 <51F9005F.30501@zytor.com>
 <20130731131757.GB22124@phenom.dumpdata.com>
 <51F91030.9060606@zytor.com>
 <20130802190934.GA4354@phenom.dumpdata.com>
 <20130804123708.GM6042@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130804123708.GM6042@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 04, 2013 at 03:37:08PM +0300, Gleb Natapov wrote:
> On Fri, Aug 02, 2013 at 03:09:34PM -0400, Konrad Rzeszutek Wilk wrote:
> > On Wed, Jul 31, 2013 at 06:25:04AM -0700, H. Peter Anvin wrote:
> > > On 07/31/2013 06:17 AM, Konrad Rzeszutek Wilk wrote:
> > > >>
> > > >> The big problem with pvops is that they are a permanent tax on future
> > > >> development -- a classic case of "the hooks problem."  As such it is
> > > >> important that there be a real, significant, use case with enough users
> > > >> to make the pain worthwhile.  With Xen looking at sunsetting PV support
> > > >> with a long horizon, it might currently be possible to remove pvops some
> > > > 
> > > > PV MMU parts specifically.
> > > > 
> > > 
> > > Pretty much stuff that is driverized on plain hardware doesn't matter.
> > > What are you looking at with respect to the basic CPU control state?
> > 
> > 
> > CC-ing Mukesh here.
> > 
> > Let me iterate down what the experimental patch uses:
> > 
> >          struct pv_init_ops pv_init_ops;                                         
> > 		[still use xen_patch, but I think that is not needed anymore]
> > 
> >          struct pv_time_ops pv_time_ops;                                         
> > 		[we need that as we are using the PV clock source]
> > 
> >          struct pv_cpu_ops pv_cpu_ops;                                           
> > 		[only end up using cpuid. This one is a tricky one. We could
> > 		 arguable remove it but it does do some filtering - for example
> > 	 	 THERM is turned off, or MWAIT if a certain hypercall tells us to
> > 		 disable that. Since this is now a trapped operation this could be
> > 		 handled in the hypervisor - but then it would be in charge of
> > 		 filtering certain CPUID - and this is at bootup - so there is not
> > 		 user interaction. This needs a bit more of thinking]
> > 
> read_msr/write_msr in this one make all msr accesses safe. IIRC there
> are MSRs that Linux uses without checking cpuid bits.
> IA32_PERF_CAPABILITIES for instance is used without checking PDCM bit.

Right, those are needed as well. Completly forgot about them.
> 
> 
> --
> 			Gleb.
