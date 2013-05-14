Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab3ENOoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:44:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab3ENOo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:44:29 -0400
Date: Tue, 14 May 2013 16:44:27 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: don't initialize kmem-cache destroying work for
 root caches
Message-ID: <20130514144427.GS5198@dhcp22.suse.cz>
References: <1368535118-27369-1-git-send-email-avagin@openvz.org>
 <20130514144031.GR5198@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514144031.GR5198@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 14-05-13 16:40:31, Michal Hocko wrote:
> On Tue 14-05-13 16:38:38, Andrey Vagin wrote:
> > struct memcg_cache_params has a union. Different parts of this union are
> > used for root and non-root caches. A part with destroying work is used only
> > for non-root caches.
> 
> but memcg_update_cache_size is called only for !root caches AFAICS
> (check memcg_update_all_caches)

Ohh, I am blind. memcg_update_all_caches skips all !root caches.
Then the patch looks correct. If Glauber has nothing against then thise
should be marked for stable (3.9)
-- 
Michal Hocko
SUSE Labs
