Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbbATVEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:04:22 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55753 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbbATVET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:04:19 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for VT-d PI
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20150114165909.GA1283@potion.brq.redhat.com>
Date: Tue, 20 Jan 2015 23:04:14 +0200
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
Content-Transfer-Encoding: 8BIT
Message-Id: <6A3B67DA-EDAA-4DE5-BE59-96B693D7BB86@gmail.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com> <1418397300-10870-14-git-send-email-feng.wu@intel.com> <20150109145435.GA22469@potion.brq.redhat.com> <54AFEC00.80507@redhat.com> <E959C4978C3B6342920538CF579893F002341102@SHSMSX104.ccr.corp.intel.com> <20150113161716.GA12941@potion.brq.redhat.com> <E959C4978C3B6342920538CF579893F00234E4CD@SHSMSX104.ccr.corp.intel.com> <20150114165909.GA1283@potion.brq.redhat.com>
To: =?utf-8?Q?Radim_Kr=3Fm=C3=A1=3F?= <rkrcmar@redhat.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Radim Kr?má? <rkrcmar@redhat.com> wrote:

> 2015-01-14 01:27+0000, Wu, Feng:
>>> the new
>>>> hardware even doesn't consider the TPR for lowest priority interrupts
>>> delivery.
>>> 
>>> A bold move ... what hardware was the first to do so?
>> 
>> I think it was starting with Nehalem.
> 
> Thanks,  (Could be that QPI can't inform about TPR changes anymore ...)
> 
> I played with Linux's TPR on Haswell and found that is has no effect.

Sorry for jumping into the discussion, but doesn’t it depend on
IA32_MISC_ENABLE[23]? This bit disables xTPR messages. On my machine it is
set (probably by the BIOS), but since there is no IA32_MISC_ENABLE is not
locked for changes, the OS can control it.

Nadav