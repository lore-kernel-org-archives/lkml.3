Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbbAMA2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 19:28:09 -0500
Received: from mga03.intel.com ([134.134.136.65]:6226 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbbAMA2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 19:28:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="439688123"
From: "Wu, Feng" <feng.wu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3I/bcOhPw==?= <rkrcmar@redhat.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@kernel.org" <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
 VT-d PI
Thread-Topic: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu()
 for VT-d PI
Thread-Index: AQHQLByH8l5BL+hKS0G68sCIWO48rJy9NquQ
Date: Tue, 13 Jan 2015 00:27:59 +0000
Message-ID: <E959C4978C3B6342920538CF579893F002341102@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
 <1418397300-10870-14-git-send-email-feng.wu@intel.com>
 <20150109145435.GA22469@potion.brq.redhat.com> <54AFEC00.80507@redhat.com>
In-Reply-To: <54AFEC00.80507@redhat.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0D0SDgK024525



> -----Original Message-----
> From: Paolo Bonzini [mailto:pbonzini@redhat.com]
> Sent: Friday, January 09, 2015 10:56 PM
> To: Radim KrÄmÃ¡Å™; Wu, Feng
> Cc: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com; x86@kernel.org;
> gleb@kernel.org; dwmw2@infradead.org; joro@8bytes.org;
> alex.williamson@redhat.com; jiang.liu@linux.intel.com; eric.auger@linaro.org;
> linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org;
> kvm@vger.kernel.org
> Subject: Re: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
> VT-d PI
> 
> 
> 
> On 09/01/2015 15:54, Radim KrÄmÃ¡Å™ wrote:
> > There are two points relevant to this patch in new KVM's implementation,
> > ("KVM: x86: amend APIC lowest priority arbitration",
> >  https://lkml.org/lkml/2015/1/9/362)
> >
> > 1) lowest priority depends on TPR
> > 2) there is no need for balancing
> >
> > (1) has to be considered with PI as well.
> 
> The chipset doesn't support it. :(
> 
> > I kept (2) to avoid whining from people building on that behaviour, but
> > lowest priority backed by PI could be transparent without it.
> >
> > Patch below removes the balancing, but I am not sure this is a price we
> > allowed ourselves to pay ... what are your opinions?
> 
> I wouldn't mind, but it requires a lot of benchmarking.

In fact, the real hardware may do lowest priority in round robin way, the new
hardware even doesn't consider the TPR for lowest priority interrupts delivery.

As discussed with Paolo before, I will submit a patch to support lowest priority for PI
after this series is merged.

Thanks,
Feng

> 
> Paolo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
