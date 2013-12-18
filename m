Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab3LRQ7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:59:19 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22102 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab3LRQ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:59:18 -0500
Date: Wed, 18 Dec 2013 11:58:07 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org, jbeulich@suse.com,
        david.vrabel@citrix.com
Subject: Re: [Xen-devel] [PATCH v11 02/12] xen/pvh: Define what an PVH guest
 is.
Message-ID: <20131218165807.GB4630@phenom.dumpdata.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
 <1387313503-31362-3-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1312181421260.8667@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1312181453110.8667@kaball.uk.xensource.com>
 <1387382463.28680.52.camel@kazak.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387382463.28680.52.camel@kazak.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 04:01:03PM +0000, Ian Campbell wrote:
> On Wed, 2013-12-18 at 14:55 +0000, Stefano Stabellini wrote:
> > On Wed, 18 Dec 2013, Stefano Stabellini wrote:
> > > On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > > > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > > 
> > > > Which is a PV guest with auto page translation enabled
> > > > and with vector callback. It is a cross between PVHVM and PV.
> > > > 
> > > > The Xen side defines PVH as (from docs/misc/pvh-readme.txt,
> > > > with modifications):
> > > > 
> > > > "* the guest uses auto translate:
> > > >  - p2m is managed by Xen
> > > >  - pagetables are owned by the guest
> > > >  - mmu_update hypercall not available
> > > > * it uses event callback and not vlapic emulation,
> > > > * IDT is native, so set_trap_table hcall is also N/A for a PVH guest.
> > > > 
> > > > For a full list of hcalls supported for PVH, see pvh_hypercall64_table
> > > > in arch/x86/hvm/hvm.c in xen.  From the ABI prespective, it's mostly a
> > > > PV guest with auto translate, although it does use hvm_op for setting
> > > > callback vector."
> > > > 
> > > > We don't have yet a Kconfig entry setup as we do not
> > > > have all the parts ready for it - so we piggyback
> > > > on the PVHVM config option. This scaffolding will
> > > > be removed later.
> > > > 
> > > > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > 
> > > Could you please add an "&& CONFIG_X86"?
> > 
> > On second thought, given that it is just temporary and that PVHVM is not
> > defined on ARM, it could be OK. But maybe it is worth adding a small
> > comment on the fact that this is an x86-only option.
> 
> I wonder if it should be CONFIG_XEN_X86_{PVH,PVHVM} instead?

Originally it was CONFIG_XEN_X86_PVH but I figured it would be pointless
as most of the changes were in arch/x86 and that is by default x86.

And then once that work is stabilized, ARM can kind of do the same thing - have
an CONFIG_XEN_PVH that would (hopefully) have the same ABI as x86 PVH?

Thought, you kind of already do PVH in spirit. Is that what you were
alluding too? As ARM already boots in PV and the page table manipulations
are done by the hardware.

?
