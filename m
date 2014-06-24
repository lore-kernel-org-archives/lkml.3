Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaFXKOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:14:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:52012 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbaFXKOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:14:40 -0400
Date: Tue, 24 Jun 2014 10:24:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Waiman Long <waiman.long@hp.com>, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 03/11] qspinlock: Add pending bit
Message-ID: <20140624082422.GM13930@laptop.programming.kicks-ass.net>
References: <20140615124657.264658593@chello.nl>
 <20140615130153.196728583@chello.nl>
 <20140617203615.GA29634@laptop.dumpdata.com>
 <53A0AA6D.1070708@hp.com>
 <20140617210729.GB31817@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617210729.GB31817@laptop.dumpdata.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 05:07:29PM -0400, Konrad Rzeszutek Wilk wrote:
> > We are trying to make the fastpath as simple as possible as it may be
> > inlined. The complexity of the queue spinlock is in the slowpath.
> 
> Sure, but then it shouldn't be called slowpath anymore as it is not
> slow.

Its common terminology to call the inline part the fast path and the
out-of-line call on failure the slow path.
