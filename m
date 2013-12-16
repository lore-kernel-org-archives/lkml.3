Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3LPRV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:21:57 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:36220 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3LPRVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:21:55 -0500
Date: Mon, 16 Dec 2013 12:21:43 -0500
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.13-rc breaks MEMCG_SWAP
Message-ID: <20131216172143.GJ32509@htj.dyndns.org>
References: <alpine.LNX.2.00.1312160025200.2785@eggly.anvils>
 <52AEC989.4080509@huawei.com>
 <20131216095345.GB23582@dhcp22.suse.cz>
 <20131216104042.GC23582@dhcp22.suse.cz>
 <20131216163530.GH32509@htj.dyndns.org>
 <20131216171937.GG26797@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216171937.GG26797@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Dec 16, 2013 at 06:19:37PM +0100, Michal Hocko wrote:
> I have to think about it some more (the brain is not working anymore
> today). But what we really need is that nobody gets the same id while
> the css is alive. So css_from_id returning NULL doesn't seem to be
> enough.

Oh, I meant whether it's necessary to keep css_from_id() working
(ie. doing successful lookups) between offline and release, because
that's where lifetimes are coupled.  IOW, if it's enough for cgroup to
not recycle the ID until all css's are released && fail css_from_id()
lookup after the css is offlined, I can make a five liner quick fix.

Thanks.

-- 
tejun
