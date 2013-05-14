Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab3ENOwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:52:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477Ab3ENOwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:52:53 -0400
Date: Tue, 14 May 2013 16:52:52 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: don't initialize kmem-cache destroying work for
 root caches
Message-ID: <20130514145252.GT5198@dhcp22.suse.cz>
References: <1368535118-27369-1-git-send-email-avagin@openvz.org>
 <20130514144031.GR5198@dhcp22.suse.cz>
 <20130514144427.GS5198@dhcp22.suse.cz>
 <51924EE3.9020708@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51924EE3.9020708@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 14-05-13 18:49:07, Glauber Costa wrote:
> On 05/14/2013 06:44 PM, Michal Hocko wrote:
> > On Tue 14-05-13 16:40:31, Michal Hocko wrote:
> >> On Tue 14-05-13 16:38:38, Andrey Vagin wrote:
> >>> struct memcg_cache_params has a union. Different parts of this union are
> >>> used for root and non-root caches. A part with destroying work is used only
> >>> for non-root caches.
> >>
> >> but memcg_update_cache_size is called only for !root caches AFAICS
> >> (check memcg_update_all_caches)
> > 
> > Ohh, I am blind. memcg_update_all_caches skips all !root caches.
> > Then the patch looks correct. If Glauber has nothing against then thise
> > should be marked for stable (3.9)
> > 
> This was recently introduced by the commit that moved the initialization
> earlier (15cf17d26e08ee9). It basically moved too much, and I didn't
> catch it. If that patch is in 3.9, then yes, this needs to go to stable.
> Otherwise it is not affected.

git describe tells it was merged in v3.9-rc2~7

> However, I do remember Andrey telling me that he hit this bug in both
> 3.9 and 3.10-rc1, so yes, stable it is.

-- 
Michal Hocko
SUSE Labs
