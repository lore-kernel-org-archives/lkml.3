Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbbAIMvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:51:23 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:56894 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbbAIMvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:51:22 -0500
Date: Fri, 9 Jan 2015 07:51:09 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vmscan: force scan offline memory cgroups
Message-ID: <20150109125109.GA14475@phnom.home.cmpxchg.org>
References: <20150108170349.GA32079@phnom.home.cmpxchg.org>
 <1420790983-20270-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420790983-20270-1-git-send-email-vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 11:09:43AM +0300, Vladimir Davydov wrote:
> Since commit b2052564e66d ("mm: memcontrol: continue cache reclaim from
> offlined groups") pages charged to a memory cgroup are not reparented
> when the cgroup is removed. Instead, they are supposed to be reclaimed
> in a regular way, along with pages accounted to online memory cgroups.
> 
> However, an lruvec of an offline memory cgroup will sooner or later get
> so small that it will be scanned only at low scan priorities (see
> get_scan_count()). Therefore, if there are enough reclaimable pages in
> big lruvecs, pages accounted to offline memory cgroups will never be
> scanned at all, wasting memory.
> 
> Fix this by unconditionally forcing scanning dead lruvecs from kswapd.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Looks good to me now, thank you.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
