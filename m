Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3G3OWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:22:05 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:43721 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab3G3OWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:22:04 -0400
Date: Tue, 30 Jul 2013 10:21:59 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH v3 1/8] cgroup: convert cgroup_ida to cgroup_idr
Message-ID: <20130730142159.GI12016@htj.dyndns.org>
References: <51F614B2.6010503@huawei.com>
 <51F614C4.7060602@huawei.com>
 <20130729182835.GD26076@mtj.dyndns.org>
 <51F7127B.1070107@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F7127B.1070107@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 09:10:19AM +0800, Li Zefan wrote:
> Set cgrp->id to 0? No, 0 is a valid id. The if is here because at first

I don't know.  -1 then?

> I called idr_alloc() very late in cgroup_create(), so cgroup_offline_fn()
> can be called while cgrp->id hasn't been initialized. Now I can remove
> this check.

I'm just a bit apprehensive as IDs will be recycled very fast and
controllers would keep accessing the css and cgroup after offline
until all refs are drained, so it'd be nice if there's some mechanism
to prevent / detect stale ID usages.

Thanks.

-- 
tejun
