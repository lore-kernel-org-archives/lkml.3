Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934747Ab3FSNAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:00:09 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:34246 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869Ab3FSNAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:00:07 -0400
Message-ID: <51C1AB4E.5020402@linux.vnet.ibm.com>
Date: Wed, 19 Jun 2013 20:59:58 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 4/7] KVM: MMU: document mmio page fault
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1371632965-20077-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <51C19FC6.9020001@redhat.com>
In-Reply-To: <51C19FC6.9020001@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061912-1396-0000-0000-000003244E6B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 08:10 PM, Paolo Bonzini wrote:
> Il 19/06/2013 11:09, Xiao Guangrong ha scritto:
>> Document it to Documentation/virtual/kvm/mmu.txt
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  Documentation/virtual/kvm/mmu.txt | 11 +++++++++--
>>  1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
>> index 5a6b2e2..4fb442b 100644
>> --- a/Documentation/virtual/kvm/mmu.txt
>> +++ b/Documentation/virtual/kvm/mmu.txt
>> @@ -270,14 +270,21 @@ This is the most complicated event.  The cause of a page fault can be:
>>  
>>  Handling a page fault is performed as follows:
>>  
>> + - if the RSV bit of the error code is set, the page fault is caused by guest
>> +   accessing MMIO, walk shadow page table to get the last spte where the mmio
>> +   information is stored and cache the information to vcpu->arch.mmio_gva,
>> +   vcpu->arch.access and vcpu->arch.mmio_gfn then call the emulator to emulate
>> +   the instruction who will get the benefit from the cached mmio info
> 
> + - if the RSV bit of the error code is set, the page fault is caused by guest
> +   accessing MMIO and cached MMIO information is available.
> +   - walk shadow page table
> +   - cache the information to vcpu->arch.mmio_gva, vcpu->arch.access and
> +     vcpu->arch.mmio_gfn, and call the emulator

Nice.

> 
>>   - if needed, walk the guest page tables to determine the guest translation
>>     (gva->gpa or ngpa->gpa)
>>     - if permissions are insufficient, reflect the fault back to the guest
>>   - determine the host page
>> -   - if this is an mmio request, there is no host page; call the emulator
>> -     to emulate the instruction instead
>> +   - if this is an mmio request, there is no host page; cache the info to
>> +     vcpu->arch.mmio_gva, vcpu->arch.access and vcpu->arch.mmio_gfn
>>   - walk the shadow page table to find the spte for the translation,
>>     instantiating missing intermediate page tables as necessary
>> +   - If this is an mmio request, cache the mmio info to the spte and set some
>> +     reserved bits on the spte
> 
> Added "(see callers of kvm_mmu_set_mmio_spte_mask)".  Not really related, but
> just came to my mind: perhaps we can have a section on A/D bits too.

It is useful i think. Will do it.

