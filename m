Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab3FLUty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:49:54 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64575 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab3FLUtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:49:50 -0400
Date: Wed, 12 Jun 2013 13:49:47 -0700 (PDT)
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
In-Reply-To: <20130612203705.GB17282@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1306121343500.24902@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1306052058340.25115@chino.kir.corp.google.com> <20130606053315.GB9406@cmpxchg.org> <20130606173355.GB27226@cmpxchg.org> <alpine.DEB.2.02.1306061308320.9493@chino.kir.corp.google.com> <20130606215425.GM15721@cmpxchg.org>
 <alpine.DEB.2.02.1306061507330.15503@chino.kir.corp.google.com> <20130607000222.GT15576@cmpxchg.org> <alpine.DEB.2.02.1306111454030.4803@chino.kir.corp.google.com> <20130612082817.GA6706@dhcp22.suse.cz> <alpine.DEB.2.02.1306121309500.23348@chino.kir.corp.google.com>
 <20130612203705.GB17282@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013, Michal Hocko wrote:

> The patch is a big improvement with a minimum code overhead. Blocking
> any task which sits on top of an unpredictable amount of locks is just
> broken. So regardless how many users are affected we should merge it and
> backport to stable trees. The problem is there since ever. We seem to
> be surprisingly lucky to not hit this more often.
> 

Right now it appears that that number of users is 0 and we're talking 
about a problem that was reported in 3.2 that was released a year and a 
half ago.  The rules of inclusion in stable also prohibit such a change 
from being backported, specifically "It must fix a real bug that bothers 
people (not a, "This could be a problem..." type thing)".

We have deployed memcg on a very large number of machines and I can run a 
query over all software watchdog timeouts that have occurred by 
deadlocking on i_mutex during memcg oom.  It returns 0 results.

> I am not quite sure I understand your reservation about the patch to be
> honest. Andrew still hasn't merged this one although 1/2 is in.

Perhaps he is as unconvinced?  The patch adds 100 lines of code, including 
fields to task_struct for memcg, for a problem that nobody can reproduce.  
My question still stands: can anybody, even with an instrumented kernel to 
make it more probable, reproduce the issue this is addressing?
