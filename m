Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaGIBTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 21:19:43 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:64421 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752135AbaGIBTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 21:19:41 -0400
X-IronPort-AV: E=Sophos;i="5.00,860,1396972800"; 
   d="scan'208";a="33020264"
Message-ID: <53BC98E1.5050006@cn.fujitsu.com>
Date: Wed, 9 Jul 2014 09:20:33 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>
CC: Tang Chen <tangchen@cn.fujitsu.com>, <kvm@vger.kernel.org>,
        <laijs@cn.fujitsu.com>, <isimatu.yasuaki@jp.fujitsu.com>,
        <guz.fnst@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] kvm, mem-hotplug: Do not pin ept identity pagetable
 and apic access page.
References: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 09:01 PM, Tang Chen wrote:
> ept identity pagetable and apic access page in kvm are pinned in memory.
> As a result, they cannot be migrated/hot-removed.
>
> But actually they don't need to be pinned in memory.
>
> [For ept identity page]
> Just do not pin it. When it is migrated, guest will be able to find the
> new page in the next ept violation.
>
> [For apic access page]
> The hpa of apic access page is stored in VMCS APIC_ACCESS_ADDR pointer.
> When apic access page is migrated, we update VMCS APIC_ACCESS_ADDR pointer
> for each vcpu in addition.
>
> Change log v1 ->  v2:
> 1. Add [PATCH 4/5] to remove unnecessary kvm_arch->ept_identity_pagetable.
> 2. In [PATCH 3/5], only introduce KVM_REQ_APIC_PAGE_RELOAD request.

      s/[PATCH 3/5]/[PATCH 5/5]

> 3. In [PATCH 3/5], add set_apic_access_page_addr() for svm.

      s/[PATCH 3/5]/[PATCH 5/5]

>
>
> Tang Chen (5):
>    kvm: Add gfn_to_page_no_pin() to translate gfn to page without
>      pinning.
>    kvm: Use APIC_DEFAULT_PHYS_BASE macro as the apic access page address.
>    kvm, mem-hotplug: Do not pin ept identity pagetable in memory.
>    kvm: Remove ept_identity_pagetable from struct kvm_arch.
>    kvm, mem-hotplug: Do not pin apic access page in memory.
>
>   arch/x86/include/asm/kvm_host.h |  2 +-
>   arch/x86/kvm/mmu.c              | 11 +++++++++++
>   arch/x86/kvm/svm.c              |  9 ++++++++-
>   arch/x86/kvm/vmx.c              | 40 ++++++++++++++++++++++------------------
>   arch/x86/kvm/x86.c              | 16 ++++++++++++++--
>   include/linux/kvm_host.h        |  3 +++
>   virt/kvm/kvm_main.c             | 29 ++++++++++++++++++++++++++++-
>   7 files changed, 87 insertions(+), 23 deletions(-)
>
