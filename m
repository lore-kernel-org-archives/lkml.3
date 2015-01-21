Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbbAUVRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:17:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbbAUVRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:17:03 -0500
Date: Wed, 21 Jan 2015 22:16:23 +0100
From: Radim =?utf-8?B?S3I/bcOhPw==?= <rkrcmar@redhat.com>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: "Wu, Feng" <feng.wu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "gleb@kernel.org" <gleb@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>
Subject: Re: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
 VT-d PI
Message-ID: <20150121211620.GA27504@potion.brq.redhat.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
 <1418397300-10870-14-git-send-email-feng.wu@intel.com>
 <20150109145435.GA22469@potion.brq.redhat.com>
 <54AFEC00.80507@redhat.com>
 <E959C4978C3B6342920538CF579893F002341102@SHSMSX104.ccr.corp.intel.com>
 <20150113161716.GA12941@potion.brq.redhat.com>
 <E959C4978C3B6342920538CF579893F00234E4CD@SHSMSX104.ccr.corp.intel.com>
 <20150114165909.GA1283@potion.brq.redhat.com>
 <6A3B67DA-EDAA-4DE5-BE59-96B693D7BB86@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6A3B67DA-EDAA-4DE5-BE59-96B693D7BB86@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-20 23:04+0200, Nadav Amit:
> Radim Kr?má? <rkrcmar@redhat.com> wrote:
> > 2015-01-14 01:27+0000, Wu, Feng:
> >>> the new
> >>>> hardware even doesn't consider the TPR for lowest priority interrupts
> >>> delivery.
> >>> 
> >>> A bold move ... what hardware was the first to do so?
> >> 
> >> I think it was starting with Nehalem.
> > 
> > Thanks,  (Could be that QPI can't inform about TPR changes anymore ...)
> > 
> > I played with Linux's TPR on Haswell and found that is has no effect.
> 
> Sorry for jumping into the discussion, but doesn’t it depend on
> IA32_MISC_ENABLE[23]? This bit disables xTPR messages. On my machine it is
> set (probably by the BIOS), but since there is no IA32_MISC_ENABLE is not
> locked for changes, the OS can control it.

Thanks, I didn't know about it.
On Ivy Bridge EP (the only modern machine at hand), the bit was set by
default.  After clearing it, TPR still had no effect.

The most relevant mention of xTPR I found is related to FSB [1].
[2] isn't enlightening, so there might be more from QPI-era ...


---
1: Intel® E7320 Memory Controller Hub (MCH) Datasheet
   http://www.intel.com/content/dam/doc/datasheet/e7320-memory-controller-hub-datasheet.pdf
   5.2.2 System Bus Interrupts
2: Intel® Xeon® Processor E5 v2 Family: Datasheet, Vol. 2
   http://www.intel.com/content/dam/www/public/us/en/documents/datasheets/xeon-e5-v2-datasheet-vol-2.pdf
   6.1.2 IntControl
