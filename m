Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946632Ab3BHQlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 11:41:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946537Ab3BHQk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 11:40:58 -0500
Date: Fri, 8 Feb 2013 17:40:56 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Greg Thelen <gthelen@google.com>
Cc: azurIt <azurit@pobox.sk>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM from
 add_to_page_cache_locked
Message-ID: <20130208164056.GG7557@dhcp22.suse.cz>
References: <20130125163130.GF4721@dhcp22.suse.cz>
 <20130205134937.GA22804@dhcp22.suse.cz>
 <20130205154947.CD6411E2@pobox.sk>
 <20130205160934.GB22804@dhcp22.suse.cz>
 <xr93wqum4sh4.fsf@gthelen.mtv.corp.google.com>
 <20130205174651.GA3959@dhcp22.suse.cz>
 <xr93a9ri4op6.fsf@gthelen.mtv.corp.google.com>
 <20130205185953.GB3959@dhcp22.suse.cz>
 <xr93ip63ig6j.fsf@gthelen.mtv.corp.google.com>
 <20130208162918.GF7557@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208162918.GF7557@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 08-02-13 17:29:18, Michal Hocko wrote:
[...]
> OK, I have checked the allocator slow path and you are right even
> GFP_KERNEL will not fail. This can lead to similar deadlocks - e.g.
> OOM killed task blocked on down_write(mmap_sem) while the page fault
> handler holding mmap_sem for reading and allocating a new page without
> any progress.

And now that I think about it some more it sounds like it shouldn't be
possible because allocator would fail because it would see
TIF_MEMDIE (OOM killer kills all threads that share the same mm).
But maybe there are other locks that are dangerous, but I think that the
risk is pretty low.
-- 
Michal Hocko
SUSE Labs
