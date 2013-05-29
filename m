Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966030Ab3E2NFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:05:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935120Ab3E2NFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:05:41 -0400
Date: Wed, 29 May 2013 15:05:38 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>,
        Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch v3 -mm 1/3] memcg: integrate soft reclaim tighter with
 zone shrinking code
Message-ID: <20130529130538.GD10224@dhcp22.suse.cz>
References: <20130517160247.GA10023@cmpxchg.org>
 <1369674791-13861-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369674791-13861-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 27-05-13 19:13:08, Michal Hocko wrote:
[...]
> Nevertheless I have encountered an issue while testing the huge number
> of groups scenario. And the issue is not limitted to only to this
> scenario unfortunately. As memcg iterators use per node-zone-priority
> cache to prevent from over reclaim it might quite easily happen that
> the walk will not visit all groups and will terminate the loop either
> prematurely or skip some groups. An example could be the direct reclaim
> racing with kswapd. This might cause that the loop misses over limit
> groups so no pages are scanned and so we will fall back to all groups
> reclaim.

And after some more testing and head scratching it turned out that
fallbacks to pass#2 I was seeing are caused by something else. It is
not race between iterators but rather reclaiming from zone DMA which
has troubles to scan anything despite there are pages on LRU and so we
fall back. I have to look into that more but what-ever the issue is it
shouldn't be related to the patch series.
-- 
Michal Hocko
SUSE Labs
