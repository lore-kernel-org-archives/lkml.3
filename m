Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaLSXtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 18:49:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:5047 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaLSXtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 18:49:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="431392508"
From: "Wu, Feng" <feng.wu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
 VT-d PI
Thread-Topic: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu()
 for VT-d PI
Thread-Index: AQHQG4NHB9IPTEr8TE6SOwjUA8VGXpyXlELg
Date: Fri, 19 Dec 2014 23:48:50 +0000
Message-ID: <E959C4978C3B6342920538CF579893F00230D036@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
	<1418397300-10870-14-git-send-email-feng.wu@intel.com>
	<A9667DDFB95DB7438FA9D7D576C3D87E0AC048A2@SHSMSX104.ccr.corp.intel.com>
	<549307A5.3060305@redhat.com>
 <E959C4978C3B6342920538CF579893F00230A5F8@SHSMSX104.ccr.corp.intel.com>
 <5494131E.9030505@redhat.com>
In-Reply-To: <5494131E.9030505@redhat.com>
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



> -----Original Message-----
> From: Paolo Bonzini [mailto:paolo.bonzini@gmail.com] On Behalf Of Paolo
> Bonzini
> Sent: Friday, December 19, 2014 7:59 PM
> To: Wu, Feng; Paolo Bonzini; Zhang, Yang Z; Thomas Gleixner; Ingo Molnar; H.
> Peter Anvin; x86@kernel.org; Gleb Natapov; dwmw2@infradead.org;
> joro@8bytes.org; Alex Williamson; Jiang Liu
> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org; KVM list;
> Eric Auger
> Subject: Re: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
> VT-d PI
> 
> 
> 
> On 19/12/2014 02:30, Wu, Feng wrote:
> >>> How this can work well? All subsequent interrupts are delivered to
> >>> one vCPU? It shouldn't be the best solution, need more consideration.
> >>
> >> Well, it's a hardware limitation.  The alternative (which is easy to
> >> implement) is to only do PI for single-CPU interrupts.  This should work
> >> well for multiqueue NICs (and of course for UP guests :)), so perhaps
> >> it's a good idea to only support that as a first attempt.
> >>
> >> Paolo
> >
> > Paolo, what do you mean by "single-CPU interrupts"? Do you mean we don't
> > support lowest priority interrupts for PI? But Linux OS uses lowest priority
> > for most of the case? If so, we can hardly get benefit from this feature for
> > Linux guest OS.
> 
> You can post lowest priority interrupts if they are delivered to a
> single CPU, in which case they are effectively fixed priority.
> 
> If they are broadcast to multiple CPUs, do not post them.
> 
> Paolo

In my understanding, lowest priority interrupts are always delivered to a
Single CPU, we need to find the right destination CPU from the cpumask.
This is what I do in this patch. Did I misunderstanding something in your
Comments? Thanks a lot!

Actually, we don't support posting broadcast/multicast interrupts, because
the interrupt is associated with one Posted-interrupts descriptor, then one
vCPU.

Thanks,
Feng

