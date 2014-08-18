Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbaHRJjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:39:43 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:44055 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaHRJjl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:39:41 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] KVM: x86: Increase the number of fixed MTRR regs to 10
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20140818081115.GA26307@kernel>
Date: Mon, 18 Aug 2014 12:39:36 +0300
Cc: Nadav Amit <namit@cs.technion.ac.il>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "gleb@kernel.org" <gleb@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <A04378F6-A6B1-46B8-B306-A9A2115F54C7@gmail.com>
References: <1403101279-23759-1-git-send-email-namit@cs.technion.ac.il> <20140818021715.GA7019@kernel> <BA71F1A6-1DF2-4683-9207-2305D1155239@gmail.com> <20140818081115.GA26307@kernel>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I reproduced the blue-screen. Let me to to figure it out.

Nadav

On Aug 18, 2014, at 11:11 AM, Wanpeng Li <wanpeng.li@linux.intel.com> wrote:

> On Mon, Aug 18, 2014 at 09:39:39AM +0300, Nadav Amit wrote:
>> This should have been a benign patch. I'll try to get windows 7 installation disk and check ASAP.
>> 
> 
> In addition, it just can be reproduced on 32bit win7 w/ MP enabled, in
> case UP can't be reproduced.
> 
> Regards,
> Wanpeng Li 
> 
>> Nadav
>> 
>>> On 18 Aug 2014, at 05:17, Wanpeng Li <wanpeng.li@linux.intel.com> wrote:
>>> 
>>> Hi Nadav,
>>>> On Wed, Jun 18, 2014 at 05:21:19PM +0300, Nadav Amit wrote:
>>>> Recent Intel CPUs have 10 variable range MTRRs. Since operating systems
>>>> sometime make assumptions on CPUs while they ignore capability MSRs, it is
>>>> better for KVM to be consistent with recent CPUs. Reporting more MTRRs than
>>>> actually supported has no functional implications.
>>>> 
>>>> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
>>>> ---
>>>> arch/x86/include/asm/kvm_host.h | 2 +-
>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>> 
>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>>> index 4931415..0bab29d 100644
>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>> @@ -95,7 +95,7 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
>>>> #define KVM_REFILL_PAGES 25
>>>> #define KVM_MAX_CPUID_ENTRIES 80
>>>> #define KVM_NR_FIXED_MTRR_REGION 88
>>>> -#define KVM_NR_VAR_MTRR 8
>>>> +#define KVM_NR_VAR_MTRR 10
>>> 
>>> We observed that there is obvious regression caused by this commit, 32bit 
>>> win7 guest show blue screen during boot.
>>> 
>>> Regards,
>>> Wanpeng Li 
>>> 
>>>> #define ASYNC_PF_PER_VCPU 64
>>>> 
>>>> -- 
>>>> 1.9.1
>>>> 
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

