Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbaGBQea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:34:30 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62701 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbaGBQe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:34:28 -0400
Date: Wed, 2 Jul 2014 19:34:20 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] kvm, memory-hotplug: Update ept identity pagetable
 when it is migrated.
Message-ID: <20140702163420.GC4399@minantech.com>
References: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com>
 <1404291637-15048-4-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404291637-15048-4-git-send-email-tangchen@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 05:00:36PM +0800, Tang Chen wrote:
> ept identity pagetable is pinned in memory, and as a result it cannot be
> migrated/hot-removed.
> 
> But actually it doesn't need to be pinned in memory.
> 
> This patch introduces a new vcpu request: KVM_REQ_MIGRATE_EPT to reset ept
> indetity pagetable related variable. This request will be made when
> kvm_mmu_notifier_invalidate_page() is called when the page is unmapped
> from the qemu user space to reset kvm->arch.ept_identity_pagetable to NULL.
> And will also be made when ept violation happens to reset
> kvm->arch.ept_identity_pagetable to the new page.

kvm->arch.ept_identity_pagetable is never used as a page address, just
boolean null/!null to see if identity pagetable is initialized. I do
not see why would we want to track its address at all. Changing it to bool
and assigning true during initialization should be enough.


--
			Gleb.
