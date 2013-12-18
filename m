Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab3LRRD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:03:29 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:1168 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab3LRRD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:03:28 -0500
X-IronPort-AV: E=Sophos;i="4.95,508,1384300800"; 
   d="scan'208";a="83578149"
Message-ID: <1387386205.28680.74.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v11 02/12] xen/pvh: Define what an PVH guest
 is.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>, <jbeulich@suse.com>,
        <david.vrabel@citrix.com>
Date: Wed, 18 Dec 2013 17:03:25 +0000
In-Reply-To: <20131218165807.GB4630@phenom.dumpdata.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
	 <1387313503-31362-3-git-send-email-konrad.wilk@oracle.com>
	 <alpine.DEB.2.02.1312181421260.8667@kaball.uk.xensource.com>
	 <alpine.DEB.2.02.1312181453110.8667@kaball.uk.xensource.com>
	 <1387382463.28680.52.camel@kazak.uk.xensource.com>
	 <20131218165807.GB4630@phenom.dumpdata.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-18 at 11:58 -0500, Konrad Rzeszutek Wilk wrote:
> On Wed, Dec 18, 2013 at 04:01:03PM +0000, Ian Campbell wrote:
> > On Wed, 2013-12-18 at 14:55 +0000, Stefano Stabellini wrote:
> > > On Wed, 18 Dec 2013, Stefano Stabellini wrote:
> > > > On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > > > > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > > > 
> > > > > Which is a PV guest with auto page translation enabled
> > > > > and with vector callback. It is a cross between PVHVM and PV.
> > > > > 
> > > > > The Xen side defines PVH as (from docs/misc/pvh-readme.txt,
> > > > > with modifications):
> > > > > 
> > > > > "* the guest uses auto translate:
> > > > >  - p2m is managed by Xen
> > > > >  - pagetables are owned by the guest
> > > > >  - mmu_update hypercall not available
> > > > > * it uses event callback and not vlapic emulation,
> > > > > * IDT is native, so set_trap_table hcall is also N/A for a PVH guest.
> > > > > 
> > > > > For a full list of hcalls supported for PVH, see pvh_hypercall64_table
> > > > > in arch/x86/hvm/hvm.c in xen.  From the ABI prespective, it's mostly a
> > > > > PV guest with auto translate, although it does use hvm_op for setting
> > > > > callback vector."
> > > > > 
> > > > > We don't have yet a Kconfig entry setup as we do not
> > > > > have all the parts ready for it - so we piggyback
> > > > > on the PVHVM config option. This scaffolding will
> > > > > be removed later.
> > > > > 
> > > > > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > > 
> > > > Could you please add an "&& CONFIG_X86"?
> > > 
> > > On second thought, given that it is just temporary and that PVHVM is not
> > > defined on ARM, it could be OK. But maybe it is worth adding a small
> > > comment on the fact that this is an x86-only option.
> > 
> > I wonder if it should be CONFIG_XEN_X86_{PVH,PVHVM} instead?
> 
> Originally it was CONFIG_XEN_X86_PVH but I figured it would be pointless
> as most of the changes were in arch/x86 and that is by default x86.
> 
> And then once that work is stabilized, ARM can kind of do the same thing - have
> an CONFIG_XEN_PVH that would (hopefully) have the same ABI as x86 PVH?
> 
> Thought, you kind of already do PVH in spirit. Is that what you were
> alluding too? As ARM already boots in PV and the page table manipulations
> are done by the hardware.
> 
> ?

The Zen answer is that an ARM guest is neither PV nor HVM nor PVHVM.
It's a bit like PVH but is different also (it's further towards the H
end of the spectrum than even PVH).

I'm keen to avoid using these x86 specific terms to widely to refer to
ARM guests, because it leads to confusion.

Ian.

