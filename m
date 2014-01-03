Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaACPeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 10:34:46 -0500
Received: from smtp.citrix.com ([66.165.176.89]:28609 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbaACPeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 10:34:44 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="89566838"
Date: Fri, 3 Jan 2014 15:33:55 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <david.vrabel@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 02/18] xen/pvh/x86: Define what an PVH guest is
 (v2).
In-Reply-To: <52C549F1.8070005@citrix.com>
Message-ID: <alpine.DEB.2.02.1401031533350.8667@kaball.uk.xensource.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-3-git-send-email-konrad.wilk@oracle.com> <52C549F1.8070005@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jan 2014, David Vrabel wrote:
> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > Which is a PV guest with auto page translation enabled
> > and with vector callback. It is a cross between PVHVM and PV.
> > 
> > The Xen side defines PVH as (from docs/misc/pvh-readme.txt,
> > with modifications):
> > 
> > "* the guest uses auto translate:
> >  - p2m is managed by Xen
> >  - pagetables are owned by the guest
> >  - mmu_update hypercall not available
> > * it uses event callback and not vlapic emulation,
> > * IDT is native, so set_trap_table hcall is also N/A for a PVH guest.
> > 
> > For a full list of hcalls supported for PVH, see pvh_hypercall64_table
> > in arch/x86/hvm/hvm.c in xen.  From the ABI prespective, it's mostly a
> > PV guest with auto translate, although it does use hvm_op for setting
> > callback vector."
> > 
> > We don't have yet a Kconfig entry setup as we do not
> > have all the parts ready for it - so we piggyback
> > on the PVHVM config option. This scaffolding will
> > be removed later.
> > 
> > Note that on ARM the concept of PVH is non-existent. As Ian
> > put it: "an ARM guest is neither PV nor HVM nor PVHVM.
> > It's a bit like PVH but is different also (it's further towards
> > the H end of the spectrum than even PVH).". As such these
> > options (PVHVM, PVH) are never enabled nor seen on ARM
> > compilations.
> [...]
> > --- a/include/xen/xen.h
> > +++ b/include/xen/xen.h
> > @@ -29,4 +29,20 @@ extern enum xen_domain_type xen_domain_type;
> >  #define xen_initial_domain()	(0)
> >  #endif	/* CONFIG_XEN_DOM0 */
> >  
> > +#ifdef CONFIG_XEN_PVHVM
> > +/* Temporarily under XEN_PVHVM, but will be under CONFIG_XEN_PVH */
> 
> This is a bit confusing.  I think it would be better to add the
> CONFIG_XEN_PVH option with this patch but make it default n and not
> possible to enable.
 
I am OK with the patch as is, but your suggestion would probably make
things better.
