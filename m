Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbaG1RT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:19:59 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:43908 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaG1RT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:19:56 -0400
Message-ID: <1406567993.2411.31.camel@j-VirtualBox>
Subject: Re: [PATCH -tip/master 3/7] locking/mcs: Remove obsolete comment
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Jul 2014 10:19:53 -0700
In-Reply-To: <20140728165733.GU19379@twins.programming.kicks-ass.net>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
	 <1406524724-17946-3-git-send-email-davidlohr@hp.com>
	 <1406566175.2411.13.camel@j-VirtualBox>
	 <1406566438.25428.6.camel@buesod1.americas.hpqcorp.net>
	 <20140728165733.GU19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-28 at 18:57 +0200, Peter Zijlstra wrote:
> On Mon, Jul 28, 2014 at 09:53:58AM -0700, Davidlohr Bueso wrote:
> > Well, it's not hard to see where the contention is when working on
> > locking issues with perf. With mutexes there are only two sources,
> > either the task is just spinning trying to get the lock, or its gone to
> > the slowpath, and you can see a lot of contention on the wait_lock. 
> > 
> > So unless I'm missing something, I don't think we'd need to make this
> > noinline again -- although I forget why it was changed in the first
> > place.
> 
> Not to mention that there's no actual caller of this function in the
> entire kernel ;-) Currently its just 'documentation' describing what an
> actual MCS lock looks like.

Yeah, we only use the cancellable version of the lock anyway and there's
currently no benefit of changing the regular mcs lock to noinline.

I was mainly thinking it could be helpful in potential later uses of the
regular mcs lock (if anyone comes up with a need to use it) where it
might not be as obvious where the contention is occurring.

