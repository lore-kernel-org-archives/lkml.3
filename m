Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaLDPtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:49:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbaLDPtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:49:22 -0500
Message-ID: <54808276.9090309@redhat.com>
Date: Thu, 04 Dec 2014 16:49:10 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Nadav Amit <nadav.amit@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] kvm: cpuid: fix the size of xsaves area
References: <1417691470-5221-1-git-send-email-wanpeng.li@linux.intel.com> <1417691470-5221-2-git-send-email-wanpeng.li@linux.intel.com> <20141204131454.GA17050@potion.brq.redhat.com>
In-Reply-To: <20141204131454.GA17050@potion.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/12/2014 14:14, Radim Krčmář wrote:
> 2014-12-04 19:11+0800, Wanpeng Li:
>> The section of CPUID(EAX=0xd, ECX=1) in the spec which commit
>> f5c2290cd01e (KVM: cpuid: mask more bits in leaf 0xd and subleaves)
>> mentioned is older than SDM.
>>
>> EBX: Bits 31-00: The size in bytes of the XSAVE area containing all
>> states enabled by XCR0|IA32_XSS.
> 
> Well, CPUs without XSAVES return 0 there, so we would emulate them
> incorrectly ... (I don't mind much, it is reserved.)

I agree it should stay to 0 if !XSAVES && !XSAVEC.

For !XSAVEC && XSAVES there's no silicon, so we have some leeway.

>> The the value of EBX should represent the size of XCR0 related XSAVE
>> area since IA32_XSS is not used currently.
> 
> True, but 'supported' is not the state of XCR0, just its supremum.
> EBX should be set in kvm_update_cpuid(), like [3/4] does.
> (We can safely drop [2/4].)

Still, it's nice to be consistent and return a plausible value to
userspace for KVM_GET_SUPPORTED_CPUID.

Paolo
