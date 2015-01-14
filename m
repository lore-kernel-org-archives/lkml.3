Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbbANRAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:00:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbbANQ77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:59:59 -0500
Date: Wed, 14 Jan 2015 17:59:10 +0100
From: Radim =?utf-8?B?S3I/bcOhPw==?= <rkrcmar@redhat.com>
To: "Wu, Feng" <feng.wu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@kernel.org" <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
 VT-d PI
Message-ID: <20150114165909.GA1283@potion.brq.redhat.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
 <1418397300-10870-14-git-send-email-feng.wu@intel.com>
 <20150109145435.GA22469@potion.brq.redhat.com>
 <54AFEC00.80507@redhat.com>
 <E959C4978C3B6342920538CF579893F002341102@SHSMSX104.ccr.corp.intel.com>
 <20150113161716.GA12941@potion.brq.redhat.com>
 <E959C4978C3B6342920538CF579893F00234E4CD@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E959C4978C3B6342920538CF579893F00234E4CD@SHSMSX104.ccr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-14 01:27+0000, Wu, Feng:
> > the new
> > > hardware even doesn't consider the TPR for lowest priority interrupts
> > delivery.
> > 
> > A bold move ... what hardware was the first to do so?
> 
> I think it was starting with Nehalem.

Thanks,  (Could be that QPI can't inform about TPR changes anymore ...)

I played with Linux's TPR on Haswell and found that is has no effect.

> > > As discussed with Paolo before, I will submit a patch to support lowest
> > priority for PI
> > > after this series is merged.
> > 
> > Sure, I see only two good solutions though
> >  1) don't optimize lowest priority with PI
> >  2) don't balance lowest priority
> 
> As discussed with Paolo before, as the first stage, we only support single-CPU
> lowest priority for PI, since this is a new hardware feature enabling, Paolo trends
> to do simple things in the beginning.

I agree, that is the best we can do without changing lowest priority.

I wanted to avoid a future solution that would introduce two behaviors
for lowest priority (round robin and something).
Round robin (anything dynamic) can't be done with PI, hence the question
if we can remove it.

>                                       Then we will support full lowest priority for
> it, such as, using vector hashing (this is one method of what hardware do for
> lowest priority today), I need to get some detailed information about this from
> hardware guys before enabling it.

I wasn't able to confirm hashing, is it a recent addition?
I'm not sure we want it then:  OS still has to take care of proper
distribution, being predictable is better than uncertain gains, and
we'll save code.

The same should apply to hardware though ... do you know the reasons
behind vector hashing?

Thank you.
