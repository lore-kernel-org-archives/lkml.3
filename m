Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030AbbA0Vzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:55:41 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:61428 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbbA0Vzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:55:40 -0500
Message-ID: <54C80955.4070305@redhat.com>
Date: Tue, 27 Jan 2015 22:55:33 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Wincy Van <fanwenyi0529@gmail.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH v3 6/6] KVM: nVMX: Enable nested posted interrupt processing.
References: <CACzj_yWZSJkfn0JAJr9w6hLWtMbr3PpHQVxH_GkwmY8g3x1x8w@mail.gmail.com>
In-Reply-To: <CACzj_yWZSJkfn0JAJr9w6hLWtMbr3PpHQVxH_GkwmY8g3x1x8w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/01/2015 11:24, Wincy Van wrote:
>         if (!nested_cpu_has_virt_x2apic_mode(vmcs12) &&
>             !nested_cpu_has_apic_reg_virt(vmcs12) &&
> -           !nested_cpu_has_vid(vmcs12))
> +           !nested_cpu_has_vid(vmcs12) &&
> +           !nested_cpu_has_posted_intr(vmcs12))
>                 return 0;
> 
>         if (nested_cpu_has_virt_x2apic_mode(vmcs12))
>                 r = nested_vmx_check_virt_x2apic(vcpu, vmcs12);
>         if (nested_cpu_has_vid(vmcs12))
>                 r |= nested_vmx_check_vid(vcpu, vmcs12);
> +       if (nested_cpu_has_posted_intr(vmcs12))
> +               r |= nested_vmx_check_posted_intr(vcpu, vmcs12);

These "if"s are always true.

Paolo
