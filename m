Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaKMBV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 20:21:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:35183 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbaKMBVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 20:21:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="415746520"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: "Wu, Feng" <feng.wu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
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
Thread-Index: Ac/9kLfHSOSyagtOQAqEsc5J81STLgAyIb0DAAAcBYD//4ReAP/+e7+A//z07vA=
Date: Thu, 13 Nov 2014 01:21:16 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0ABE5A68@SHSMSX104.ccr.corp.intel.com>
References: <E959C4978C3B6342920538CF579893F00226EF05@SHSMSX104.ccr.corp.intel.com>
 <5461EC99.1000101@redhat.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0ABDBB25@SHSMSX104.ccr.corp.intel.com>
 <546324F4.8010002@redhat.com>
 <E959C4978C3B6342920538CF579893F00227680F@SHSMSX104.ccr.corp.intel.com>
 <54632ECA.4070903@redhat.com>
 <E959C4978C3B6342920538CF579893F002284398@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <E959C4978C3B6342920538CF579893F002284398@SHSMSX104.ccr.corp.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAD1M1Nk020683

Wu, Feng wrote on 2014-11-13:
> 
> 
> kvm-owner@vger.kernel.org wrote on 2014-11-12:
>> kvm@vger.kernel.org; iommu@lists.linux-foundation.org; 
>> linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH 05/13] KVM: Update IRTE according to guest 
>> interrupt configuration changes
>> 
>> 
>> 
>> On 12/11/2014 10:19, Wu, Feng wrote:
>>>> You can certainly backport these patches to distros that do not 
>>>> have VFIO.  But upstream we should work on VFIO first.  VFIO has 
>>>> feature parity with legacy device assignment, and adding a new 
>>>> feature that is not in VFIO would be a bad idea.
>>>> 
>>>> By the way, do you have benchmark results for it?  We have not been 
>>>> able to see any performance improvement for APICv on e.g. netperf.
>>> 
>>> Do you mean benchmark results for APICv itself or VT-d Posted-Interrtups?
>> 
>> Especially for VT-d posted interrupts---but it'd be great to know 
>> which workloads see the biggest speedup from APICv.
> 
> We have some draft performance data internally, please see the 
> attached. For VT-d PI, I think we can get the biggest performance gain 
> if the VCPU is running in non-root mode for most of the time (not in 
> HLT state), since external interrupt from assigned devices will be delivered by guest directly in this case.
> That means we can run some cpu intensive workload in the guests.

Have you check that the CPU side posted interrupt is taking effect in w/o VT-D PI case? Per my understanding, the performance gap should be so large if you use CPU side posted interrupt. This data more like the VT-d PI vs non PI(both VT-d and CPU).

> 
> Thanks,
> Feng
> 
>> 
>> Paolo
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in the 
>> body of a message to majordomo@vger.kernel.org More majordomo info at 
>> http://vger.kernel.org/majordomo-info.html


Best regards,
Yang


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
