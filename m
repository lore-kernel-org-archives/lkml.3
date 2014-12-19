Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaLSXe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 18:34:58 -0500
Received: from mga14.intel.com ([192.55.52.115]:5215 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaLSXe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 18:34:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,609,1413270000"; 
   d="scan'208";a="640529557"
From: "Wu, Feng" <feng.wu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        KVM list <kvm@vger.kernel.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 25/26] KVM: Suppress posted-interrupt when 'SN' is set
Thread-Topic: [v3 25/26] KVM: Suppress posted-interrupt when 'SN' is set
Thread-Index: AQHQG4NsmEtuDH0qPk6Pb+YapmEtyZyXkY0Q
Date: Fri, 19 Dec 2014 23:34:51 +0000
Message-ID: <E959C4978C3B6342920538CF579893F00230CFA7@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
	<1418397300-10870-26-git-send-email-feng.wu@intel.com>
	<5491C0A2.7040503@redhat.com>
	<E959C4978C3B6342920538CF579893F002307C4A@SHSMSX104.ccr.corp.intel.com>
	<5492926E.8070207@redhat.com>
	<A9667DDFB95DB7438FA9D7D576C3D87E0AC04938@SHSMSX104.ccr.corp.intel.com>
	<E959C4978C3B6342920538CF579893F00230ABEB@SHSMSX104.ccr.corp.intel.com>
	<A9667DDFB95DB7438FA9D7D576C3D87E0AC04FED@SHSMSX104.ccr.corp.intel.com>
	<E959C4978C3B6342920538CF579893F00230ADA0@SHSMSX104.ccr.corp.intel.com>
	<A9667DDFB95DB7438FA9D7D576C3D87E0AC05059@SHSMSX104.ccr.corp.intel.com>
	<E959C4978C3B6342920538CF579893F00230AE04@SHSMSX104.ccr.corp.intel.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC050B1@SHSMSX104.ccr.corp.intel.com>
 <54941365.60604@redhat.com>
In-Reply-To: <54941365.60604@redhat.com>
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
> Sent: Friday, December 19, 2014 8:01 PM
> To: Zhang, Yang Z; Wu, Feng; Paolo Bonzini; KVM list
> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> Subject: Re: [v3 25/26] KVM: Suppress posted-interrupt when 'SN' is set
> 
> 
> 
> On 19/12/2014 06:25, Zhang, Yang Z wrote:
> > I see your point. But from performance point, if we can schedule the
> > vCPU to another PCPU to handle the interrupt, it would helpful. But I
> > remember current KVM will not schedule the vCPU in run queue (even
> > though it got preempted) to another pCPU to run(Am I right?). So it
> > may hard to do it.
> 
> Yes.  If the vCPU is in the run queue, it means it exhausted its
> quantum.  As Feng said, the scheduler can decide to migrate it to
> another pCPU, or it can decide to leave it runnable but not start it.
> KVM doesn't try to force the scheduler one way or the other.
> 
> If the vCPU is I/O bound, it will not exhaust its quantum and will not
> be preempted.  It will block, and the wakeup vector will restart it.
> 
> I don't think urgent notifications are interesting.  If you want to do
> real time work, pin the vCPU to a physical CPU, and isolate the pCPU
> with isolcpus.  Then the vCPU will always be running.
> 
> Paolo

I agree, thanks Paolo!

Thanks,
Feng
