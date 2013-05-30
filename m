Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380Ab3E3PHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:07:55 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:60665 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab3E3PHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:07:46 -0400
Date: Thu, 30 May 2013 17:07:42 +0200
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: add oom killer delay
Message-ID: <20130530150539.GA18155@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 29-05-13 18:18:10, David Rientjes wrote:
> Completely disabling the oom killer for a memcg is problematic if
> userspace is unable to address the condition itself, usually because it
> is unresponsive. 

Isn't this a bug in the userspace oom handler? Why is it unresponsive? It
shouldn't allocated any memory so nothing should prevent it from running (if
other tasks are preempting it permanently then the priority of the handler
should be increased).

> This scenario creates a memcg deadlock: tasks are
> sitting in TASK_KILLABLE waiting for the limit to be increased, a task to
> exit or move, or the oom killer reenabled and userspace is unable to do
> so.
>
> An additional possible use case is to defer oom killing within a memcg
> for a set period of time, probably to prevent unnecessary kills due to
> temporary memory spikes, before allowing the kernel to handle the
> condition.

I am not sure I like the idea. How does an admin decide what is the right value
of the timeout? And why he cannot use userspace oom handler to do the same
thing?

[...]
-- 
Michal Hocko
SUSE Labs
