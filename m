Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaLRQ7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:59:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaLRQ67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:58:59 -0500
Message-ID: <549307A5.3060305@redhat.com>
Date: Thu, 18 Dec 2014 17:58:13 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Zhang, Yang Z" <yang.z.zhang@intel.com>, "Wu, Feng" <feng.wu@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@kernel.org" <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>
CC: "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
 VT-d PI
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com> <1418397300-10870-14-git-send-email-feng.wu@intel.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AC048A2@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AC048A2@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 18/12/2014 15:49, Zhang, Yang Z wrote:
>>> Here, we introduce a similar way with 'apic_arb_prio' to handle
>>> guest lowest priority interrtups when VT-d PI is used. Here is
>>> the ideas: - Each vCPU has a counter 'round_robin_counter'. -
>>> When guests sets an interrupts to lowest priority, we choose the
>>> vCPU with smallest 'round_robin_counter' as the destination, then
>>> increase it.
> 
> How this can work well? All subsequent interrupts are delivered to
> one vCPU? It shouldn't be the best solution, need more consideration.

Well, it's a hardware limitation.  The alternative (which is easy to
implement) is to only do PI for single-CPU interrupts.  This should work
well for multiqueue NICs (and of course for UP guests :)), so perhaps
it's a good idea to only support that as a first attempt.

Paolo

> Also, I think you should take the apic_arb_prio into consider since
> the priority is for the whole vCPU not for one interrupt.
