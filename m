Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbbAUITJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:19:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:50311 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbbAUITG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:19:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="443080050"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Wincy Van <fanwenyi0529@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "gleb@kernel.org" <gleb@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: RE: [PATCH 1/5] KVM: nVMX: Make nested control MSRs per-cpu.
Thread-Topic: [PATCH 1/5] KVM: nVMX: Make nested control MSRs per-cpu.
Thread-Index: AQHQMVBrZc6TnJUyfk+80Qu1n+PyapzKQVSg
Date: Wed, 21 Jan 2015 08:18:57 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AC262EB@SHSMSX104.ccr.corp.intel.com>
References: <CACzj_yVKUUvbke3XG7cHCQD7hr8fPsRbH1k_3V8L25M3-Y6sNQ@mail.gmail.com>
In-Reply-To: <CACzj_yVKUUvbke3XG7cHCQD7hr8fPsRbH1k_3V8L25M3-Y6sNQ@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0L8JDoC018192

Wincy Van wrote on 2015-01-16:
> To enable nested apicv support, we need per-cpu vmx control MSRs:
>   1. If in-kernel irqchip is enabled, we can enable nested
>      posted interrupt, we should set posted intr bit in the
>      nested_vmx_pinbased_ctls_high. 2. If in-kernel irqchip is disabled,
>      we can not enable nested posted interrupt, the posted intr bit in
>      the nested_vmx_pinbased_ctls_high will be cleared.
> Since there would be different settings about in-kernel irqchip
> between VMs, different nested control MSRs are needed.

I'd suggest you to check irqchip_in_kernel() instead moving the whole ctrl msr to per vcpu.

Best regards,
Yang


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
