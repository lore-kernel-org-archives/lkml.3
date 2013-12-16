Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3LPQfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:35:46 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:52368 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab3LPQfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:35:42 -0500
Date: Mon, 16 Dec 2013 11:35:30 -0500
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.13-rc breaks MEMCG_SWAP
Message-ID: <20131216163530.GH32509@htj.dyndns.org>
References: <alpine.LNX.2.00.1312160025200.2785@eggly.anvils>
 <52AEC989.4080509@huawei.com>
 <20131216095345.GB23582@dhcp22.suse.cz>
 <20131216104042.GC23582@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216104042.GC23582@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 11:40:42AM +0100, Michal Hocko wrote:
> > How would this work? The task which pushed the memory to the swap is
> > still alive (living in a different group) and the swap will be there
> > after the last reference to css as well.
> 
> Or did you mean to get css reference in swap_cgroup_record and release
> it in __mem_cgroup_try_charge_swapin?
> 
> That would prevent the warning (assuming idr_remove would move to
> css_free[1]) but I am not sure this is the right thing to do. memsw charges
> will be accounted to the parent already (assuming there is one) without
> anybody to uncharge them because all uncharges would fallback to the
> root memcg after css_offline.
> 
> Hugh's approach seems much better.

Hmmm... I think it's reasonable for css's to expect cgrp->id to not be
recycled before all css refs are gone.  If Hugh's patches are
something desriable independent of cgrp->id issues, great, but, if
not, let's first try to get it right from cgroup core.  Is it enough
for css_from_id() to return NULL after offline until all refs are
gone?  That should be an easy fix.

Thanks.

-- 
tejun
