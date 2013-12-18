Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3LRQBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:01:11 -0500
Received: from smtp.citrix.com ([66.165.176.89]:34712 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab3LRQBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:01:10 -0500
X-IronPort-AV: E=Sophos;i="4.95,508,1384300800"; 
   d="scan'208";a="85791945"
Message-ID: <1387382463.28680.52.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v11 02/12] xen/pvh: Define what an PVH guest
 is.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <linux-kernel@vger.kernel.org>, <david.vrabel@citrix.com>,
        <jbeulich@suse.com>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>
Date: Wed, 18 Dec 2013 16:01:03 +0000
In-Reply-To: <alpine.DEB.2.02.1312181453110.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
	 <1387313503-31362-3-git-send-email-konrad.wilk@oracle.com>
	 <alpine.DEB.2.02.1312181421260.8667@kaball.uk.xensource.com>
	 <alpine.DEB.2.02.1312181453110.8667@kaball.uk.xensource.com>
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

On Wed, 2013-12-18 at 14:55 +0000, Stefano Stabellini wrote:
> On Wed, 18 Dec 2013, Stefano Stabellini wrote:
> > On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > 
> > > Which is a PV guest with auto page translation enabled
> > > and with vector callback. It is a cross between PVHVM and PV.
> > > 
> > > The Xen side defines PVH as (from docs/misc/pvh-readme.txt,
> > > with modifications):
> > > 
> > > "* the guest uses auto translate:
> > >  - p2m is managed by Xen
> > >  - pagetables are owned by the guest
> > >  - mmu_update hypercall not available
> > > * it uses event callback and not vlapic emulation,
> > > * IDT is native, so set_trap_table hcall is also N/A for a PVH guest.
> > > 
> > > For a full list of hcalls supported for PVH, see pvh_hypercall64_table
> > > in arch/x86/hvm/hvm.c in xen.  From the ABI prespective, it's mostly a
> > > PV guest with auto translate, although it does use hvm_op for setting
> > > callback vector."
> > > 
> > > We don't have yet a Kconfig entry setup as we do not
> > > have all the parts ready for it - so we piggyback
> > > on the PVHVM config option. This scaffolding will
> > > be removed later.
> > > 
> > > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > Could you please add an "&& CONFIG_X86"?
> 
> On second thought, given that it is just temporary and that PVHVM is not
> defined on ARM, it could be OK. But maybe it is worth adding a small
> comment on the fact that this is an x86-only option.

I wonder if it should be CONFIG_XEN_X86_{PVH,PVHVM} instead?


