Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaLSL7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 06:59:44 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44882 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaLSL7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 06:59:41 -0500
Message-ID: <54941326.4080405@redhat.com>
Date: Fri, 19 Dec 2014 12:59:34 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Yang Zhang <yang.z.zhang@intel.com>, "Wu, Feng" <feng.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>
Subject: Re: [v3 06/26] iommu, x86: No need to migrating irq for VT-d Posted-Interrupts
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>	<1418397300-10870-7-git-send-email-feng.wu@intel.com>	<A9667DDFB95DB7438FA9D7D576C3D87E0AC0486D@SHSMSX104.ccr.corp.intel.com>	<E959C4978C3B6342920538CF579893F00230A649@SHSMSX104.ccr.corp.intel.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AC04E77@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AC04E77@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19/12/2014 02:46, Zhang, Yang Z wrote:
>> If the IRQ is posted, its affinity is controlled by guest (irq <--->
>> vCPU <----> pCPU), it has no effect when host changes its affinity.
> 
> That's the problem: User is able to changes it in host but it never
> takes effect since it is actually controlled by guest. I guess it
> will break the IRQ balance too.

I don't think that's a problem.

Controlling the affinity in the host affects which CPU in the host takes
care of signaling the guest.

If this signaling is done directly by the chipset, there is no need to
do anything in the host and thus the host affinity can be bypassed.

Paolo
