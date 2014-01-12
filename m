Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaALWKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 17:10:55 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:43964 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaALWKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 17:10:52 -0500
Date: Sun, 12 Jan 2014 14:10:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
In-Reply-To: <20140110221432.GD6963@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1401121404530.20999@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com> <20131218200434.GA4161@dhcp22.suse.cz> <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com> <20131219144134.GH10855@dhcp22.suse.cz> <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org>
 <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com> <20140109144757.e95616b4280c049b22743a15@linux-foundation.org> <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com> <20140109161246.57ea590f00ea5b61fdbf5f11@linux-foundation.org>
 <alpine.DEB.2.02.1401091613560.22649@chino.kir.corp.google.com> <20140110221432.GD6963@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jan 2014, Johannes Weiner wrote:

> > > > It was acked-by Michal.
> 
> Michal acked it before we had most of the discussions and now he is
> proposing an alternate version of yours, a patch that you are even
> discussing with him concurrently in another thread.  To claim he is
> still backing your patch because of that initial ack is disingenuous.
> 

His patch depends on mine, Johannes.

> > Johannes is arguing for the same semantics that VMPRESSURE_CRITICAL and/or 
> > memory thresholds provides, which disagrees from the list of solutions 
> > that Documentation/cgroups/memory.txt gives for userspace oom handler 
> > wakeups and is required for any sane implementation.
> 
> No, he's not and I'm sick of you repeating refuted garbage like this.
> 
> You have convinced neither me nor Michal that your problem is entirely
> real and when confronted with doubt you just repeat the same points
> over and over.
> 

The conditional to check if current needs access to memory reserves to 
make forward progress and avoid oom killing anything else is done after 
the memcg notification.  It's real per section 6.8.4 of the C99 standard 
which defines how a conditional works.  We do not want a userspace 
notification in such a case because userspace testing of whether the 
condition is actionable would be unreliable.  This is not dead code, it 
does get executed.

> The one aspect of your change that we DO agree is valid is now fixed
> by Michal in a separate attempt because you could not be bothered to
> incorporate feedback into your patch.
> 

I suggested his patch, Johannes, but his patch depends on mine.  I'm 
hoping he can rebase his patch and it's done and merged into -mm before 
the merge window for 3.14 as I've stated.
