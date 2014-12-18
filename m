Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaLRPKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 10:10:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:29033 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbaLRPKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 10:10:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,601,1413270000"; 
   d="scan'208";a="639750919"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [v3 25/26] KVM: Suppress posted-interrupt when 'SN' is set
Thread-Topic: [v3 25/26] KVM: Suppress posted-interrupt when 'SN' is set
Thread-Index: AQHQGqESVjGwCGGcx0GfXydnqyBdC5yVc2Hg
Date: Thu, 18 Dec 2014 15:09:48 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AC04938@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
	<1418397300-10870-26-git-send-email-feng.wu@intel.com>
	<5491C0A2.7040503@redhat.com>
 <E959C4978C3B6342920538CF579893F002307C4A@SHSMSX104.ccr.corp.intel.com>
 <5492926E.8070207@redhat.com>
In-Reply-To: <5492926E.8070207@redhat.com>
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

Paolo Bonzini wrote on 2014-12-18:
> 
> 
> On 18/12/2014 04:14, Wu, Feng wrote:
>> 
>> 
>> linux-kernel-owner@vger.kernel.org wrote on mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Paolo:
>>> x86@kernel.org; Gleb Natapov; Paolo Bonzini; dwmw2@infradead.org;
>>> joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org; Alex Williamson;
>>> joro-zLv9SwRftAIdnm+Jiang
>>> Liu
>>> Cc: iommu@lists.linux-foundation.org;
>>> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; KVM list;
>>> Eric Auger
>>> Subject: Re: [v3 25/26] KVM: Suppress posted-interrupt when 'SN' is
>>> set
>>> 
>>> 
>>> 
>>> On 12/12/2014 16:14, Feng Wu wrote:
>>>> Currently, we don't support urgent interrupt, all interrupts are
>>>> recognized as non-urgent interrupt, so we cannot send
>>>> posted-interrupt when 'SN' is set.
>>> 
>>> Can this happen?  If the vcpu is in guest mode, it cannot have been
>>> scheduled out, and that's the only case when SN is set.
>>> 
>>> Paolo
>> 
>> Currently, the only place where SN is set is vCPU is preempted and

If the vCPU is preempted, shouldn't the subsequent be ignored? What happens if a PI is occurs when vCPU is preempted?

>> waiting for the next scheduling in the runqueue. But I am not sure
>> whether we need to set SN for other purpose in future. Adding SN
>> checking here is just to follow the Spec. non-urgent interrupts are
>> suppressed
> when SN is set.
> 
> I would change that to a WARN_ON_ONCE then.


Best regards,
Yang


