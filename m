Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaGAJz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:55:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaGAJzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:55:55 -0400
Date: Tue, 1 Jul 2014 11:55:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        konrad.wilk@oracle.com, pbonzini@redhat.com, gleb@redhat.com,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        waiman.long@hp.com, riel@redhat.com, davej@redhat.com, oleg@redhat.com,
        x86@kernel.org, jeremy@goop.org, paul.gortmaker@windriver.com,
        ak@linux.intel.com, jasowang@redhat.com, fernando_b1@lab.ntt.co.jp,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, mtosatti@redhat.com,
        chegu_vinod@hp.com
Subject: Re: [RFC PATCH v2] Implement Batched (group) ticket lock
Message-ID: <20140701095521.GO6758@twins.programming.kicks-ass.net>
References: <1403947024-3193-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
 <20140701080537.GH6758@twins.programming.kicks-ass.net>
 <53B282E9.6060806@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B282E9.6060806@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 03:14:09PM +0530, Raghavendra K T wrote:
> On 07/01/2014 01:35 PM, Peter Zijlstra wrote:
> >On Sat, Jun 28, 2014 at 02:47:04PM +0530, Raghavendra K T wrote:
> >>In virtualized environment there are mainly three problems
> >>related to spinlocks that affects performance.
> >>1. LHP (lock holder preemption)
> >>2. Lock Waiter Preemption (LWP)
> >>3. Starvation/fairness
> >>
> >>Though Ticketlocks solve fairness problem it worsens LWP, LHP problems. Though
> >>pv-ticketlocks tried to address these problems we can further improve at the
> >>  cost of relaxed fairness. The following patch tries to achieve that by grouping
> >>(batched) ticketlocks.
> >
> >And here I stop reading and ignore this patch, right?
> >
> >Why should I look at this?
> >
> 
> For baremetal we continue to have 'fully fair ticketlock' with this patch
> series.
> 

But but but, we're looking at removing ticket locks. So why do we want
to invest in them now?
