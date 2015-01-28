Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbbA1Fyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:54:53 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:63301 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbbA1Fyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 00:54:52 -0500
MIME-Version: 1.0
In-Reply-To: <54C80955.4070305@redhat.com>
References: <CACzj_yWZSJkfn0JAJr9w6hLWtMbr3PpHQVxH_GkwmY8g3x1x8w@mail.gmail.com>
 <54C80955.4070305@redhat.com>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Wed, 28 Jan 2015 13:54:30 +0800
Message-ID: <CACzj_yUn8yMY1iW2Umd_nYX29jw1vyuPd=m+jfx55ZwXXUPTBw@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] KVM: nVMX: Enable nested posted interrupt processing.
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

On Wed, Jan 28, 2015 at 5:55 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> On 24/01/2015 11:24, Wincy Van wrote:
>>         if (!nested_cpu_has_virt_x2apic_mode(vmcs12) &&
>>             !nested_cpu_has_apic_reg_virt(vmcs12) &&
>> -           !nested_cpu_has_vid(vmcs12))
>> +           !nested_cpu_has_vid(vmcs12) &&
>> +           !nested_cpu_has_posted_intr(vmcs12))
>>                 return 0;
>>
>>         if (nested_cpu_has_virt_x2apic_mode(vmcs12))
>>                 r = nested_vmx_check_virt_x2apic(vcpu, vmcs12);
>>         if (nested_cpu_has_vid(vmcs12))
>>                 r |= nested_vmx_check_vid(vcpu, vmcs12);
>> +       if (nested_cpu_has_posted_intr(vmcs12))
>> +               r |= nested_vmx_check_posted_intr(vcpu, vmcs12);
>
> These "if"s are always true.
>

Why? L1 may config these features seperately, we should check them one by one.
e.g.  L1 may enable posted interrupt processing and virtual interrupt
delivery, but leaving virtualize x2apic mode disabled, then
nested_cpu_has_virt_x2apic_mode will return false.

> Paolo
