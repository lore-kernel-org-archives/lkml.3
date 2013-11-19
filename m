Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3KSBZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 20:25:19 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:60723 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab3KSBZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 20:25:16 -0500
Date: Mon, 18 Nov 2013 17:25:13 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 2/2] mm, memcg: add memory.oom_control notification for
 system oom
In-Reply-To: <20131118185213.GA12923@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1311181722380.4292@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com> <20131031054942.GA26301@cmpxchg.org> <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com> <20131113233419.GJ707@cmpxchg.org> <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
 <20131114032508.GL707@cmpxchg.org> <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com> <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com> <alpine.DEB.2.02.1311141526300.30112@chino.kir.corp.google.com>
 <20131118185213.GA12923@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, Michal Hocko wrote:

> > A subset of applications that wait on memory.oom_control don't disable
> > the oom killer for that memcg and simply log or cleanup after the kernel
> > oom killer kills a process to free memory.
> > 
> > We need the ability to do this for system oom conditions as well, i.e.
> > when the system is depleted of all memory and must kill a process.  For
> > convenience, this can use memcg since oom notifiers are already present.
> 
> Using the memcg interface for "read-only" interface without any plan for
> the "write" is only halfway solution. We want to handle global OOM in a
> more user defined ways but we have to agree on the proper interface
> first. I do not want to end up with something half baked with memcg and
> a different interface to do the real thing just because memcg turns out
> to be unsuitable.
> 

This patch isn't really a halfway solution, you can still determine if the 
open(O_WRONLY) succeeds or not to determine if that feature has been 
implemented.  I'm concerned about disabling the oom killer entirely for 
system oom conditions, though, so I didn't implement it to be writable.  I 
don't think we should be doing anything special in terms of "write" 
behavior for the root memcg memory.oom_control, so I'd argue against doing 
anything other than disabling the oom killer.  That's scary.
