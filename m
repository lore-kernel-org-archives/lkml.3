Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaLSL7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 06:59:48 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:39015 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaLSL7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 06:59:45 -0500
Message-ID: <5494132C.7060204@redhat.com>
Date: Fri, 19 Dec 2014 12:59:40 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Wu, Feng" <feng.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [v3 16/26] KVM: Make struct kvm_irq_routing_table accessible
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com> <1418397300-10870-17-git-send-email-feng.wu@intel.com> <5491ACA9.5020507@redhat.com> <E959C4978C3B6342920538CF579893F00230A97C@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <E959C4978C3B6342920538CF579893F00230A97C@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19/12/2014 03:19, Wu, Feng wrote:
>>> > >
>>> > > +#ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
>>> > > +
>>> > > +struct kvm_irq_routing_table {
>>> > > +	int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
>>> > > +	struct kvm_kernel_irq_routing_entry *rt_entries;
>>> > > +	u32 nr_rt_entries;
>>> > > +	/*
>>> > > +	 * Array indexed by gsi. Each entry contains list of irq chips
>>> > > +	 * the gsi is connected to.
>>> > > +	 */
>>> > > +	struct hlist_head map[0];
>>> > > +};
>>> > > +
>>> > > +#else
>>> > > +
>>> > > +struct kvm_irq_routing_table {};
>> > 
>> > If possible, just make this "struct kvm_irq_routing_table;" and pull
>> > this line to include/linux/kvm_types.h.
>> > 
>> > Paolo
> Do you mean move the definition of struct kvm_irq_routing_table
> to include/linux/kvm_types.h and add a declaration here?

Move

struct kvm_irq_routing_table;

to include/linux/kvm_types.h.  In kvm_host.h, leave the #ifdef with the
full definition but drop the #else.

Paolo
