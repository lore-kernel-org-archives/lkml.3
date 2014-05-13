Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaEMQq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:46:27 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:48754 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaEMQqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:46:22 -0400
Date: Tue, 13 May 2014 12:46:19 -0400
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org
Subject: Re: [PATCH 02/14] cgroup: remove pointless has tasks/children test
 from mem_cgroup_force_empty()
Message-ID: <20140513164619.GD1866@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-3-git-send-email-tj@kernel.org>
 <20140512145324.GE9564@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512145324.GE9564@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 04:53:24PM +0200, Michal Hocko wrote:
> From 03f8cb2e1fd2636d859c54df9b58719fe96e0e54 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Mon, 12 May 2014 16:34:17 +0200
> Subject: [PATCH] memcg: remove tasks/children test from from
>  mem_cgroup_force_empty
> 
> Tejun has correctly pointed out that tasks/children test in
> mem_cgroup_force_empty is not correct because there is no other locking
> which preserves this state throughout the rest of the function so both
> new tasks can join the group or new children groups can be added while
> somebody is writing to memory.force_empty. A new task would break
> mem_cgroup_reparent_charges expectation that all failures as described
> by mem_cgroup_force_empty_list are temporal and there is no way out.
> 
> The main use case for the knob as described by
> Documentation/cgroups/memory.txt is to:
> "
>   The typical use case for this interface is before calling rmdir().
>   Because rmdir() moves all pages to parent, some out-of-use page caches can be
>   moved to the parent. If you want to avoid that, force_empty will be useful.
> "
> 
> This means that reparenting is not really required as rmdir will
> reparent pages implicitly from the safe context. If we remove it from
> mem_cgroup_force_empty then we are safe even with existing tasks because
> the number of reclaim attempts is bounded. Moreover the knob still does
> what the documentation claims (modulo reparenting which doesn't make any
> difference) and users might expect. Longterm we want to deprecate the
> whole knob and put the reparented pages to the tail of parent LRU during
> cgroup removal.

Replaced the original patch with this one with Johannes' ack added.

Thanks!

-- 
tejun
