Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaLSDc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 22:32:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:49667 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaLSDc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 22:32:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="501327080"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: "Wu, Feng" <feng.wu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [v3 25/26] KVM: Suppress posted-interrupt when 'SN' is set
Thread-Topic: [v3 25/26] KVM: Suppress posted-interrupt when 'SN' is set
Thread-Index: AQHQGqESVjGwCGGcx0GfXydnqyBdC5yVc2HggADGJ7CAAAKSQA==
Date: Fri, 19 Dec 2014 03:32:51 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AC04FED@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
	<1418397300-10870-26-git-send-email-feng.wu@intel.com>
	<5491C0A2.7040503@redhat.com>
	<E959C4978C3B6342920538CF579893F002307C4A@SHSMSX104.ccr.corp.intel.com>
	<5492926E.8070207@redhat.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC04938@SHSMSX104.ccr.corp.intel.com>
 <E959C4978C3B6342920538CF579893F00230ABEB@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <E959C4978C3B6342920538CF579893F00230ABEB@SHSMSX104.ccr.corp.intel.com>
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
> iommu-bounces@lists.linux-foundation.org wrote on mailto:iommu-bounces@lists.linux-foundation.org] On Behalf Of:
>> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
>> kvm@vger.kernel.org
>> Subject: RE: [v3 25/26] KVM: Suppress posted-interrupt when 'SN' is
>> set
>> 
>> Paolo Bonzini wrote on 2014-12-18:
>>> 
>>> 
>>> On 18/12/2014 04:14, Wu, Feng wrote:
>>>> 
>>>> 
>>>> linux-kernel-owner@vger.kernel.org wrote on
>> mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Paolo:
>>>>> x86@kernel.org; Gleb Natapov; Paolo Bonzini;
>>>>> dwmw2@infradead.org;
>>>>> joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org; Alex Williamson;
>>>>> joro-zLv9SwRftAIdnm+Jiang
>>>>> Liu
>>>>> Cc: iommu@lists.linux-foundation.org;
>>>>> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; KVM list;
>>>>> Eric Auger
>>>>> Subject: Re: [v3 25/26] KVM: Suppress posted-interrupt when 'SN'
>>>>> is set
>>>>> 
>>>>> 
>>>>> 
>>>>> On 12/12/2014 16:14, Feng Wu wrote:
>>>>>> Currently, we don't support urgent interrupt, all interrupts
>>>>>> are recognized as non-urgent interrupt, so we cannot send
>>>>>> posted-interrupt when 'SN' is set.
>>>>> 
>>>>> Can this happen?  If the vcpu is in guest mode, it cannot have
>>>>> been scheduled out, and that's the only case when SN is set.
>>>>> 
>>>>> Paolo
>>>> 
>>>> Currently, the only place where SN is set is vCPU is preempted
>>>> and
>> 
>> If the vCPU is preempted, shouldn't the subsequent be ignored? What
>> happens if a PI is occurs when vCPU is preempted?
> 
> If a vCPU is preempted, the 'SN' bit is set, the subsequent interrupts
> are suppressed for posting.

I mean what happens if we don't set SN bit. From my point, if preempter already disabled the interrupt, it is ok to leave SN bit as zero. But if preempter enabled the interrupt, doesn't this mean he allow interrupt to happen? BTW, since there already has ON bit, so this means there only have one interrupt arrived at most and it doesn't hurt performance. Do we really need to set SN bit?

> 
> Thanks,
> Feng
> 
>> 
>>>> waiting for the next scheduling in the runqueue. But I am not
>>>> sure whether we need to set SN for other purpose in future.
>>>> Adding SN checking here is just to follow the Spec. non-urgent
>>>> interrupts are suppressed
>>> when SN is set.
>>> 
>>> I would change that to a WARN_ON_ONCE then.
>> 
>> 
>> Best regards,
>> Yang
>> 
>> 
>> _______________________________________________
>> iommu mailing list
>> iommu@lists.linux-foundation.org
>> https://lists.linuxfoundation.org/mailman/listinfo/iommu


Best regards,
Yang


