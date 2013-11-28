Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419Ab3K1LmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:42:22 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:35551 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3K1LmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:42:18 -0500
Date: Thu, 28 Nov 2013 12:42:14 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Luigi Semenzato <semenzato@google.com>, linux-mm@kvack.org,
        Greg Thelen <gthelen@google.com>, Glauber Costa <glommer@gmail.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Joern Engel <joern@logfs.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: user defined OOM policies
Message-ID: <20131128114214.GJ2761@dhcp22.suse.cz>
References: <20131119131400.GC20655@dhcp22.suse.cz>
 <20131119134007.GD20655@dhcp22.suse.cz>
 <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com>
 <20131120152251.GA18809@dhcp22.suse.cz>
 <CAA25o9S5EQBvyk=HP3obdCaXKjoUVtzeb4QsNmoLMq6NnOYifA@mail.gmail.com>
 <alpine.DEB.2.02.1311201933420.7167@chino.kir.corp.google.com>
 <CAA25o9Q64eK5LHhrRyVn73kFz=Z7Jji=rYWS=9jWL_4y9ZGbQA@mail.gmail.com>
 <alpine.DEB.2.02.1311251717370.27270@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311251717370.27270@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 25-11-13 17:29:20, David Rientjes wrote:
> On Wed, 20 Nov 2013, Luigi Semenzato wrote:
> 
> > Yes, I agree that we can't always prevent OOM situations, and in fact
> > we tolerate OOM kills, although they have a worse impact on the users
> > than controlled freeing does.
> > 
> 
> If the controlled freeing is able to actually free memory in time before 
> hitting an oom condition, it should work pretty well.  That ability is 
> seems to be highly dependent on sane thresholds for indvidual applications 
> and I'm afraid we can never positively ensure that we wakeup and are able 
> to free memory in time to avoid the oom condition.
> 
> > Well OK here it goes.  I hate to be a party-pooper, but the notion of
> > a user-level OOM-handler scares me a bit for various reasons.
> > 
> > 1. Our custom notifier sends low-memory warnings well ahead of memory
> > depletion.  If we don't have enough time to free memory then, what can
> > the last-minute OOM handler do?
> > 
> 
> The userspace oom handler doesn't necessarily guarantee that you can do 
> memory freeing, our usecase wants to do a priority-based oom killing that 
> is different from the kernel oom killer based on rss.  To do that, you 
> only really need to read certain proc files and you can do killing based 
> on uptime, for example.  You can also do a hierarchical traversal of 
> memcgs based on a priority.
> 
> We already have hooks in the kernel oom killer, things like 
> /proc/sys/vm/oom_kill_allocating_task

How would you implement oom_kill_allocating_task in userspace? You do
not have any context on who is currently allocating or would you rely on
reading /proc/*/stack to grep for allocation functions?

> and /proc/sys/vm/panic_on_oom that 
[...]
-- 
Michal Hocko
SUSE Labs
