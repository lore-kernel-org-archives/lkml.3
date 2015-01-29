Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbbA2FcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 00:32:10 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:46831 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbbA2FcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 00:32:08 -0500
MIME-Version: 1.0
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AC2E2F6@SHSMSX104.ccr.corp.intel.com>
References: <CACzj_yWYwnt5duHJjPSDUY=iP-6Xke7jTkJVPVdpaBGzJWFh+Q@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2E2F6@SHSMSX104.ccr.corp.intel.com>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Thu, 29 Jan 2015 13:31:45 +0800
Message-ID: <CACzj_yXGqUy4rJCTe8XVWYfSvdvD+t_1dptNrEoYJKd=0=MBZA@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] KVM: nVMX: Enable nested apicv support
To: "Zhang, Yang Z" <yang.z.zhang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 11:17 AM, Zhang, Yang Z <yang.z.zhang@intel.com> wrote:
> Wincy Van wrote on 2015-01-28:
>> v1 ---> v2:
>>   Use spin lock to ensure vmcs12 is safe when doing nested
>>   posted interrupt delivery.
>> v2 ---> v3:
>>   1. Add a new field in nested_vmx to avoid the spin lock in v2.
>>   2. Drop send eoi to L1 when doing nested interrupt delivery.
>>   3. Use hardware MSR bitmap to enable nested virtualize x2apic
>>      mode.
>> v3 ---> v4:
>>   1. Optimize nested msr bitmap merging.
>>   2. Allocate nested msr bitmap only when nested == 1.
>>   3. Inline the nested vmx control checking functions.
>
> This version looks good to me. Only minor comment: EXIT_REASON_APIC_WRITE vmexit is introduced by apic register virtualization not virtual interrupt delivery, so it's better add it in 4th patch not 5th patch.(If no other comments, I guess Paolo can help do it when applying it).
>
> Reviewed-by: Yang Zhang <yang.z.zhang@intel.com>
>

Yes, thank you for pointing out it  ; )
Paolo, what's your opinion?


Thanks,
Wincy
