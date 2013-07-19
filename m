Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab3GSVEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:04:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48260 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab3GSVEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:04:08 -0400
Message-ID: <51E9A9BA.1070805@zytor.com>
Date: Fri, 19 Jul 2013 14:03:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Jason Wang <jasowang@redhat.com>, gleb@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vadim Rozenfeld <vrozenfe@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: [PATCH] x86: properly handle KVM emulation of hyperv
References: <1374229505-19470-1-git-send-email-jasowang@redhat.com> <51E92CAB.7020906@redhat.com> <51E9A896.8070408@zytor.com> <51E9A8E0.8080404@redhat.com>
In-Reply-To: <51E9A8E0.8080404@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 02:00 PM, Paolo Bonzini wrote:
> Il 19/07/2013 22:59, H. Peter Anvin ha scritto:
>>>>>> -		cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
>>>>>> -		memcpy(signature + 0, &ebx, 4);
>>>>>> -		memcpy(signature + 4, &ecx, 4);
>>>>>> -		memcpy(signature + 8, &edx, 4);
>>>>>> -		signature[12] = 0;
>>>>>> -
>>>>>> -		if (strcmp(signature, "KVMKVMKVM") == 0)
>>>>>> +		if (kvm_para_available_function(KVM_CPUID_SIGNATURE) ||
>>>>>> +		    kvm_para_available_function(KVM_CPUID_SIGNATURE_NEXT))
>>>>>>  			return true;
>>>>>>  	}
>>>>
>>>> Nice catch.  Just one small thing, you should loop until 0x40010000, as
>>>> done in arch/x86/include/asm/xen/hypervisor.h, in case one day a third
>>>> hypervisor implements three extensions (Hyper-V, KVM and its own set).
>>>>
>> Any way we can centralize this stuff?
> 
> I guess a function cpuid_hypervisor_base("KVMKVMKVM") that does the scan?
> 

Something like that.

	-hpa


