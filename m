Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab3DYJYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:24:44 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:50763 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3DYJYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:24:43 -0400
Message-ID: <5178F639.3080803@linux.vnet.ibm.com>
Date: Thu, 25 Apr 2013 17:24:09 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: mtosatti@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/6] KVM: MMU: make return value of mmio page fault
 handler more readable
References: <1364810209-25954-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1364810209-25954-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130424133458.GR12401@redhat.com>
In-Reply-To: <20130424133458.GR12401@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042509-5490-0000-0000-000003589595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 09:34 PM, Gleb Natapov wrote:

>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>> index 2adcbc2..6b4ba1e 100644
>> --- a/arch/x86/kvm/mmu.h
>> +++ b/arch/x86/kvm/mmu.h
>> @@ -52,6 +52,20 @@
>>  
>>  int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
>>  void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask);
>> +
>> +/*
>> + * Return values of handle_mmio_page_fault_common:
>> + * RET_MMIO_PF_EMU: it is a real mmio page fault, emulate the instruction
>> + *		    directly.
>> + * RET_MMIO_PF_RETRY: let CPU fault again on the address.
>> + * RET_MMIO_PF_BUG: bug is detected.
>> + */
>> +enum {
>> +	RET_MMIO_PF_EMU = 1,
> Make it RET_MMIO_PF_EMULATE please.

Good to me, will do.

Thanks!

