Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaAXEFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 23:05:44 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:51758 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaAXEFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 23:05:43 -0500
Date: Thu, 23 Jan 2014 23:05:31 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: oom_kill: revert 3% system memory bonus for
 privileged tasks
Message-ID: <20140124040531.GF4407@cmpxchg.org>
References: <20140115234308.GB4407@cmpxchg.org>
 <alpine.DEB.2.02.1401151614480.15665@chino.kir.corp.google.com>
 <20140116070709.GM6963@cmpxchg.org>
 <alpine.DEB.2.02.1401212050340.8512@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401212050340.8512@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 08:53:07PM -0800, David Rientjes wrote:
> On Thu, 16 Jan 2014, Johannes Weiner wrote:
> 
> > > Unfortunately, I think this could potentially be too much of a bonus.  On 
> > > your same 32GB machine, if a root process is using 18GB and a user process 
> > > is using 14GB, the user process ends up getting selected while the current 
> > > discount of 3% still selects the root process.
> > > 
> > > I do like the idea of scaling this bonus depending on points, however.  I 
> > > think it would be better if we could scale the discount but also limit it 
> > > to some sane value.
> > 
> > I just reverted to the /= 4 because we had that for a long time and it
> > seemed to work.  I don't really mind either way as long as we get rid
> > of that -3%.  Do you have a suggestion?
> > 
> 
> How about simply using 3% of the root process's points so that root 
> processes get some bonus compared to non-root processes with the same 
> memory usage and it's scaled to the usage rather than amount of available 
> memory?
> 
> So rather than points /= 4, we do
> 
> 	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
> 		points -= (points * 3) / 100;
> 
> instead.  Sound good?

Yes, should be okay.

Do you want to send a patch?  Want me to update mine?
