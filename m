Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaABS2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:28:30 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22843 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaABS22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:28:28 -0500
Date: Thu, 2 Jan 2014 13:27:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        mukesh.rathor@oracle.com
Subject: Re: [PATCH v12 18/18] xen/pvh: Support ParaVirtualized Hardware
 extensions (v2).
Message-ID: <20140102182719.GC3021@pegasus.dumpdata.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
 <1388550945-25499-19-git-send-email-konrad.wilk@oracle.com>
 <52C55222.7070801@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C55222.7070801@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 11:48:50AM +0000, David Vrabel wrote:
> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > PVH allows PV linux guest to utilize hardware extended capabilities,
> > such as running MMU updates in a HVM container.
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
> > Use .ascii and .asciz to define xen feature string. Note, the PVH
> > string must be in a single line (not multiple lines with \) to keep the
> > assembler from putting null char after each string before \.
> > This patch allows it to be configured and enabled.
> > 
> > Lastly remove some of the scaffolding.
> [...]
> > --- a/arch/x86/xen/Kconfig
> > +++ b/arch/x86/xen/Kconfig
> > @@ -51,3 +51,11 @@ config XEN_DEBUG_FS
> >  	  Enable statistics output and various tuning options in debugfs.
> >  	  Enabling this option may incur a significant performance overhead.
> >  
> > +config XEN_PVH
> > +	bool "Support for running as a PVH guest"
> > +	depends on X86_64 && XEN && XEN_PVHVM
> 
> Would select XEN_PVHVM be more useful?  It may not be obvious to a user

Sure.
> that PV with hardware extension depends on HVM with PV extensions.
> 
> > +	default n
> > +	help
> > +	   This option enables support for running as a PVH guest (PV guest
> > +	   using hardware extensions) under a suitably capable hypervisor.
> > +	   If unsure, say N.
> 
> This help text needs to clearly state that PVH support is experimental
> or a tech preview and the ABI is subject to change and PVH guests may
> not run on newer hypervisors.  Unless the plan is to only merge the
> Linux support once the hypervisor ABI is finalized.

I am very much comfortable marking it as experimental and tech preview
with the caveat that it: 1) will change (or probably) in the future of
Xen versions, and 2) won't cause regressions with older hypervisors.
In other words, enabling this option should not make the kernel stop
working with say Xen 4.1.

[Which we need to fix of course]


> 
> David
