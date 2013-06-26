Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab3FZPxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:53:30 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:60314 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3FZPx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:53:29 -0400
Date: Wed, 26 Jun 2013 17:53:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v5 0/9] liblockdep: userspace lockdep
Message-ID: <20130626155325.GB7399@gmail.com>
References: <1371163284-6346-1-git-send-email-sasha.levin@oracle.com>
 <20130626122408.GJ28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626122408.GJ28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Jun 13, 2013 at 06:41:15PM -0400, Sasha Levin wrote:
> > liblockdep is a tiny wrapper built around kernel/lockdep.c. The aim is to
> > provide the same functionality the kernel gets from lockdep to userspace.
> > 
> > The bulk of the code here is the LD_PRELOAD support which provides users
> > an easy way to test their code without having to integrate liblockdep into
> > said code. Simply doing:
> > 
> >         lockdep my_app
> > 
> > Would provide lockdep support to my_app.
> > 
> > There is also a small test suite to test both mutexes and rwlocks, it's
> > based on the tests in lib/locking-selftest.c.
> > 
> > This entire patch series was reviewed by lockdep maintainers and accepted to
> > the tip tree previously. It was pulled out so that the potential merge of
> > liblockdep won't delay the rest of the commits in the tip locking tree.
> > 
> > For some more background about this entire thing, the folks at LWN did
> > an awesome overview: http://lwn.net/Articles/536363/
> > 
> 
> Ingo, I don't think I see anything holding this back; however I remember 
> reading some email about people not liking stuff like this living in the 
> tools/ directory or such.
> 
> Will you pick this up?

So I'd really be interested in how interesting/useful this is to userspace 
developers? Does it work for something complex as Firefox, or Apache, to 
the extent they make use of these locking APIs?

'people' not liking the in-tree solution was for example Linus, who's on 
Cc:, so if Linus you still have a strong opinion against it I won't merge 
it against you.

Thanks,

	Ingo
