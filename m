Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbaGCGEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 02:04:32 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:49812 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaGCGEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 02:04:15 -0400
Date: Thu, 3 Jul 2014 09:04:10 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] kvm, mem-hotplug: Do not pin ept identity pagetable
 and apic access page.
Message-ID: <20140703060409.GL18167@minantech.com>
References: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com>
 <53B4AF47.1080008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B4AF47.1080008@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 09:17:59AM +0800, Tang Chen wrote:
> Hi Gleb,
> 
> On 07/02/2014 05:00 PM, Tang Chen wrote:
> >Hi Gleb, Marcelo,
> >
> >Please help to review this patch-set.
> >
> >NOTE: This patch-set doesn't work properly.
> >
> >
> >ept identity pagetable and apic access page in kvm are pinned in memory.
> >As a result, they cannot be migrated/hot-removed.
> >
> >But actually they don't need to be pinned in memory.
> >
> >This patch-set introduces two new vcpu requests: KVM_REQ_MIGRATE_EPT and KVM_REQ_MIGRATE_APIC.
> >These two requests are made when the two pages are migrated by the mmu_notifier
> >to reset the related variable to unusable value. And will also be made when
> >ept violation happens to reset new pages.
> >
> >
> >[Known problem]
> >After this patch-set applied, the two pages can be migrated/hot-removed.
> >But after migrating apic access page, the guest died.
> >
> >The host physical address of apic access page is stored in VMCS. I reset
> >it to 0 to stop guest from accessing it when it is unmapped by
> >kvm_mmu_notifier_invalidate_page(). And reset it to new page's host physical
> >address in tdp_page_fault(). But it seems that guest will access apic page
> >directly by the host physical address.
> 
> Would you please to give some advice about this problem ?
> 
I haven't reviewed third patch yet, will do ASAP.

--
			Gleb.
