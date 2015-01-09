Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbbAIPSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:18:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbbAIPSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:18:50 -0500
Message-ID: <54AFF128.1080603@redhat.com>
Date: Fri, 09 Jan 2015 16:18:00 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: Feng Wu <feng.wu@intel.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, gleb@kernel.org, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com,
        eric.auger@linaro.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
 VT-d PI
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com> <1418397300-10870-14-git-send-email-feng.wu@intel.com> <20150109145435.GA22469@potion.brq.redhat.com> <54AFEC00.80507@redhat.com> <20150109151258.GC9877@potion.brq.redhat.com>
In-Reply-To: <20150109151258.GC9877@potion.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/01/2015 16:12, Radim Krčmář wrote:
> > The chipset doesn't support it. :(
> 
> I meant that we need to recompute PI entries for lowest priority
> interrupts every time guest's TPR changes.
> 
> Luckily, Linux doesn't use TPR, but other OS might be a reason to drop
> lowest priority from PI optimizations.  (Or make it more complicated.)

Doing vector hashing is a possibility as well.  I would like to know
what existing chipsets do in practice, then we can mimic it.

Paolo
