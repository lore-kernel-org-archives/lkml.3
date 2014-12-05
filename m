Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbaLEXqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:46:45 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:59448 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbaLEXql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:46:41 -0500
Date: Fri, 5 Dec 2014 15:46:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] oom: don't assume that a coredumping thread will
 exit soon
In-Reply-To: <20141203195020.GB11558@redhat.com>
Message-ID: <alpine.DEB.2.10.1412051546200.2537@chino.kir.corp.google.com>
References: <20141127230349.GA25075@redhat.com> <20141203195001.GA11558@redhat.com> <20141203195020.GB11558@redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014, Oleg Nesterov wrote:

> oom_kill.c assumes that PF_EXITING task should exit and free the memory
> soon. This is wrong in many ways and one important case is the coredump.
> A task can sleep in exit_mm() "forever" while the coredumping sub-thread
> can need more memory.
> 
> Change the PF_EXITING checks to take SIGNAL_GROUP_COREDUMP into account,
> we add the new trivial helper for that.
> 
> Note: this is only the first step, this patch doesn't try to solve other
> problems. The SIGNAL_GROUP_COREDUMP check is obviously racy, a task can
> participate in coredump after it was already observed in PF_EXITING state,
> so TIF_MEMDIE (which also blocks oom-killer) still can be wrongly set.
> fatal_signal_pending() can be true because of SIGNAL_GROUP_COREDUMP so
> out_of_memory() and mem_cgroup_out_of_memory() shouldn't blindly trust it.
> And even the name/usage of the new helper is confusing, an exiting thread
> can only free its ->mm if it is the only/last task in thread group.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>
