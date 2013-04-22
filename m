Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3DVMkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:40:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab3DVMkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:40:16 -0400
Date: Mon, 22 Apr 2013 15:39:38 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, avi.kivity@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 00/15] KVM: MMU: fast zap all shadow pages
Message-ID: <20130422123938.GB10970@redhat.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130421130346.GE8997@redhat.com>
 <20130421152751.GB28437@amt.cnet>
 <20130421153508.GA28842@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130421153508.GA28842@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 12:35:08PM -0300, Marcelo Tosatti wrote:
> On Sun, Apr 21, 2013 at 12:27:51PM -0300, Marcelo Tosatti wrote:
> > On Sun, Apr 21, 2013 at 04:03:46PM +0300, Gleb Natapov wrote:
> > > On Tue, Apr 16, 2013 at 02:32:38PM +0800, Xiao Guangrong wrote:
> > > > This patchset is based on my previous two patchset:
> > > > [PATCH 0/2] KVM: x86: avoid potential soft lockup and unneeded mmu reload
> > > > (https://lkml.org/lkml/2013/4/1/2)
> > > > 
> > > > [PATCH v2 0/6] KVM: MMU: fast invalid all mmio sptes
> > > > (https://lkml.org/lkml/2013/4/1/134)
> > > > 
> > > > Changlog:
> > > > V3:
> > > >   completely redesign the algorithm, please see below.
> > > > 
> > > This looks pretty complicated. Is it still needed in order to avoid soft
> > > lockups after "avoid potential soft lockup and unneeded mmu reload" patch?
> > 
> > Do not want kvm_set_memory (cases: DELETE/MOVE/CREATES) to be
> > suspectible to:
> > 
> > vcpu 1    		|	kvm_set_memory
> > create shadow page 		
> > 				nuke shadow page
> > create shadow page
> > 				nuke shadow page
> > 
> > Which is guest triggerable behavior with spinlock preemption algorithm.
> 
> Not only guest triggerable as in the sense of a malicious guest, 
> but condition above can be induced by host workload with non-malicious
> guest system.
> 
Is the problem that newly created shadow pages are immediately zapped?
Shouldn't generation number/kvm_mmu_zap_all_invalid() idea described here
https://lkml.org/lkml/2013/4/22/111 solve this?

> Also kvm_set_memory being relatively fast with huge memory guests
> is nice (which is what Xiaos idea allows).
> 

--
			Gleb.
