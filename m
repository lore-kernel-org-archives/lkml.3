Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab3IZD5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 23:57:45 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:6080
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754972Ab3IZD5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 23:57:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zz98dI9371I936eI146fI542I1432Ic8kzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah1de097h186068h8275bh8275dha509lz2dh2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "joro@8bytes.org" <joro@8bytes.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH 6/7] vfio: moving some functions in common file
Thread-Topic: [PATCH 6/7] vfio: moving some functions in common file
Thread-Index: AQHOtQsXtNprVVCu6UeeaER7c6RjspnWuAYAgAC1+oA=
Date: Thu, 26 Sep 2013 03:57:36 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D07183CBB@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1379575763-2091-7-git-send-email-Bharat.Bhushan@freescale.com>
 <1380128566.3030.327.camel@ul30vt.home>
In-Reply-To: <1380128566.3030.327.camel@ul30vt.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.2]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8Q3vouk011520



> -----Original Message-----
> From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-owner@vger.kernel.org]
> On Behalf Of Alex Williamson
> Sent: Wednesday, September 25, 2013 10:33 PM
> To: Bhushan Bharat-R65777
> Cc: joro@8bytes.org; benh@kernel.crashing.org; galak@kernel.crashing.org; linux-
> kernel@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> pci@vger.kernel.org; agraf@suse.de; Wood Scott-B07421; iommu@lists.linux-
> foundation.org; Bhushan Bharat-R65777
> Subject: Re: [PATCH 6/7] vfio: moving some functions in common file
> 
> On Thu, 2013-09-19 at 12:59 +0530, Bharat Bhushan wrote:
> > Some function defined in vfio_iommu_type1.c were common and we want to
> > use these for FSL IOMMU (PAMU) and iommu-none driver.
> > So some of them are moved to vfio_iommu_common.c
> >
> > I think we can do more of that but we will take this step by step.
> >
> > Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
> > ---
> >  drivers/vfio/Makefile            |    4 +-
> >  drivers/vfio/vfio_iommu_common.c |  235
> ++++++++++++++++++++++++++++++++++++++
> >  drivers/vfio/vfio_iommu_common.h |   30 +++++
> >  drivers/vfio/vfio_iommu_type1.c  |  206
> > +---------------------------------
> >  4 files changed, 268 insertions(+), 207 deletions(-)  create mode
> > 100644 drivers/vfio/vfio_iommu_common.c  create mode 100644
> > drivers/vfio/vfio_iommu_common.h
> >
> > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile index
> > 72bfabc..c5792ec 100644
> > --- a/drivers/vfio/Makefile
> > +++ b/drivers/vfio/Makefile
> > @@ -1,4 +1,4 @@
> >  obj-$(CONFIG_VFIO) += vfio.o
> > -obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
> > -obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> > +obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_common.o
> > +vfio_iommu_type1.o
> > +obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_common.o
> > +vfio_iommu_spapr_tce.o
> >  obj-$(CONFIG_VFIO_PCI) += pci/
> > diff --git a/drivers/vfio/vfio_iommu_common.c
> > b/drivers/vfio/vfio_iommu_common.c
> > new file mode 100644
> > index 0000000..8bdc0ea
> > --- /dev/null
> > +++ b/drivers/vfio/vfio_iommu_common.c
> > @@ -0,0 +1,235 @@
> > +/*
> > + * VFIO: Common code for vfio IOMMU support
> > + *
> > + * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
> > + *     Author: Alex Williamson <alex.williamson@redhat.com>
> > + *     Author: Bharat Bhushan <bharat.bhushan@freescale.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * Derived from original vfio:
> > + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> > + * Author: Tom Lyon, pugs@cisco.com
> > + */
> > +
> > +#include <linux/compat.h>
> > +#include <linux/device.h>
> > +#include <linux/fs.h>
> > +#include <linux/iommu.h>
> > +#include <linux/module.h>
> > +#include <linux/mm.h>
> > +#include <linux/pci.h>		/* pci_bus_type */
> > +#include <linux/rbtree.h>
> > +#include <linux/sched.h>
> > +#include <linux/slab.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/vfio.h>
> > +#include <linux/workqueue.h>
> 
> Please cleanup includes on both the source and target files.  You obviously
> don't need linux/pci.h here for one.

Will do.

> 
> > +
> > +static bool disable_hugepages;
> > +module_param_named(disable_hugepages,
> > +		   disable_hugepages, bool, S_IRUGO | S_IWUSR);
> > +MODULE_PARM_DESC(disable_hugepages,
> > +		 "Disable VFIO IOMMU support for IOMMU hugepages.");
> > +
> > +struct vwork {
> > +	struct mm_struct	*mm;
> > +	long			npage;
> > +	struct work_struct	work;
> > +};
> > +
> > +/* delayed decrement/increment for locked_vm */ void
> > +vfio_lock_acct_bg(struct work_struct *work) {
> > +	struct vwork *vwork = container_of(work, struct vwork, work);
> > +	struct mm_struct *mm;
> > +
> > +	mm = vwork->mm;
> > +	down_write(&mm->mmap_sem);
> > +	mm->locked_vm += vwork->npage;
> > +	up_write(&mm->mmap_sem);
> > +	mmput(mm);
> > +	kfree(vwork);
> > +}
> > +
> > +void vfio_lock_acct(long npage)
> > +{
> > +	struct vwork *vwork;
> > +	struct mm_struct *mm;
> > +
> > +	if (!current->mm || !npage)
> > +		return; /* process exited or nothing to do */
> > +
> > +	if (down_write_trylock(&current->mm->mmap_sem)) {
> > +		current->mm->locked_vm += npage;
> > +		up_write(&current->mm->mmap_sem);
> > +		return;
> > +	}
> > +
> > +	/*
> > +	 * Couldn't get mmap_sem lock, so must setup to update
> > +	 * mm->locked_vm later. If locked_vm were atomic, we
> > +	 * wouldn't need this silliness
> > +	 */
> > +	vwork = kmalloc(sizeof(struct vwork), GFP_KERNEL);
> > +	if (!vwork)
> > +		return;
> > +	mm = get_task_mm(current);
> > +	if (!mm) {
> > +		kfree(vwork);
> > +		return;
> > +	}
> > +	INIT_WORK(&vwork->work, vfio_lock_acct_bg);
> > +	vwork->mm = mm;
> > +	vwork->npage = npage;
> > +	schedule_work(&vwork->work);
> > +}
> > +
> > +/*
> > + * Some mappings aren't backed by a struct page, for example an
> > +mmap'd
> > + * MMIO range for our own or another device.  These use a different
> > + * pfn conversion and shouldn't be tracked as locked pages.
> > + */
> > +bool is_invalid_reserved_pfn(unsigned long pfn) {
> > +	if (pfn_valid(pfn)) {
> > +		bool reserved;
> > +		struct page *tail = pfn_to_page(pfn);
> > +		struct page *head = compound_trans_head(tail);
> > +		reserved = !!(PageReserved(head));
> > +		if (head != tail) {
> > +			/*
> > +			 * "head" is not a dangling pointer
> > +			 * (compound_trans_head takes care of that)
> > +			 * but the hugepage may have been split
> > +			 * from under us (and we may not hold a
> > +			 * reference count on the head page so it can
> > +			 * be reused before we run PageReferenced), so
> > +			 * we've to check PageTail before returning
> > +			 * what we just read.
> > +			 */
> > +			smp_rmb();
> > +			if (PageTail(tail))
> > +				return reserved;
> > +		}
> > +		return PageReserved(tail);
> > +	}
> > +
> > +	return true;
> > +}
> > +
> > +int put_pfn(unsigned long pfn, int prot) {
> > +	if (!is_invalid_reserved_pfn(pfn)) {
> > +		struct page *page = pfn_to_page(pfn);
> > +		if (prot & IOMMU_WRITE)
> > +			SetPageDirty(page);
> > +		put_page(page);
> > +		return 1;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int vaddr_get_pfn(unsigned long vaddr, int prot, unsigned long
> > +*pfn) {
> > +	struct page *page[1];
> > +	struct vm_area_struct *vma;
> > +	int ret = -EFAULT;
> > +
> > +	if (get_user_pages_fast(vaddr, 1, !!(prot & IOMMU_WRITE), page) == 1) {
> > +		*pfn = page_to_pfn(page[0]);
> > +		return 0;
> > +	}
> > +
> > +	printk("via vma\n");
> > +	down_read(&current->mm->mmap_sem);
> > +
> > +	vma = find_vma_intersection(current->mm, vaddr, vaddr + 1);
> > +
> > +	if (vma && vma->vm_flags & VM_PFNMAP) {
> > +		*pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> > +		if (is_invalid_reserved_pfn(*pfn))
> > +			ret = 0;
> > +	}
> > +
> > +	up_read(&current->mm->mmap_sem);
> > +
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Attempt to pin pages.  We really don't want to track all the pfns
> > +and
> > + * the iommu can only map chunks of consecutive pfns anyway, so get
> > +the
> > + * first page and all consecutive pages with the same locking.
> > + */
> > +long vfio_pin_pages(unsigned long vaddr, long npage,
> > +			   int prot, unsigned long *pfn_base) {
> > +	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > +	bool lock_cap = capable(CAP_IPC_LOCK);
> > +	long ret, i;
> > +
> > +	if (!current->mm)
> > +		return -ENODEV;
> > +
> > +	ret = vaddr_get_pfn(vaddr, prot, pfn_base);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (is_invalid_reserved_pfn(*pfn_base))
> > +		return 1;
> > +
> > +	if (!lock_cap && current->mm->locked_vm + 1 > limit) {
> > +		put_pfn(*pfn_base, prot);
> > +		pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n", __func__,
> > +			limit << PAGE_SHIFT);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	if (unlikely(disable_hugepages)) {
> > +		vfio_lock_acct(1);
> > +		return 1;
> > +	}
> > +
> > +	/* Lock all the consecutive pages from pfn_base */
> > +	for (i = 1, vaddr += PAGE_SIZE; i < npage; i++, vaddr += PAGE_SIZE) {
> > +		unsigned long pfn = 0;
> > +
> > +		ret = vaddr_get_pfn(vaddr, prot, &pfn);
> > +		if (ret)
> > +			break;
> > +
> > +		if (pfn != *pfn_base + i || is_invalid_reserved_pfn(pfn)) {
> > +			put_pfn(pfn, prot);
> > +			break;
> > +		}
> > +
> > +		if (!lock_cap && current->mm->locked_vm + i + 1 > limit) {
> > +			put_pfn(pfn, prot);
> > +			pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> > +				__func__, limit << PAGE_SHIFT);
> > +			break;
> > +		}
> > +	}
> > +
> > +	vfio_lock_acct(i);
> > +
> > +	return i;
> > +}
> > +
> > +long vfio_unpin_pages(unsigned long pfn, long npage,
> > +			     int prot, bool do_accounting) {
> > +	unsigned long unlocked = 0;
> > +	long i;
> > +
> > +	for (i = 0; i < npage; i++)
> > +		unlocked += put_pfn(pfn++, prot);
> > +
> > +	if (do_accounting)
> > +		vfio_lock_acct(-unlocked);
> > +
> > +	return unlocked;
> > +}
> > diff --git a/drivers/vfio/vfio_iommu_common.h
> > b/drivers/vfio/vfio_iommu_common.h
> > new file mode 100644
> > index 0000000..4738391
> > --- /dev/null
> > +++ b/drivers/vfio/vfio_iommu_common.h
> > @@ -0,0 +1,30 @@
> > +/*
> > + * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
> > + * Copyright (C) 2013 Freescale Semiconductor, Inc.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify it
> > + * under the terms of the GNU General Public License version 2 as
> > +published
> > + * by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> > +02111-1307 USA  */
> > +
> > +#ifndef _VFIO_IOMMU_COMMON_H
> > +#define _VFIO_IOMMU_COMMON_H
> > +
> > +void vfio_lock_acct_bg(struct work_struct *work);
> 
> Does this need to be exposed?

No, will make this and other which does not need to be exposed as static to this file

Thanks
-Bharat
> 
> > +void vfio_lock_acct(long npage);
> > +bool is_invalid_reserved_pfn(unsigned long pfn); int put_pfn(unsigned
> > +long pfn, int prot);
> 
> Why are these exposed, they only seem to be used by functions in the new common
> file.
> 
> > +long vfio_pin_pages(unsigned long vaddr, long npage, int prot,
> > +		    unsigned long *pfn_base);
> > +long vfio_unpin_pages(unsigned long pfn, long npage,
> > +		      int prot, bool do_accounting);
> 
> Can we get by with just these two and vfio_lock_acct()?
> 
> > +#endif
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > b/drivers/vfio/vfio_iommu_type1.c index a9807de..e9a58fa 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -37,6 +37,7 @@
> >  #include <linux/uaccess.h>
> >  #include <linux/vfio.h>
> >  #include <linux/workqueue.h>
> > +#include "vfio_iommu_common.h"
> >
> >  #define DRIVER_VERSION  "0.2"
> >  #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
> > @@ -48,12 +49,6 @@ module_param_named(allow_unsafe_interrupts,
> >  MODULE_PARM_DESC(allow_unsafe_interrupts,
> >  		 "Enable VFIO IOMMU support for on platforms without interrupt
> > remapping support.");
> >
> > -static bool disable_hugepages;
> > -module_param_named(disable_hugepages,
> > -		   disable_hugepages, bool, S_IRUGO | S_IWUSR);
> > -MODULE_PARM_DESC(disable_hugepages,
> > -		 "Disable VFIO IOMMU support for IOMMU hugepages.");
> > -
> >  struct vfio_iommu {
> >  	struct iommu_domain	*domain;
> >  	struct mutex		lock;
> > @@ -123,205 +118,6 @@ static void vfio_remove_dma(struct vfio_iommu *iommu,
> struct vfio_dma *old)
> >  	rb_erase(&old->node, &iommu->dma_list);  }
> >
> > -struct vwork {
> > -	struct mm_struct	*mm;
> > -	long			npage;
> > -	struct work_struct	work;
> > -};
> > -
> > -/* delayed decrement/increment for locked_vm */ -static void
> > vfio_lock_acct_bg(struct work_struct *work) -{
> > -	struct vwork *vwork = container_of(work, struct vwork, work);
> > -	struct mm_struct *mm;
> > -
> > -	mm = vwork->mm;
> > -	down_write(&mm->mmap_sem);
> > -	mm->locked_vm += vwork->npage;
> > -	up_write(&mm->mmap_sem);
> > -	mmput(mm);
> > -	kfree(vwork);
> > -}
> > -
> > -static void vfio_lock_acct(long npage) -{
> > -	struct vwork *vwork;
> > -	struct mm_struct *mm;
> > -
> > -	if (!current->mm || !npage)
> > -		return; /* process exited or nothing to do */
> > -
> > -	if (down_write_trylock(&current->mm->mmap_sem)) {
> > -		current->mm->locked_vm += npage;
> > -		up_write(&current->mm->mmap_sem);
> > -		return;
> > -	}
> > -
> > -	/*
> > -	 * Couldn't get mmap_sem lock, so must setup to update
> > -	 * mm->locked_vm later. If locked_vm were atomic, we
> > -	 * wouldn't need this silliness
> > -	 */
> > -	vwork = kmalloc(sizeof(struct vwork), GFP_KERNEL);
> > -	if (!vwork)
> > -		return;
> > -	mm = get_task_mm(current);
> > -	if (!mm) {
> > -		kfree(vwork);
> > -		return;
> > -	}
> > -	INIT_WORK(&vwork->work, vfio_lock_acct_bg);
> > -	vwork->mm = mm;
> > -	vwork->npage = npage;
> > -	schedule_work(&vwork->work);
> > -}
> > -
> > -/*
> > - * Some mappings aren't backed by a struct page, for example an
> > mmap'd
> > - * MMIO range for our own or another device.  These use a different
> > - * pfn conversion and shouldn't be tracked as locked pages.
> > - */
> > -static bool is_invalid_reserved_pfn(unsigned long pfn) -{
> > -	if (pfn_valid(pfn)) {
> > -		bool reserved;
> > -		struct page *tail = pfn_to_page(pfn);
> > -		struct page *head = compound_trans_head(tail);
> > -		reserved = !!(PageReserved(head));
> > -		if (head != tail) {
> > -			/*
> > -			 * "head" is not a dangling pointer
> > -			 * (compound_trans_head takes care of that)
> > -			 * but the hugepage may have been split
> > -			 * from under us (and we may not hold a
> > -			 * reference count on the head page so it can
> > -			 * be reused before we run PageReferenced), so
> > -			 * we've to check PageTail before returning
> > -			 * what we just read.
> > -			 */
> > -			smp_rmb();
> > -			if (PageTail(tail))
> > -				return reserved;
> > -		}
> > -		return PageReserved(tail);
> > -	}
> > -
> > -	return true;
> > -}
> > -
> > -static int put_pfn(unsigned long pfn, int prot) -{
> > -	if (!is_invalid_reserved_pfn(pfn)) {
> > -		struct page *page = pfn_to_page(pfn);
> > -		if (prot & IOMMU_WRITE)
> > -			SetPageDirty(page);
> > -		put_page(page);
> > -		return 1;
> > -	}
> > -	return 0;
> > -}
> > -
> > -static int vaddr_get_pfn(unsigned long vaddr, int prot, unsigned long
> > *pfn) -{
> > -	struct page *page[1];
> > -	struct vm_area_struct *vma;
> > -	int ret = -EFAULT;
> > -
> > -	if (get_user_pages_fast(vaddr, 1, !!(prot & IOMMU_WRITE), page) == 1) {
> > -		*pfn = page_to_pfn(page[0]);
> > -		return 0;
> > -	}
> > -
> > -	down_read(&current->mm->mmap_sem);
> > -
> > -	vma = find_vma_intersection(current->mm, vaddr, vaddr + 1);
> > -
> > -	if (vma && vma->vm_flags & VM_PFNMAP) {
> > -		*pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> > -		if (is_invalid_reserved_pfn(*pfn))
> > -			ret = 0;
> > -	}
> > -
> > -	up_read(&current->mm->mmap_sem);
> > -
> > -	return ret;
> > -}
> > -
> > -/*
> > - * Attempt to pin pages.  We really don't want to track all the pfns
> > and
> > - * the iommu can only map chunks of consecutive pfns anyway, so get
> > the
> > - * first page and all consecutive pages with the same locking.
> > - */
> > -static long vfio_pin_pages(unsigned long vaddr, long npage,
> > -			   int prot, unsigned long *pfn_base)
> > -{
> > -	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > -	bool lock_cap = capable(CAP_IPC_LOCK);
> > -	long ret, i;
> > -
> > -	if (!current->mm)
> > -		return -ENODEV;
> > -
> > -	ret = vaddr_get_pfn(vaddr, prot, pfn_base);
> > -	if (ret)
> > -		return ret;
> > -
> > -	if (is_invalid_reserved_pfn(*pfn_base))
> > -		return 1;
> > -
> > -	if (!lock_cap && current->mm->locked_vm + 1 > limit) {
> > -		put_pfn(*pfn_base, prot);
> > -		pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n", __func__,
> > -			limit << PAGE_SHIFT);
> > -		return -ENOMEM;
> > -	}
> > -
> > -	if (unlikely(disable_hugepages)) {
> > -		vfio_lock_acct(1);
> > -		return 1;
> > -	}
> > -
> > -	/* Lock all the consecutive pages from pfn_base */
> > -	for (i = 1, vaddr += PAGE_SIZE; i < npage; i++, vaddr += PAGE_SIZE) {
> > -		unsigned long pfn = 0;
> > -
> > -		ret = vaddr_get_pfn(vaddr, prot, &pfn);
> > -		if (ret)
> > -			break;
> > -
> > -		if (pfn != *pfn_base + i || is_invalid_reserved_pfn(pfn)) {
> > -			put_pfn(pfn, prot);
> > -			break;
> > -		}
> > -
> > -		if (!lock_cap && current->mm->locked_vm + i + 1 > limit) {
> > -			put_pfn(pfn, prot);
> > -			pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> > -				__func__, limit << PAGE_SHIFT);
> > -			break;
> > -		}
> > -	}
> > -
> > -	vfio_lock_acct(i);
> > -
> > -	return i;
> > -}
> > -
> > -static long vfio_unpin_pages(unsigned long pfn, long npage,
> > -			     int prot, bool do_accounting)
> > -{
> > -	unsigned long unlocked = 0;
> > -	long i;
> > -
> > -	for (i = 0; i < npage; i++)
> > -		unlocked += put_pfn(pfn++, prot);
> > -
> > -	if (do_accounting)
> > -		vfio_lock_acct(-unlocked);
> > -
> > -	return unlocked;
> > -}
> > -
> >  static int vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
> >  			    dma_addr_t iova, size_t *size)  {
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
