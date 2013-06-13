Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264Ab3FMUev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 16:34:51 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54066 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770Ab3FMUes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 16:34:48 -0400
Date: Thu, 13 Jun 2013 13:34:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] memcg: do not sleep on OOM waitqueue with full charge
 context
In-Reply-To: <20130613134826.GE23070@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1306131330170.8686@chino.kir.corp.google.com>
References: <20130606173355.GB27226@cmpxchg.org> <alpine.DEB.2.02.1306061308320.9493@chino.kir.corp.google.com> <20130606215425.GM15721@cmpxchg.org> <alpine.DEB.2.02.1306061507330.15503@chino.kir.corp.google.com> <20130607000222.GT15576@cmpxchg.org>
 <alpine.DEB.2.02.1306111454030.4803@chino.kir.corp.google.com> <20130612082817.GA6706@dhcp22.suse.cz> <alpine.DEB.2.02.1306121309500.23348@chino.kir.corp.google.com> <20130612203705.GB17282@dhcp22.suse.cz> <alpine.DEB.2.02.1306121343500.24902@chino.kir.corp.google.com>
 <20130613134826.GE23070@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jun 2013, Michal Hocko wrote:

> > Right now it appears that that number of users is 0 and we're talking 
> > about a problem that was reported in 3.2 that was released a year and a 
> > half ago.  The rules of inclusion in stable also prohibit such a change 
> > from being backported, specifically "It must fix a real bug that bothers 
> > people (not a, "This could be a problem..." type thing)".
> 
> As you can see there is an user seeing this in 3.2. The bug is _real_ and
> I do not see what you are objecting against. Do you really think that
> sitting on a time bomb is preferred more?
> 

Nobody has reported the problem in seven months.  You're patching a kernel 
that's 18 months old.  Your "user" hasn't even bothered to respond to your 
backport.  This isn't a timebomb.

> > We have deployed memcg on a very large number of machines and I can run a 
> > query over all software watchdog timeouts that have occurred by 
> > deadlocking on i_mutex during memcg oom.  It returns 0 results.
> 
> Do you capture /prc/<pid>/stack for each of them to find that your
> deadlock (and you have reported that they happen) was in fact caused by
> a locking issue? These kind of deadlocks might got unnoticed especially
> when the oom is handled by userspace by increasing the limit (my mmecg
> is stuck and increasing the limit a bit always helped).
> 

We dump stack traces for every thread on the system to the kernel log for 
a software watchdog timeout and capture it over the network for searching 
later.  We have not experienced any deadlock that even remotely resembles 
the stack traces in the chnagelog.  We do not reproduce this issue.
