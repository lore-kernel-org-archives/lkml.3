Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaBXPha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:37:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:16215 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbaBXPh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:37:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,535,1389772800"; 
   d="scan'208";a="487152839"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'qemu-devel@nongnu.org'" <qemu-devel@nongnu.org>
CC: "'gleb@redhat.com'" <gleb@redhat.com>, "'hpa@zytor.com'" <hpa@zytor.com>
Subject: RE: [PATCH v5 3/3] KVM: x86: Enable Intel MPX for guest
Thread-Topic: [PATCH v5 3/3] KVM: x86: Enable Intel MPX for guest
Thread-Index: AQHPMVFoW8dynEC7TZelS5RsgdKoeZrEiVWA
Date: Mon, 24 Feb 2014 15:37:18 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350150F2D0@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923350150E43C@SHSMSX101.ccr.corp.intel.com>
 <530B2949.4030000@redhat.com>
In-Reply-To: <530B2949.4030000@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini wrote:
> Il 24/02/2014 11:58, Liu, Jinsong ha scritto:
>> @@ -599,6 +599,9 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32
>>  	index, u64 xcr) u64 old_xcr0 = vcpu->arch.xcr0;
>>  	u64 valid_bits;
>> 
>> +	if (!kvm_x86_ops->mpx_supported || !kvm_x86_ops->mpx_supported())
>> +		xcr0 &= ~(XSTATE_BNDREGS | XSTATE_BNDCSR);
>> +
>>  	/* Only support XCR_XFEATURE_ENABLED_MASK(xcr0) now  */
>>  	if (index != XCR_XFEATURE_ENABLED_MASK)
>>  		return 1;
> 
> This hunk is incorrect, and I can simply drop it when applying.  If
> MPX is not supported, it should not be in the 0Dh CPUID leaf and thus
> in vcpu->arch.guest_supported_xcr0.
> 
> This however relies on userspace passing a "sensible" value of CPUID.
> I'll send a patch to strengthen the computation of
> guest_supported_xcr0. 
> 
> Thanks!
> 
> Paolo

So patch v5 would be applied except you will remove the incorrect hunk, and you will send a patch strengthenning guest_supported_xcr0?

Thanks,
Jinsong