Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaLSXjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 18:39:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:1809 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbaLSXjj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 18:39:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,610,1413270000"; 
   d="scan'208";a="657396994"
From: "Wu, Feng" <feng.wu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 16/26] KVM: Make struct kvm_irq_routing_table accessible
Thread-Topic: [v3 16/26] KVM: Make struct kvm_irq_routing_table accessible
Thread-Index: AQHQG4NaL/XOC+t0S0iej0tzGb4XjJyXkpRw
Date: Fri, 19 Dec 2014 23:39:34 +0000
Message-ID: <E959C4978C3B6342920538CF579893F00230CFC3@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
 <1418397300-10870-17-git-send-email-feng.wu@intel.com>
 <5491ACA9.5020507@redhat.com>
 <E959C4978C3B6342920538CF579893F00230A97C@SHSMSX104.ccr.corp.intel.com>
 <5494132C.7060204@redhat.com>
In-Reply-To: <5494132C.7060204@redhat.com>
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
> Sent: Friday, December 19, 2014 8:00 PM
> To: Wu, Feng; linux-kernel@vger.kernel.org
> Cc: iommu@lists.linux-foundation.org; kvm@vger.kernel.org
> Subject: Re: [v3 16/26] KVM: Make struct kvm_irq_routing_table accessible
> 
> 
> 
> On 19/12/2014 03:19, Wu, Feng wrote:
> >>> > >
> >>> > > +#ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
> >>> > > +
> >>> > > +struct kvm_irq_routing_table {
> >>> > > +	int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
> >>> > > +	struct kvm_kernel_irq_routing_entry *rt_entries;
> >>> > > +	u32 nr_rt_entries;
> >>> > > +	/*
> >>> > > +	 * Array indexed by gsi. Each entry contains list of irq chips
> >>> > > +	 * the gsi is connected to.
> >>> > > +	 */
> >>> > > +	struct hlist_head map[0];
> >>> > > +};
> >>> > > +
> >>> > > +#else
> >>> > > +
> >>> > > +struct kvm_irq_routing_table {};
> >> >
> >> > If possible, just make this "struct kvm_irq_routing_table;" and pull
> >> > this line to include/linux/kvm_types.h.
> >> >
> >> > Paolo
> > Do you mean move the definition of struct kvm_irq_routing_table
> > to include/linux/kvm_types.h and add a declaration here?
> 
> Move
> 
> struct kvm_irq_routing_table;
> 
> to include/linux/kvm_types.h.  In kvm_host.h, leave the #ifdef with the
> full definition but drop the #else.
> 
> Paolo


Paolo, Thanks for the explanation. I notice that " struct kvm_irq_routing_table;"
is already in include/linux/kvm_types.h.

Thanks,
Feng
