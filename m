Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934679AbaKLDmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:42:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:27000 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834AbaKLDm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 22:42:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,366,1413270000"; 
   d="scan'208";a="630525015"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, "Wu, Feng" <feng.wu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC: "gleb@kernel.org" <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 05/13] KVM: Update IRTE according to guest interrupt
 configuration changes
Thread-Topic: [PATCH 05/13] KVM: Update IRTE according to guest interrupt
 configuration changes
Thread-Index: Ac/9kLfHSOSyagtOQAqEsc5J81STLv//ljeA//5lqcA=
Date: Wed, 12 Nov 2014 03:42:02 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0ABDBB25@SHSMSX104.ccr.corp.intel.com>
References: <E959C4978C3B6342920538CF579893F00226EF05@SHSMSX104.ccr.corp.intel.com>
 <5461EC99.1000101@redhat.com>
In-Reply-To: <5461EC99.1000101@redhat.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAC3gq5l013655

Paolo Bonzini wrote on 2014-11-11:
> 
> 
> On 11/11/2014 10:20, Wu, Feng wrote:
>>> Since legacy KVM device assignment is effectively deprecated, have
>>> you considered how we might do this with VFIO?  Thanks,
>> 
>> I haven't thought about how to enable this in VFIO so far. I think I
>> can continue to implement that if needed after this patch set is finished.
> What do you think of this?
> 
> Hi Feng,
> 
> we are not applying new features to legacy KVM device assignment,
> since it is unsafe (it does not honor ACS).

Personally, I think this feature will be helpful to the legacy device assignment. Agree, vfio is the right solution for future feature enabling. But the old kvm without the good vfio supporting is still used largely today. The user really looking for this feature but they will not upgrade their kernel. It's easy for us to backport this feature to old kvm with the legacy device assignment, but it is impossible to backport the whole vfio. So I think you guys can take a consider to add this feature to both vfio and legacy device assignment.

> 
> I and Alex can help you with designing a way to interface VFIO with
> KVM posted interrupts.  Give us a few days to study these patches
> more, or feel free to request comments if you have ideas about it yourself.
> 
> Paolo


Best regards,
Yang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
