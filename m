Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaF3BDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 21:03:53 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:57273 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbaF3BDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 21:03:52 -0400
Message-ID: <53B0B773.3030107@gmail.com>
Date: Mon, 30 Jun 2014 04:03:47 +0300
From: Nadav Amit <nadav.amit@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, Nadav Amit <namit@cs.technion.ac.il>
CC: pbonzini@redhat.com, gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix lapic.c debug prints
References: <1404034131-2392-1-git-send-email-namit@cs.technion.ac.il> <jpgr427kys6.fsf@redhat.com>
In-Reply-To: <jpgr427kys6.fsf@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/30/14, 3:48 AM, Bandan Das wrote:
> Nadav Amit <namit@cs.technion.ac.il> writes:
>
>> In two cases lapic.c does not use the apic_debug macro correctly. This patch
>> fixes them.
>>
>> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
>> ---
>>   arch/x86/kvm/lapic.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 0069118..3855103 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -1451,7 +1451,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
>>   	vcpu->arch.apic_arb_prio = 0;
>>   	vcpu->arch.apic_attention = 0;
>>
>> -	apic_debug(KERN_INFO "%s: vcpu=%p, id=%d, base_msr="
>> +	apic_debug("%s: vcpu=%p, id=%d, base_msr="
>>   		   "0x%016" PRIx64 ", base_address=0x%0lx.\n", __func__,
>>   		   vcpu, kvm_apic_id(apic),
>>   		   vcpu->arch.apic_base, apic->base_address);
>> @@ -1895,7 +1895,7 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>>   		/* evaluate pending_events before reading the vector */
>>   		smp_rmb();
>>   		sipi_vector = apic->sipi_vector;
>> -		pr_debug("vcpu %d received sipi with vector # %x\n",
>> +		apic_debug("vcpu %d received sipi with vector # %x\n",
>
> Why don't we just use pr_debug all throughout ?
>
I don't know. I just tried to make it consistent, since it really bugged 
me while I was debugging the local-apic.
If you prefer the other way around (which does seem to be better), I can 
do the search-and-replace.

Nadav
