Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaBXLNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 06:13:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbaBXLNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 06:13:20 -0500
Message-ID: <530B2949.4030000@redhat.com>
Date: Mon, 24 Feb 2014 12:13:13 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'qemu-devel@nongnu.org'" <qemu-devel@nongnu.org>
CC: "'gleb@redhat.com'" <gleb@redhat.com>, "'hpa@zytor.com'" <hpa@zytor.com>
Subject: Re: [PATCH v5 3/3] KVM: x86: Enable Intel MPX for guest
References: <DE8DF0795D48FD4CA783C40EC82923350150E43C@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350150E43C@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/02/2014 11:58, Liu, Jinsong ha scritto:
> @@ -599,6 +599,9 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>  	u64 old_xcr0 = vcpu->arch.xcr0;
>  	u64 valid_bits;
>
> +	if (!kvm_x86_ops->mpx_supported || !kvm_x86_ops->mpx_supported())
> +		xcr0 &= ~(XSTATE_BNDREGS | XSTATE_BNDCSR);
> +
>  	/* Only support XCR_XFEATURE_ENABLED_MASK(xcr0) now  */
>  	if (index != XCR_XFEATURE_ENABLED_MASK)
>  		return 1;

This hunk is incorrect, and I can simply drop it when applying.  If MPX 
is not supported, it should not be in the 0Dh CPUID leaf and thus in 
vcpu->arch.guest_supported_xcr0.

This however relies on userspace passing a "sensible" value of CPUID. 
I'll send a patch to strengthen the computation of guest_supported_xcr0.

Thanks!

Paolo
