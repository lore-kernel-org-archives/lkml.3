Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab3KWAJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 19:09:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467Ab3KWAJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 19:09:28 -0500
Date: Sat, 23 Nov 2013 00:09:24 +0000
From: Mel Gorman <mgorman@suse.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: mm, numa: test segfaults, only when NUMA balancing is on
Message-ID: <20131123000924.GC5285@suse.de>
References: <20131104200346.GA3066@sgi.com>
 <20131106131048.GC4877@suse.de>
 <20131107214838.GY3066@sgi.com>
 <20131108112054.GB5040@suse.de>
 <20131108221329.GD4236@sgi.com>
 <20131112212902.GA4725@sgi.com>
 <20131115000901.GB26002@suse.de>
 <20131115144504.GE26002@suse.de>
 <20131122212807.GR3062@sgi.com>
 <20131122230524.GB5285@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131122230524.GB5285@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 11:05:24PM +0000, Mel Gorman wrote:
> On Fri, Nov 22, 2013 at 03:28:07PM -0600, Alex Thorlton wrote:
> > > If the warning added by that patch does *not* trigger than can you also
> > > test this patch? It removes the barriers which should not be necessary
> > > and takes a reference tot he page before waiting on the lock. The
> > > previous version did not take the reference because otherwise the
> > > WARN_ON could not distinguish between a migration waiter and a surprise
> > > gup.
> > 
> > Sorry for the delay; been a bit busy.  I tested both of these patches on
> > top of this one (separately, of course):
> > 
> > http://www.spinics.net/lists/linux-mm/msg63919.html
> > 
> > I think that's the one you were referring to, if not send me a pointer
> > to the correct one and I'll give it another shot.  Both patches still
> > segfaulted, so it doesn't appear that either of these solved the
> > problem. 
> 
> I see. Does THP have to be enabled or does it segfault even with THP
> disabled?
> 

On a semi-related note, is the large machine doing anything with xpmem
or anything that depends on MMU notifiers to work properly? I noted
while looking at this that THP migration is not invalidating pages which
might be confusing a driver depending on it.

-- 
Mel Gorman
SUSE Labs
