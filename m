Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab3FNJ3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:29:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab3FNJ3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:29:15 -0400
Date: Fri, 14 Jun 2013 11:29:12 +0200
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] memcg: do not sleep on OOM waitqueue with full
 charge context
Message-ID: <20130614092912.GA10084@dhcp22.suse.cz>
References: <20130606215425.GM15721@cmpxchg.org>
 <alpine.DEB.2.02.1306061507330.15503@chino.kir.corp.google.com>
 <20130607000222.GT15576@cmpxchg.org>
 <alpine.DEB.2.02.1306111454030.4803@chino.kir.corp.google.com>
 <20130612082817.GA6706@dhcp22.suse.cz>
 <alpine.DEB.2.02.1306121309500.23348@chino.kir.corp.google.com>
 <20130612203705.GB17282@dhcp22.suse.cz>
 <alpine.DEB.2.02.1306121343500.24902@chino.kir.corp.google.com>
 <20130613134826.GE23070@dhcp22.suse.cz>
 <alpine.DEB.2.02.1306131330170.8686@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306131330170.8686@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13-06-13 13:34:46, David Rientjes wrote:
> On Thu, 13 Jun 2013, Michal Hocko wrote:
> 
> > > Right now it appears that that number of users is 0 and we're talking 
> > > about a problem that was reported in 3.2 that was released a year and a 
> > > half ago.  The rules of inclusion in stable also prohibit such a change 
> > > from being backported, specifically "It must fix a real bug that bothers 
> > > people (not a, "This could be a problem..." type thing)".
> > 
> > As you can see there is an user seeing this in 3.2. The bug is _real_ and
> > I do not see what you are objecting against. Do you really think that
> > sitting on a time bomb is preferred more?
> > 
> 
> Nobody has reported the problem in seven months.  You're patching a kernel 
> that's 18 months old.  Your "user" hasn't even bothered to respond to your 
> backport. 
>
> This isn't a timebomb.

Doh. This is getting ridiculous! So you are claiming that oom blocking
while the task might be sitting on an unpredictable amount of locks
which could block oom victims to die is OK? I would consider it a _bug_
and I am definitely backporting it to our kernel which is 3.0 based
whether it end up in the stable or not.

Whether this is a general stable material I will leave for others (I
would be voting for it because it definitely makes sense). The real
regardless how many users suffer from it. The stable-or-not discussion
shouldn't delay the fix for the current tree though. Or do you disagree
with the patch itself?

> > > We have deployed memcg on a very large number of machines and I can run a 
> > > query over all software watchdog timeouts that have occurred by 
> > > deadlocking on i_mutex during memcg oom.  It returns 0 results.
> > 
> > Do you capture /prc/<pid>/stack for each of them to find that your
> > deadlock (and you have reported that they happen) was in fact caused by
> > a locking issue? These kind of deadlocks might got unnoticed especially
> > when the oom is handled by userspace by increasing the limit (my mmecg
> > is stuck and increasing the limit a bit always helped).
> > 
> 
> We dump stack traces for every thread on the system to the kernel log for 
> a software watchdog timeout and capture it over the network for searching 
> later.  We have not experienced any deadlock that even remotely resembles 
> the stack traces in the chnagelog.  We do not reproduce this issue.

OK. This could really rule it out for you. The analysis is not really
trivial because locks might be hidden nicely but having the data is
definitely useful.
-- 
Michal Hocko
SUSE Labs
