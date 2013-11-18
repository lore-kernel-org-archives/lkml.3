Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab3KRSwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:52:22 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:56702 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab3KRSwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:52:17 -0500
Date: Mon, 18 Nov 2013 19:52:13 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 2/2] mm, memcg: add memory.oom_control notification for
 system oom
Message-ID: <20131118185213.GA12923@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com>
 <20131031054942.GA26301@cmpxchg.org>
 <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com>
 <20131113233419.GJ707@cmpxchg.org>
 <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
 <20131114032508.GL707@cmpxchg.org>
 <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1311141526300.30112@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311141526300.30112@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 14-11-13 15:26:55, David Rientjes wrote:
> A subset of applications that wait on memory.oom_control don't disable
> the oom killer for that memcg and simply log or cleanup after the kernel
> oom killer kills a process to free memory.
> 
> We need the ability to do this for system oom conditions as well, i.e.
> when the system is depleted of all memory and must kill a process.  For
> convenience, this can use memcg since oom notifiers are already present.

Using the memcg interface for "read-only" interface without any plan for
the "write" is only halfway solution. We want to handle global OOM in a
more user defined ways but we have to agree on the proper interface
first. I do not want to end up with something half baked with memcg and
a different interface to do the real thing just because memcg turns out
to be unsuitable.

And to be honest, the more I am thinking about memcg based interface the
stronger is my feeling that it is unsuitable for the user defined OOM
policies. But that should be discussed properly (I will send a RFD in
the follow up days).

[...]
-- 
Michal Hocko
SUSE Labs
