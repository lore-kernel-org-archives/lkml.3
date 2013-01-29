Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3A2JMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:12:53 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:36269 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab3A2JMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:12:50 -0500
Date: Tue, 29 Jan 2013 10:12:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        lkp@linux.intel.com
Subject: Re: aim7 performance regression by commit 5a50508 report from LKP
Message-ID: <20130129091245.GB5775@gmail.com>
References: <20130129082537.GS12678@yliu-dev.sh.intel.com>
 <20130129084400.GA5350@gmail.com>
 <20130129090620.GT12678@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129090620.GT12678@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:

> On Tue, Jan 29, 2013 at 09:44:00AM +0100, Ingo Molnar wrote:
> > 
> > * Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> > 
> > > [...]
> > 
> > Very nice measurements and analysis, thanks!
> > 
> > > As stated above, anybody can have a chance to own the lock in 
> > > mutex once somebody release the lock. Well, there is only one 
> > > to own the lock in rwsem write lock, and the one is known 
> > > already: the one in the head of wait list. That would result 
> > > to more contention in rwsem write lock case, especially if the 
> > > one _will_ own the lock is not running now.
> > 
> > I think we should allow lock-steal between rwsem writers - that 
> > will not hurt fairness as most rwsem fairness concerns relate to 
> > reader vs. writer fairness.
> 
> Agreed, and I'm sure this will improve performance and may 
> make this performance regression go away.
> 
> David, is that Ok to you? If so, I may have a try.

I'm not David but please try it :-)

Making rwsem behavior and scalability similar to mutexes would 
have numerous advantages.

> > Am I correct to assume that all relevant users in this 
> > workload are down_write() users?
> 
> Yes, as commit 5a50508 just convert all mutex to down_write.

A second track of inquiry would be to see whether any of the key 
usage sites could be converted to down_read() or whether the 
lock hold times could be reduced drastically - but I doubt 
that's really possible on such heavily forking workloads.

Thanks,

	Ingo
