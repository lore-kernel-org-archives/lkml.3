Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbaKZQqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:46:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbaKZQqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:46:51 -0500
Message-ID: <547603CD.6060708@redhat.com>
Date: Wed, 26 Nov 2014 17:46:05 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Andrew Jones <drjones@redhat.com>
CC: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de,
        Catalin Marinas <catalin.marinas@arm.com>, jan.kiszka@siemens.com,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com,
        r65777@freescale.com, bp@suse.de
Subject: Re: [PATCH 2/7] KVM: arm: guest debug, define API headers
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org> <1416931805-23223-3-git-send-email-alex.bennee@linaro.org> <20141126143122.GB3245@hawk.usersys.redhat.com> <87sih6knzr.fsf@linaro.org>
In-Reply-To: <87sih6knzr.fsf@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 26/11/2014 15:58, Alex Bennée wrote:
> 
> Andrew Jones <drjones@redhat.com> writes:
> 
>> On Tue, Nov 25, 2014 at 04:10:00PM +0000, Alex Bennée wrote:
>>> This commit defines the API headers for guest debugging. There are two
>>> architecture specific debug structures:
> <snip>
>>> +/* Architecture related debug defines - upper 16 bits of
>>> + * kvm_guest_debug->control
>>> + */
>>> +#define KVM_GUESTDBG_USE_SW_BP_SHIFT	16
>>> +#define KVM_GUESTDBG_USE_SW_BP		(1 << KVM_GUESTDBG_USE_SW_BP_SHIFT)
>>> +#define KVM_GUESTDBG_USE_HW_BP_SHIFT	17
>>> +#define KVM_GUESTDBG_USE_HW_BP		(1 << KVM_GUESTDBG_USE_HW_BP_SHIFT)
>>> +
>>
>> I see this are defined in arch/x86/include/uapi/asm/kvm.h,
>> so you needed to reproduce them here, but shouldn't they
>> be promoted to include/uapi/linux/kvm.h instead?
> 
> Well if we move them to common uapi we either restrict the $ARCH
> specific options that don't have SW/HW BKPTS (would be weird but...) or
> make them generic in the lower 16 bits (breaks API).
> 
> But in principle I have no objection if other don't.

I think it's a matter of personal taste.  "Architecture-specific" means
"not all architectures may support it", but it's certainly a good idea
to reuse the same value if multiple architectures do support a #define.

What you did is fine, another possibility is to do

    #define __KVM_GUESTDBG_USE_SW_BP   (1 << 16)

in include/uapi/linux/kvm.h, and

    #define KVM_GUESTDBG_USE_SW_BP __KVM_GUESTDBG_USE_SW_BP

in the arch-specific file.  Andrew, is this closer to what you intended?

Paolo
