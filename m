Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3DWCE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 22:04:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab3DWCEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 22:04:24 -0400
Date: Mon, 22 Apr 2013 20:02:34 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 00/15] KVM: MMU: fast zap all shadow pages
Message-ID: <20130422230233.GA3337@amt.cnet>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130421130346.GE8997@redhat.com>
 <20130421152751.GB28437@amt.cnet>
 <20130421153508.GA28842@amt.cnet>
 <20130422123938.GB10970@redhat.com>
 <20130422224553.b4dd57075cc7e32aacaadc01@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130422224553.b4dd57075cc7e32aacaadc01@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 10:45:53PM +0900, Takuya Yoshikawa wrote:
> On Mon, 22 Apr 2013 15:39:38 +0300
> Gleb Natapov <gleb@redhat.com> wrote:
> 
> > > > Do not want kvm_set_memory (cases: DELETE/MOVE/CREATES) to be
> > > > suspectible to:
> > > > 
> > > > vcpu 1    		|	kvm_set_memory
> > > > create shadow page 		
> > > > 				nuke shadow page
> > > > create shadow page
> > > > 				nuke shadow page
> > > > 
> > > > Which is guest triggerable behavior with spinlock preemption algorithm.
> > > 
> > > Not only guest triggerable as in the sense of a malicious guest, 
> > > but condition above can be induced by host workload with non-malicious
> > > guest system.
> > > 
> > Is the problem that newly created shadow pages are immediately zapped?
> > Shouldn't generation number/kvm_mmu_zap_all_invalid() idea described here
> > https://lkml.org/lkml/2013/4/22/111 solve this?
> 
> I guess so.  That's what Avi described when he tried to achieve
> lockless TLB flushes.  Mixing that idea with Xiao's approach will
> achieve reasonably nice performance, I think.

Yes.

> Various improvements should be added later on top of that if needed.
> 
> > > Also kvm_set_memory being relatively fast with huge memory guests
> > > is nice (which is what Xiaos idea allows).
> 
> I agree with this point.  But if so, it should be actually measured on
> such guests, even if the algorithm looks promising.

Works for me.

