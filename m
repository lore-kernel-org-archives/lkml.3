Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab3KSNOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:14:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab3KSNOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:14:02 -0500
Date: Tue, 19 Nov 2013 14:14:00 +0100
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: Greg Thelen <gthelen@google.com>, Glauber Costa <glommer@gmail.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        Joern Engel <joern@logfs.org>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: user defined OOM policies
Message-ID: <20131119131400.GC20655@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
it's been quite some time since LSFMM 2013 when this has been
discussed[1]. In short, it seems that there are usecases with a
strong demand on a better user/admin policy control for the global
OOM situations. Per process oom_{adj,score} which is used for the
prioritizing is no longer sufficient because there are other categories
which might be important. For example, often it doesn't make sense to
kill just a part of the workload and killing the whole group would be a
better fit. I am pretty sure there are many others some of them workload
specific and thus not appropriate for the generic implementation.

We have basically ended up with 3 options AFAIR:
	1) allow memcg approach (memcg.oom_control) on the root level
           for both OOM notification and blocking OOM killer and handle
           the situation from the userspace same as we can for other
	   memcgs.
	2) allow modules to hook into OOM killer path and take the
	   appropriate action.
	3) create a generic filtering mechanism which could be
	   controlled from the userspace by a set of rules (e.g.
	   something analogous to packet filtering).

As there was no real follow up discussion after the conference I would
like to open it here on the mailing list again and try to get to some
outcome.

I will follow up with some of my ideas but lets keep this post clean and
short for starter. Also if there are other ideas, please go ahead...

I wasn't sure who was present in the room and interested in the
discussion so I am putting random people I remember...

Ideas?

Thanks

---
[1] http://lwn.net/Articles/548180/
-- 
Michal Hocko
SUSE Labs
