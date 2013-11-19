Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab3KSBRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 20:17:39 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:58833 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3KSBRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 20:17:35 -0500
Date: Mon, 18 Nov 2013 17:17:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, vmscan: abort futile reclaim if we've been oom
 killed
In-Reply-To: <20131118164107.GC3556@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1311181712080.4292@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1311121801200.18803@chino.kir.corp.google.com> <20131113152412.GH707@cmpxchg.org> <alpine.DEB.2.02.1311131400300.23211@chino.kir.corp.google.com> <20131114000043.GK707@cmpxchg.org> <alpine.DEB.2.02.1311131639010.6735@chino.kir.corp.google.com>
 <20131118164107.GC3556@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, Johannes Weiner wrote:

> > Um, no, those processes are going through a repeated loop of direct 
> > reclaim, calling the oom killer, iterating the tasklist, finding an 
> > existing oom killed process that has yet to exit, and looping.  They 
> > wouldn't loop for too long if we can reduce the amount of time that it 
> > takes for that oom killed process to exit.
> 
> I'm not talking about the big loop in the page allocator.  The victim
> is going through the same loop.  This patch is about the victim being
> in a pointless direct reclaim cycle when it could be exiting, all I'm
> saying is that the other tasks doing direct reclaim at that moment
> should also be quitting and retrying the allocation.
> 

"All other tasks" would be defined as though sharing the same mempolicy 
context as the oom kill victim or the same set of cpuset mems, I'm not 
sure what type of method for determining reclaim eligiblity you're 
proposing to avoid pointlessly spinning without making progress.  Until an 
alternative exists, my patch avoids the needless spinning and expedites 
the exit, so I'll ask that it be merged.
