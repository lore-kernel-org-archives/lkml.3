Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3GSVAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:00:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab3GSVAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:00:41 -0400
Message-ID: <51E9A8E0.8080404@redhat.com>
Date: Fri, 19 Jul 2013 23:00:16 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jason Wang <jasowang@redhat.com>, gleb@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vadim Rozenfeld <vrozenfe@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: [PATCH] x86: properly handle KVM emulation of hyperv
References: <1374229505-19470-1-git-send-email-jasowang@redhat.com> <51E92CAB.7020906@redhat.com> <51E9A896.8070408@zytor.com>
In-Reply-To: <51E9A896.8070408@zytor.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/07/2013 22:59, H. Peter Anvin ha scritto:
>>> >> -		cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
>>> >> -		memcpy(signature + 0, &ebx, 4);
>>> >> -		memcpy(signature + 4, &ecx, 4);
>>> >> -		memcpy(signature + 8, &edx, 4);
>>> >> -		signature[12] = 0;
>>> >> -
>>> >> -		if (strcmp(signature, "KVMKVMKVM") == 0)
>>> >> +		if (kvm_para_available_function(KVM_CPUID_SIGNATURE) ||
>>> >> +		    kvm_para_available_function(KVM_CPUID_SIGNATURE_NEXT))
>>> >>  			return true;
>>> >>  	}
>> > 
>> > Nice catch.  Just one small thing, you should loop until 0x40010000, as
>> > done in arch/x86/include/asm/xen/hypervisor.h, in case one day a third
>> > hypervisor implements three extensions (Hyper-V, KVM and its own set).
>> > 
> Any way we can centralize this stuff?

I guess a function cpuid_hypervisor_base("KVMKVMKVM") that does the scan?

Paolo
