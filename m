Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaGDJt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:49:56 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56757 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaGDJtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:49:55 -0400
Date: Fri, 4 Jul 2014 12:49:50 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] kvm, memory-hotplug: Update ept identity pagetable
 when it is migrated.
Message-ID: <20140704094949.GD4399@minantech.com>
References: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com>
 <1404291637-15048-4-git-send-email-tangchen@cn.fujitsu.com>
 <20140702163420.GC4399@minantech.com>
 <53B61316.2050208@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B61316.2050208@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 10:36:06AM +0800, Tang Chen wrote:
> Hi Gleb,
> 
> On 07/03/2014 12:34 AM, Gleb Natapov wrote:
> >On Wed, Jul 02, 2014 at 05:00:36PM +0800, Tang Chen wrote:
> >>ept identity pagetable is pinned in memory, and as a result it cannot be
> >>migrated/hot-removed.
> >>
> >>But actually it doesn't need to be pinned in memory.
> >>
> >>This patch introduces a new vcpu request: KVM_REQ_MIGRATE_EPT to reset ept
> >>indetity pagetable related variable. This request will be made when
> >>kvm_mmu_notifier_invalidate_page() is called when the page is unmapped
> >>from the qemu user space to reset kvm->arch.ept_identity_pagetable to NULL.
> >>And will also be made when ept violation happens to reset
> >>kvm->arch.ept_identity_pagetable to the new page.
> >
> >kvm->arch.ept_identity_pagetable is never used as a page address, just
> >boolean null/!null to see if identity pagetable is initialized. I do
> >not see why would we want to track its address at all. Changing it to bool
> >and assigning true during initialization should be enough.
> 
> We already have kvm->arch.ept_identity_pagetable_done to indicate if the ept
> identity table is initialized. If we make kvm->arch.ept_identity_pagetable
> to
> bool, do you mean we have:
> 
> kvm->arch.ept_identity_pagetable: indicate if ept page is allocated,
> kvm->arch.ept_identity_pagetable_done: indicate if ept page is initialized ?
> 
ept_identity_pagetable also means that a memory slot for identity page is initialized.

> I don't think we need this. Shall we remove kvm->arch.ept_identity_pagetable
> ?
> 
May be those two can be consolidated somehow, but lets leave it to a separate patch
to make this one simpler.

--
			Gleb.
