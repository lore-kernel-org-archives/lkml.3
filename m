Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaIPLou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:44:50 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:35513 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbaIPLos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:44:48 -0400
Message-ID: <541822AA.6060200@redhat.com>
Date: Tue, 16 Sep 2014 13:44:42 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, gleb@kernel.org, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de
CC: kvm@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/6] kvm, mem-hotplug: Do not pin ept identity pagetable
 and apic access page.
References: <1410864122-12434-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1410864122-12434-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/09/2014 12:41, Tang Chen ha scritto:
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
> NOTE: Tested with -cpu xxx,-x2apic option.
>       But since nested vm pins some other pages in memory, if user uses nested
>       vm, memory hot-remove will not work.
> 
> Change log v5 -> v6:
> 1. Patch 1/6 has been applied by Paolo Bonzini <pbonzini@redhat.com>, just resend it.
> 2. Simplify comment in alloc_identity_pagetable() and add a BUG_ON() in patch 2/6.
> 3. Move err initialization forward in patch 3/6.
> 4. Rename vcpu_reload_apic_access_page() to kvm_vcpu_reload_apic_access_page() and 
>    use it instead of kvm_reload_apic_access_page() in nested_vmx_vmexit() in patch 5/6.
> 5. Reuse kvm_vcpu_reload_apic_access_page() in prepare_vmcs02() and vmx_vcpu_reset() in patch 6/6.
> 6. Remove original patch 7 since we are not able to handle the situation in nested vm.

I'll push 1-3 soon to kvm/queue.  I think v7 will be good. :)

Paolo
