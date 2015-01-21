Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbbAUIyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:54:54 -0500
Received: from mga03.intel.com ([134.134.136.65]:3671 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbbAUIyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:54:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,440,1418112000"; 
   d="scan'208";a="665107840"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Wincy Van <fanwenyi0529@gmail.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        "Jan Kiszka" <jan.kiszka@web.de>
Subject: RE: [PATCH v2 5/5] KVM: nVMX: Enable nested posted interrupt
 processing.
Thread-Topic: [PATCH v2 5/5] KVM: nVMX: Enable nested posted interrupt
 processing.
Thread-Index: AQHQNI4FmE9Ga9yggEGFMQiaMgUqM5zKLXcQ//+QIYCAAIdJcA==
Date: Wed, 21 Jan 2015 08:49:08 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AC26363@SHSMSX104.ccr.corp.intel.com>
References: <CACzj_yWxK9d_47a9ZHqtk2HSJBN6+LvtDScQqWd5znfSt8ia0Q@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2629C@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yWDkuNxu=-Fqy3aPJJ_sveeCtmjKJRAvEjsNb+-7kdjAQ@mail.gmail.com>
In-Reply-To: <CACzj_yWDkuNxu=-Fqy3aPJJ_sveeCtmjKJRAvEjsNb+-7kdjAQ@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0L8t0Lu018337

Wincy Van wrote on 2015-01-21:
> On Wed, Jan 21, 2015 at 4:07 PM, Zhang, Yang Z <yang.z.zhang@intel.com>
> wrote:
>>> +       if (vector == vmcs12->posted_intr_nv && +          
>>> nested_cpu_has_posted_intr(vmcs12)) { +               if (vcpu->mode
>>> == IN_GUEST_MODE) + apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), +    
>>>                           POSTED_INTR_VECTOR); +               else {
>>> +                       r = -1; +                       goto out; +   
>>>            } + +               /* +                * if posted intr is
>>> done by hardware, the +                * corresponding eoi was sent to
>>> L0. Thus +                * we should send eoi to L1 manually. +      
>>>          */ +               kvm_apic_set_eoi_accelerated(vcpu, +      
>>>                 vmcs12->posted_intr_nv);
>> 
>> Why this is necessary? As your comments mentioned, it is done by
>> hardware not L1, why L1 should aware of it?
>> 
> 
> According to SDM 29.6, if the processor recognizes a posted interrupt,
> it will send an EOI to LAPIC.
> If the posted intr is done by hardware, the processor will send eoi to
> hardware LAPIC, not L1's, just like the none-nested case(the physical
> interrupt is dismissed). So we should take care of the L1's LAPIC and send an eoi to it.

No. You are not emulating the PI feature. You just reuse the hardware's capability. So you don't need to let L1 know it.

> 
> 
> Thanks,
> 
> Wincy


Best regards,
Yang


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
