Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbbAIO4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:56:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbbAIO4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:56:47 -0500
Message-ID: <54AFEC00.80507@redhat.com>
Date: Fri, 09 Jan 2015 15:56:00 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Feng Wu <feng.wu@intel.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, dwmw2@infradead.org, joro@8bytes.org,
        alex.williamson@redhat.com, jiang.liu@linux.intel.com,
        eric.auger@linaro.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
 VT-d PI
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com> <1418397300-10870-14-git-send-email-feng.wu@intel.com> <20150109145435.GA22469@potion.brq.redhat.com>
In-Reply-To: <20150109145435.GA22469@potion.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/01/2015 15:54, Radim Krčmář wrote:
> There are two points relevant to this patch in new KVM's implementation,
> ("KVM: x86: amend APIC lowest priority arbitration",
>  https://lkml.org/lkml/2015/1/9/362)
> 
> 1) lowest priority depends on TPR
> 2) there is no need for balancing
> 
> (1) has to be considered with PI as well.

The chipset doesn't support it. :(

> I kept (2) to avoid whining from people building on that behaviour, but
> lowest priority backed by PI could be transparent without it.
> 
> Patch below removes the balancing, but I am not sure this is a price we
> allowed ourselves to pay ... what are your opinions?

I wouldn't mind, but it requires a lot of benchmarking.

Paolo
