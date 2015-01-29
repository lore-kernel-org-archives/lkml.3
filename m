Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764074AbbA2DUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:20:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:4606 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758044AbbA2DUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 22:20:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="446800401"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Wincy Van <fanwenyi0529@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "gleb@kernel.org" <gleb@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: RE: [PATCH v4 0/6] KVM: nVMX: Enable nested apicv support
Thread-Topic: [PATCH v4 0/6] KVM: nVMX: Enable nested apicv support
Thread-Index: AQHQOxIMzMkpv7gJnk2nIDlgVR2W05zWabqQ
Date: Thu, 29 Jan 2015 03:17:32 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AC2E2F6@SHSMSX104.ccr.corp.intel.com>
References: <CACzj_yWYwnt5duHJjPSDUY=iP-6Xke7jTkJVPVdpaBGzJWFh+Q@mail.gmail.com>
In-Reply-To: <CACzj_yWYwnt5duHJjPSDUY=iP-6Xke7jTkJVPVdpaBGzJWFh+Q@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0T3KMc7010996

Wincy Van wrote on 2015-01-28:
> v1 ---> v2:
>   Use spin lock to ensure vmcs12 is safe when doing nested
>   posted interrupt delivery.
> v2 ---> v3:
>   1. Add a new field in nested_vmx to avoid the spin lock in v2.
>   2. Drop send eoi to L1 when doing nested interrupt delivery.
>   3. Use hardware MSR bitmap to enable nested virtualize x2apic
>      mode.
> v3 ---> v4:
>   1. Optimize nested msr bitmap merging.
>   2. Allocate nested msr bitmap only when nested == 1.
>   3. Inline the nested vmx control checking functions.

This version looks good to me. Only minor comment: EXIT_REASON_APIC_WRITE vmexit is introduced by apic register virtualization not virtual interrupt delivery, so it's better add it in 4th patch not 5th patch.(If no other comments, I guess Paolo can help do it when applying it).

Reviewed-by: Yang Zhang <yang.z.zhang@intel.com>


> Wincy Van (6):
>   KVM: nVMX: Use hardware MSR bitmap
>   KVM: nVMX: Enable nested virtualize x2apic mode
>   KVM: nVMX: Make nested control MSRs per-cpu
>   KVM: nVMX: Enable nested apic register virtualization
>   KVM: nVMX: Enable nested virtual interrupt delivery
>   KVM: nVMX: Enable nested posted interrupt processing
>  arch/x86/kvm/vmx.c |  580
>  +++++++++++++++++++++++++++++++++++++++++++--------- 1 files changed,
>  480 insertions(+), 100 deletions(-)


Best regards,
Yang


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
