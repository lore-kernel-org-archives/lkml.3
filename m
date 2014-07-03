Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaGCRLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:11:25 -0400
Received: from g6t1525.atlanta.hp.com ([15.193.200.68]:4431 "EHLO
	g6t1525.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbaGCRLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:11:24 -0400
Message-ID: <1404407389.2498.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC] Cancellable MCS spinlock rework
From: Davidlohr Bueso <davidlohr@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Low <jason.low2@hp.com>, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org, Waiman.Long@hp.com,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, andi@firstfloor.org,
        James.Bottomley@hansenpartnership.com, rostedt@goodmis.org,
        tim.c.chen@linux.intel.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
In-Reply-To: <20140703073107.GS19379@twins.programming.kicks-ass.net>
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
	 <20140702162749.GP19379@twins.programming.kicks-ass.net>
	 <1404320356.3170.12.camel@j-VirtualBox>
	 <20140702172333.GQ19379@twins.programming.kicks-ass.net>
	 <1404322203.3170.17.camel@j-VirtualBox>
	 <20140703073107.GS19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jul 2014 10:09:49 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-03 at 09:31 +0200, Peter Zijlstra wrote:
> On Wed, Jul 02, 2014 at 10:30:03AM -0700, Jason Low wrote:
> > Would potentially reducing the size of the rw semaphore structure by 32
> > bits (for all architectures using optimistic spinning) be a nice
> > benefit?
> 
> Possibly, although I had a look at the mutex structure and we didn't
> have a hole to place it in, unlike what you found with the rwsem.

Yeah, and currently struct rw_semaphore is the largest lock we have in
the kernel. Shaving off space is definitely welcome.

