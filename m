Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbaEGPOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:14:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbaEGPOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:14:10 -0400
Date: Wed, 7 May 2014 17:14:08 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 5/9] mm: memcontrol: use root_mem_cgroup res_counter
Message-ID: <20140507151408.GK9489@dhcp22.suse.cz>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-6-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398889543-23671-6-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-04-14 16:25:39, Johannes Weiner wrote:
> The root_mem_cgroup res_counter is never charged itself: there is no
> limit at the root level anyway, and any statistics are generated on
> demand by summing up the counters of all other cgroups.  This was an
> optimization to keep down costs on systems that don't create specific
> cgroups, but with per-cpu charge caches the res_counter operations do
> not even show up on in profiles anymore.  Just remove it and simplify
> the code.

It seems that only kmem and tcp thingy are left but those looks much
harder and they are not directly related.

root_mem_cgroup use also seems to be correct.

I have to look at this closer and that will be no sooner than on Monday
as I am off for the rest of the week.
[...]
-- 
Michal Hocko
SUSE Labs
