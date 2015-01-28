Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004AbbA1GUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:20:06 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:55797 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbbA1GUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:20:04 -0500
MIME-Version: 1.0
In-Reply-To: <54C804FD.6060108@redhat.com>
References: <CACzj_yXLgAKaRzXx4Y=ZQN=QXK8EnX4fvcSTJmKSXSywN2Kb8Q@mail.gmail.com>
 <54C804FD.6060108@redhat.com>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Wed, 28 Jan 2015 14:19:42 +0800
Message-ID: <CACzj_yUdLy5QjpNTqesWbvR6ytTixszJNNOZvH=bw-SOhrjapw@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] KVM: nVMX: Enable nested virtualize x2apic mode.
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "gleb@kernel.org" <gleb@kernel.org>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 5:37 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> On 24/01/2015 11:21, Wincy Van wrote:
>> +       memset(vmx_msr_bitmap_nested, 0xff, PAGE_SIZE);
>
> Most bytes are always 0xff.  It's better to initialize it to 0xff once,
> and set the bit here if !nested_cpu_has_virt_x2apic_mode(vmcs12).

Indeed, will do.

>
>> +       if (nested_cpu_has_virt_x2apic_mode(vmcs12))
>
> Please add braces here, because of the /* */ command below.

Will do.

>
>> +               /* TPR is allowed */
>> +               nested_vmx_disable_intercept_for_msr(msr_bitmap,
>> +                               vmx_msr_bitmap_nested,
>> +                               APIC_BASE_MSR + (APIC_TASKPRI >> 4),
>> +                               MSR_TYPE_R | MSR_TYPE_W);
>>
>> +static inline int nested_vmx_check_virt_x2apic(struct kvm_vcpu *vcpu,
>> +                                              struct vmcs12 *vmcs12)
>> +{
>> +       if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
>> +               return -EINVAL;
>
> No need for this function and nested_cpu_has_virt_x2apic_mode.  Just
> inline them in their caller(s).  Same for other cases throughout the series.
>

Do you mean that we should also inline the same functions in the other
patches of this patch set?
I think these functions will keep the code tidy, just like the
functions as nested_cpu_has_preemption_timer, nested_cpu_has_ept, etc.
