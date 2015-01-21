Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbbAUJYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:24:09 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:36707 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbbAUJYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:24:06 -0500
MIME-Version: 1.0
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AC262EB@SHSMSX104.ccr.corp.intel.com>
References: <CACzj_yVKUUvbke3XG7cHCQD7hr8fPsRbH1k_3V8L25M3-Y6sNQ@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC262EB@SHSMSX104.ccr.corp.intel.com>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Wed, 21 Jan 2015 17:23:44 +0800
Message-ID: <CACzj_yW056JWb_+SbdQpfRfqJEUoWk4bRmGjnDOm18UgEzHwYA@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: nVMX: Make nested control MSRs per-cpu.
To: "Zhang, Yang Z" <yang.z.zhang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 4:18 PM, Zhang, Yang Z <yang.z.zhang@intel.com> wrote:
> Wincy Van wrote on 2015-01-16:
>> To enable nested apicv support, we need per-cpu vmx control MSRs:
>>   1. If in-kernel irqchip is enabled, we can enable nested
>>      posted interrupt, we should set posted intr bit in the
>>      nested_vmx_pinbased_ctls_high. 2. If in-kernel irqchip is disabled,
>>      we can not enable nested posted interrupt, the posted intr bit in
>>      the nested_vmx_pinbased_ctls_high will be cleared.
>> Since there would be different settings about in-kernel irqchip
>> between VMs, different nested control MSRs are needed.
>
> I'd suggest you to check irqchip_in_kernel() instead moving the whole ctrl msr to per vcpu.
>

Yes, moving that msrs looks a bit ugly, but the irqchip_in_kernel is
per-VM, not a global
setting, there would be different settings of kernel_irqchip between VMs.
If we use irqchip_in_kernel to check it and set different value of the
ctl msrs, I think it may
be even worse than moving the msrs, because this logic should be a
init function, and this
setting should be converged.

Thanks,

Wincy
