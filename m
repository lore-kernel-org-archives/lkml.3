Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab3BESBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:01:35 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:39194 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283Ab3BESBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:01:32 -0500
Date: Tue, 5 Feb 2013 13:01:16 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/3] memcg: move mem_cgroup_soft_limit_tree_init to
 mem_cgroup_init
Message-ID: <20130205180116.GA993@cmpxchg.org>
References: <1360081441-1960-1-git-send-email-mhocko@suse.cz>
 <1360081441-1960-2-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360081441-1960-2-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 05:23:59PM +0100, Michal Hocko wrote:
> Per-node-zone soft limit tree is currently initialized when the root
> cgroup is created which is OK but it pointlessly pollutes memcg
> allocation code with something that can be called when the memcg
> subsystem is initialized by mem_cgroup_init along with other controller
> specific parts.
> 
> While we are at it let's make mem_cgroup_soft_limit_tree_init void
> because it doesn't make much sense to report memory failure because if
> we fail to allocate memory that early during the boot then we are
> screwed anyway (this saves some code).
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
