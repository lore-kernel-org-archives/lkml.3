Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbaGDCfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 22:35:15 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:37925 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355AbaGDCfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 22:35:13 -0400
X-IronPort-AV: E=Sophos;i="5.00,829,1396972800"; 
   d="scan'208";a="32824052"
Message-ID: <53B61316.2050208@cn.fujitsu.com>
Date: Fri, 4 Jul 2014 10:36:06 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: <mtosatti@redhat.com>, <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] kvm, memory-hotplug: Update ept identity pagetable
 when it is migrated.
References: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com> <1404291637-15048-4-git-send-email-tangchen@cn.fujitsu.com> <20140702163420.GC4399@minantech.com>
In-Reply-To: <20140702163420.GC4399@minantech.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb,

On 07/03/2014 12:34 AM, Gleb Natapov wrote:
> On Wed, Jul 02, 2014 at 05:00:36PM +0800, Tang Chen wrote:
>> ept identity pagetable is pinned in memory, and as a result it cannot be
>> migrated/hot-removed.
>>
>> But actually it doesn't need to be pinned in memory.
>>
>> This patch introduces a new vcpu request: KVM_REQ_MIGRATE_EPT to reset ept
>> indetity pagetable related variable. This request will be made when
>> kvm_mmu_notifier_invalidate_page() is called when the page is unmapped
>> from the qemu user space to reset kvm->arch.ept_identity_pagetable to NULL.
>> And will also be made when ept violation happens to reset
>> kvm->arch.ept_identity_pagetable to the new page.
>
> kvm->arch.ept_identity_pagetable is never used as a page address, just
> boolean null/!null to see if identity pagetable is initialized. I do
> not see why would we want to track its address at all. Changing it to bool
> and assigning true during initialization should be enough.

We already have kvm->arch.ept_identity_pagetable_done to indicate if the 
ept
identity table is initialized. If we make 
kvm->arch.ept_identity_pagetable to
bool, do you mean we have:

kvm->arch.ept_identity_pagetable: indicate if ept page is allocated,
kvm->arch.ept_identity_pagetable_done: indicate if ept page is initialized ?

I don't think we need this. Shall we remove 
kvm->arch.ept_identity_pagetable ?

Thanks.

