Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbbALPaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:30:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbbALP37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:29:59 -0500
Date: Mon, 12 Jan 2015 10:29:19 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>, dwmw2@infradead.org,
        indou.takao@jp.fujitsu.com, bhe@redhat.com, dyoung@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        jerry.hoemann@hp.com, tom.vaden@hp.com, li.zhang6@hp.com,
        lisa.mitchell@hp.com, billsumnerlinux@gmail.com, rwright@hp.com
Subject: Re: [PATCH v8 02/10] iommu/vt-d: Items required for kdump
Message-ID: <20150112152919.GA16162@redhat.com>
References: <1421046388-27925-1-git-send-email-zhen-hual@hp.com>
 <1421046388-27925-3-git-send-email-zhen-hual@hp.com>
 <20150112152207.GC6343@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112152207.GC6343@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 04:22:08PM +0100, Joerg Roedel wrote:
> On Mon, Jan 12, 2015 at 03:06:20PM +0800, Li, Zhen-Hua wrote:
> > +
> > +#ifdef CONFIG_CRASH_DUMP
> > +
> > +/*
> > + * Fix Crashdump failure caused by leftover DMA through a hardware IOMMU
> > + *
> > + * Fixes the crashdump kernel to deal with an active iommu and legacy
> > + * DMA from the (old) panicked kernel in a manner similar to how legacy
> > + * DMA is handled when no hardware iommu was in use by the old kernel --
> > + * allow the legacy DMA to continue into its current buffers.
> > + *
> > + * In the crashdump kernel, this code:
> > + * 1. skips disabling the IOMMU's translating of IO Virtual Addresses (IOVA).
> > + * 2. Do not re-enable IOMMU's translating.
> > + * 3. In kdump kernel, use the old root entry table.
> > + * 4. Leaves the current translations in-place so that legacy DMA will
> > + *    continue to use its current buffers.
> > + * 5. Allocates to the device drivers in the crashdump kernel
> > + *    portions of the iova address ranges that are different
> > + *    from the iova address ranges that were being used by the old kernel
> > + *    at the time of the panic.
> > + *
> > + */
> 
> It looks like you are still copying the io-page-tables from the old
> kernel into the kdump kernel, is that right? With the approach that was
> proposed you only need to copy over the context entries 1-1. They are
> still pointing to the page-tables in the old kernels memory (which is
> just fine).

Kdump has the notion of backup region. Where certain parts of old kernels
memory can be moved to a different location (first 640K on x86 as of now)
and new kernel can make use of this memory now.

So we will have to just make sure that no parts of this old page table
fall into backup region.

Thanks
Vivek
