Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbbA1UdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:33:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:1757 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760159AbbA1UdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:33:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,479,1418112000"; 
   d="scan'208";a="677203498"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Wincy Van <fanwenyi0529@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "gleb@kernel.org" <gleb@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: RE: [PATCH v3 1/6] KVM: nVMX: Use hardware MSR bitmap
Thread-Topic: [PATCH v3 1/6] KVM: nVMX: Use hardware MSR bitmap
Thread-Index: AQHQN79lT9Shw/DNlk+phY4fCFwl65zVMZZggAABYeA=
Date: Wed, 28 Jan 2015 08:06:19 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C56F@SHSMSX104.ccr.corp.intel.com>
References: <CACzj_yUu5omqFL7u8NE6vyqXGy_-dAeukRspJha+EiGXVBzmYg@mail.gmail.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0SKXWIg006146

Zhang, Yang Z wrote on 2015-01-28:
> Wincy Van wrote on 2015-01-24:
>> When L2 is using x2apic, we can use virtualize x2apic mode to gain
>> higher performance, especially in apicv case.
>> 
>> This patch also introduces nested_vmx_check_apicv_controls for the
>> nested apicv patches.

Sorry, replied on the wrong thread.:(

>> 
>> Signed-off-by: Wincy Van <fanwenyi0529@gmail.com>
>> ---
> 
> ...snip...
> 
>>  static void vmx_disable_intercept_for_msr(u32 msr, bool
>> longmode_only)
> {
>>         if (!longmode_only)
>> @@ -8344,7 +8394,68 @@ static int
>> nested_vmx_check_msr_bitmap_controls(struct kvm_vcpu *vcpu,  static
>> inline bool nested_vmx_merge_msr_bitmap(struct kvm_vcpu *vcpu,
>>                                                struct vmcs12
>> *vmcs12)  {
>> -       return false;
>> +       struct page *page;
>> +       unsigned long *msr_bitmap;
>> +
>> +       if (!nested_cpu_has_virt_x2apic_mode(vmcs12))
>> +               return false;
>> +
>> +       page = nested_get_page(vcpu, vmcs12->msr_bitmap);
>> +       if (!page) {
>> +               WARN_ON(1);
>> +               return false;
>> +       }
>> +       msr_bitmap = (unsigned long *)kmap(page);
>> +       if (!msr_bitmap) {
>> +               nested_release_page_clean(page);
>> +               WARN_ON(1);
>> +               return false;
>> +       }
>> +
>> +       memset(vmx_msr_bitmap_nested, 0xff, PAGE_SIZE);
>> +
>> +       if (nested_cpu_has_virt_x2apic_mode(vmcs12))
>> +               /* TPR is allowed */
>> +               nested_vmx_disable_intercept_for_msr(msr_bitmap,
>> +                               vmx_msr_bitmap_nested,
>> +                               APIC_BASE_MSR + (APIC_TASKPRI >>
>> 4),
>> +                               MSR_TYPE_R | MSR_TYPE_W);
> 
> I didn't understand what this function does? Per my understanding, you
> only need to set the (vmx_msr_bitmap_nested = vmcs01->msr_bitmap |
> vmcs12->msr_bitmap) and inject the nested vmexit to L1 if the bit in
> vmcs12->msr_bitmap is setting. Am I missing some patches?
> 
> Best regards,
> Yang
>


Best regards,
Yang


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
