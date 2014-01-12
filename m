Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315AbaALWOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 17:14:14 -0500
Received: from mail-gg0-f173.google.com ([209.85.161.173]:56272 "EHLO
	mail-gg0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaALWOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 17:14:11 -0500
Date: Sun, 12 Jan 2014 14:14:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
In-Reply-To: <20140110223420.GE6963@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1401121411000.20999@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com> <20131218200434.GA4161@dhcp22.suse.cz> <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com> <20131219144134.GH10855@dhcp22.suse.cz> <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org>
 <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com> <20140109144757.e95616b4280c049b22743a15@linux-foundation.org> <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com> <20140110083025.GE9437@dhcp22.suse.cz>
 <alpine.DEB.2.02.1401101335200.21486@chino.kir.corp.google.com> <20140110223420.GE6963@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jan 2014, Johannes Weiner wrote:

> > Your patch, which is partially based on my suggestion to move the 
> > mem_cgroup_oom_notify() and call it from two places to support both 
> > memory.oom_control == 1 and != 1, is something that I liked as you know.  
> > It's based on my patch which is now removed from -mm.  So if you want to 
> > rebase that patch and propose it, that's great, but this is yet another 
> > occurrence of where important patches have been yanked out just before the 
> > merge window when the problem they are fixing is real and we depend on 
> > them.
> 
> We tried to discuss and understand the problem, yet all we got was
> "it's OBVIOUS" and "Google has been using this patch ever since we
> switched to memcg" and flat out repetitions of the same points about
> reliable OOM notification that were already put into question.
> 
> You still have not convinced me that the problem exists as you
> described it, apart from the aspects that Michal is now fixing
> separately because you did not show any signs of cooperating.
> 

I cooperated by suggesting his patch which moves the 
mem_cgroup_oom_notify(), Johannes.  The problem is that it depends on my 
patch which was removed from -mm.  He can rebase that patch, but I'm 
hoping it is done before the merge window for inclusion in 3.14.

> None of this will change until you start working with us and actually
> address feedback and inquiries instead of just repeating your talking
> points over and over.
> 

I worked with Michal, who acked my patch, and then wrote another patch on 
top of it based partially on my suggestion, Johannes.
