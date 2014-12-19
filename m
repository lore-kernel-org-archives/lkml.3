Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaLSBsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:48:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:53880 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaLSBsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:48:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,604,1413270000"; 
   d="scan'208";a="656798588"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: "Wu, Feng" <feng.wu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@kernel.org" <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>,
        "Sankaran, Rajesh" <rajesh.sankaran@intel.com>
CC: "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
 VT-d PI
Thread-Topic: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu()
 for VT-d PI
Thread-Index: AQHQFiCrJgBr1evklkuo8VNfnV0dX5yWHx3ggAAMspA=
Date: Fri, 19 Dec 2014 01:47:54 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AC04E94@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
 <1418397300-10870-14-git-send-email-feng.wu@intel.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC048A2@SHSMSX104.ccr.corp.intel.com>
 <549307A5.3060305@redhat.com>
 <E959C4978C3B6342920538CF579893F00230A5F8@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <E959C4978C3B6342920538CF579893F00230A5F8@SHSMSX104.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu, Feng wrote on 2014-12-19:
> 
> 
> Paolo Bonzini wrote on 2014-12-19:
>> jiang.liu@linux.intel.com
>> Cc: eric.auger@linaro.org; linux-kernel@vger.kernel.org;
>> iommu@lists.linux-foundation.org; kvm@vger.kernel.org
>> Subject: Re: [v3 13/26] KVM: Define a new interface
>> kvm_find_dest_vcpu() for VT-d PI
>> 
>> 
>> 
>> On 18/12/2014 15:49, Zhang, Yang Z wrote:
>>>>> Here, we introduce a similar way with 'apic_arb_prio' to handle
>>>>> guest lowest priority interrtups when VT-d PI is used. Here is
>>>>> the
>>>>> ideas: - Each vCPU has a counter 'round_robin_counter'. - When
>>>>> guests sets an interrupts to lowest priority, we choose the vCPU
>>>>> with smallest 'round_robin_counter' as the destination, then
>>>>> increase it.
>>> 
>>> How this can work well? All subsequent interrupts are delivered to
>>> one vCPU? It shouldn't be the best solution, need more consideration.
>> 
>> Well, it's a hardware limitation.  The alternative (which is easy to
>> implement) is to only do PI for single-CPU interrupts.  This should
>> work well for multiqueue NICs (and of course for UP guests :)), so
>> perhaps it's a good idea to only support that as a first attempt.
>> 
>> Paolo
> 
> Paolo, what do you mean by "single-CPU interrupts"? Do you mean we

It should be same idea as I mentioned on another thread: deliver the interrupt to a single CPU(maybe the first matched VCPU?)

> don't support lowest priority interrupts for PI? But Linux OS uses
> lowest priority for most of the case? If so, we can hardly get benefit
> from this feature for Linux guest OS.
> 
> Thanks,
> Feng
> 
>> 
>>> Also, I think you should take the apic_arb_prio into consider
>>> since the priority is for the whole vCPU not for one interrupt.


Best regards,
Yang


