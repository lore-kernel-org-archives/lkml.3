Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598AbaE2GqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:46:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:46386 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933540AbaE2GqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:46:17 -0400
Date: Thu, 29 May 2014 08:46:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        konrad.wilk@oracle.com, pbonzini@redhat.com, gleb@redhat.com,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        waiman.long@hp.com, davej@redhat.com, oleg@redhat.com, x86@kernel.org,
        jeremy@goop.org, paul.gortmaker@windriver.com, ak@linux.intel.com,
        jasowang@redhat.com, fernando_b1@lab.ntt.co.jp,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, riel@redhat.com, mtosatti@redhat.com,
        chegu_vinod@hp.com
Subject: Re: [RFC] Implement Batched (group) ticket lock
Message-ID: <20140529064606.GH19143@laptop.programming.kicks-ass.net>
References: <1401279399-23854-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401279399-23854-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 05:46:39PM +0530, Raghavendra K T wrote:
> In virtualized environment there are mainly three problems
> related to spinlocks that affect performance.
> 1. LHP (lock holder preemption)
> 2. Lock Waiter Preemption (LWP)
> 3. Starvation/fairness
> 
>  Though ticketlocks solve the fairness problem, it worsens LWP, LHP problems.
> pv-ticketlocks tried to address this. But we can further improve at the
> cost of relaxed fairness.

So I really hate the idea of having different locks for paravirt and
normal kernels.

And we're looking to move to that queued lock for normal kernels.
