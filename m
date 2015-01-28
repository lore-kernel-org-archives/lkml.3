Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbbA1VjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:39:04 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:60860 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934025AbbA1UmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:42:14 -0500
MIME-Version: 1.0
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C9D6@SHSMSX104.ccr.corp.intel.com>
References: <CACzj_yUu5omqFL7u8NE6vyqXGy_-dAeukRspJha+EiGXVBzmYg@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C563@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yVqDYyz5VwCX5d=Po2X_DdsHbqLmON8N=1PVLLocoHNpw@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C800@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yWZzhgjqBPNkxy39v6-uXnRpKb0Eo-YjEQwfSYL+tT-bQ@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C865@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yV+eQP1bZZ07MvECMrQ52DgkcrfsJTFDQ=uPz4j7LkEHg@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C932@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yXCPWFxFxPq45OQEwS_ASE6TQK8XwXEFOcSzQS8r90jaA@mail.gmail.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C9D6@SHSMSX104.ccr.corp.intel.com>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Wed, 28 Jan 2015 21:57:17 +0800
Message-ID: <CACzj_yV7fPAv4RxcnyVy3gNBiULsvS+aNzmBrVxbDR=Aqnr2Cg@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] KVM: nVMX: Use hardware MSR bitmap
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

On Wed, Jan 28, 2015 at 9:06 PM, Zhang, Yang Z <yang.z.zhang@intel.com> wrote:
>>>>         __clear_bit(msr, msr_bitmap_nested + 0x000 / f);
>>>
>>>
>>> Anyway, this is not necessary for your current patch. We can consider
>>> it later if there really have other features will use it.
>>>
>>
>> Yep, I know what you mean now, for other msrs which are not forwarded
>> access by a mechanism like virtual-apic page, we should intercept it
>> unconditionally. I think we should ensure the msr can be allowed
>> before call nested_vmx_disable_intercept_for_msr, if L0 want to
>> intercept it, just do not call nested_vmx_disable_intercept_for_msr.
>
> Yes, this is a solution. But I prefer to handle it in nested code path since others may not familiar with nested and may block it by mistake.
>
>>
>>  !test_bit(msr, vmcs01_msr_bitmap) will introduce a problem that some
>> of the msrs will be affcted by vmcs01_msr_bitmap, TMCCT and TPR, for example.
>> Intercept reading for these msrs is okay, but it is not efficient.
>
> TMCCT is always trapped by most VMM. I don't think TPR is trapped in KVM.
>

Oooops. This piece of code made me confused and I was not think about
that words, just forget it.
( * ^ _ ^ * )


                vmx_enable_intercept_msr_read_x2apic(0x802);
                /* TMCCT */
                vmx_enable_intercept_msr_read_x2apic(0x839);
                /* TPR */


If there are any features use it in the future, let's consider about
this, thank you for your patience.


Thanks,
Wincy
