Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab3KAKPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 06:15:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45747 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3KAKPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 06:15:23 -0400
Date: Fri, 1 Nov 2013 11:15:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/4] mm/rmap: per anon_vma lock
Message-ID: <20131101101514.GD19466@laptop.lan>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1383292467-28922-2-git-send-email-yuanhan.liu@linux.intel.com>
 <20131101084329.GB19466@laptop.lan>
 <CANN689HQUv=k4AiD+v3980AmgPXbtcs1HLD7Ec1y8dsOfa_emA@mail.gmail.com>
 <20131101100707.GB30123@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101100707.GB30123@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 06:07:07PM +0800, Yuanhan Liu wrote:
> > I also want to point out that lately we've seen several changes sent
> > out that relax locking with no accompanying explanation of why the
> > relaxed locking would be safe. Please don't do that - having a lot of
> > performance data is worthless if you can't explain why the new locking
> > is safe.
> 
> Agreed.
> 
> > And I'm not asking to prove a negative ('lack of any possible
> > races') there, but at least in this case one could dig out why the
> > root anon vma locking was introduced and if they think that this
> > reason doesn't apply anymore, explain why...
> 
> It was introduced by commit 2b575eb6(And, BTW, I'm sorry that this commit log
> about bb4aa39676f is wrong)
> 
>    commit 2b575eb64f7a9c701fb4bfdb12388ac547f6c2b6
>    Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
>    Date:   Tue May 24 17:12:11 2011 -0700
>    
>        mm: convert anon_vma->lock to a mutex
>    
>        Straightforward conversion of anon_vma->lock to a mutex.
>    
> As you can see, Peter didn't tell why before. Honestly speaking, that
> was my originaly concern as well. I tried to find some possible races;
> I guess I may miss something.

Bullshit; I didn't change the locking. I only changed the lock primitive
from a spinlock to a mutex. The anon_vma->root->lock is completely
unrelated to this change.
