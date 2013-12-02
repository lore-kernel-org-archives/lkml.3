Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3LBXKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:10:00 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:62347 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3LBXJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:09:46 -0500
Date: Mon, 2 Dec 2013 15:09:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Luigi Semenzato <semenzato@google.com>, linux-mm@kvack.org,
        Greg Thelen <gthelen@google.com>, Glauber Costa <glommer@gmail.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Joern Engel <joern@logfs.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: user defined OOM policies
In-Reply-To: <20131128114214.GJ2761@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1312021508060.13465@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com> <20131120152251.GA18809@dhcp22.suse.cz> <CAA25o9S5EQBvyk=HP3obdCaXKjoUVtzeb4QsNmoLMq6NnOYifA@mail.gmail.com>
 <alpine.DEB.2.02.1311201933420.7167@chino.kir.corp.google.com> <CAA25o9Q64eK5LHhrRyVn73kFz=Z7Jji=rYWS=9jWL_4y9ZGbQA@mail.gmail.com> <alpine.DEB.2.02.1311251717370.27270@chino.kir.corp.google.com> <20131128114214.GJ2761@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Nov 2013, Michal Hocko wrote:

> > We already have hooks in the kernel oom killer, things like 
> > /proc/sys/vm/oom_kill_allocating_task
> 
> How would you implement oom_kill_allocating_task in userspace? You do
> not have any context on who is currently allocating or would you rely on
> reading /proc/*/stack to grep for allocation functions?
> 

Not the exact behavior, sorry.  I implemented oom_kill_allocating_task at 
the request for SGI that simply wanted to avoid the lengthy tasklist scan, 
they don't actually care what is killed as long as something is killed.  
The actual allocating task is difficult to predict, especially in system 
oom conditions, and their motivation was to make it as quickly as 
possible.  Userspace could certainly kill a random eligible process :)
