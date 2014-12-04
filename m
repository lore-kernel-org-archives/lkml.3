Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaLDIzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:55:09 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61036 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbaLDIzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:55:07 -0500
Message-ID: <5480215A.7010300@gmail.com>
Date: Thu, 04 Dec 2014 16:54:50 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>, Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] kvm: cpuid: fix xsave area size of XSAVEC
References: <1417681468-7165-1-git-send-email-wanpeng.li@linux.intel.com> <1417681468-7165-3-git-send-email-wanpeng.li@linux.intel.com> <1EDEA01D-B396-4F17-947A-22CA4AA4BC61@gmail.com>
In-Reply-To: <1EDEA01D-B396-4F17-947A-22CA4AA4BC61@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nadav,
On 12/4/14, 4:30 PM, Nadav Amit wrote:
> Wanpeng Li <wanpeng.li@linux.intel.com> wrote:
>
>> XSAVEC also use the compacted format for the extended region
>> of the XSAVE area. This patch fix it by caculate the size of
>> XSAVEC extended region of XSAVE area as compact format.
>>
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> ---
>> arch/x86/kvm/cpuid.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 70f0fa1..e16a0c7 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -92,7 +92,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>> 	}
>>
>> 	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
>> -	if (best && (best->eax & F(XSAVES)))
>> +	if (best && (best->eax & (F(XSAVES) || F(XSAVEC))))
> Did you want to use | (bitwise or) instead of II (logical or) ?

I make a mistake here, I will fix it in next version.

Regards,
Wanpeng Li

>
>> 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>>
>> 	/*
>> -- 
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Nadav
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

