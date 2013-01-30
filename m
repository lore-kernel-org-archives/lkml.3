Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3A3QiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:38:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab3A3QiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:38:04 -0500
Date: Wed, 30 Jan 2013 17:37:50 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ying Han <yinghan@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>,
        linux-mm@kvack.org, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] mmotm:
 memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
 fix
Message-ID: <20130130163750.GB21253@dhcp22.suse.cz>
References: <20130103180901.GA22067@dhcp22.suse.cz>
 <20130129085104.GA30322@dhcp22.suse.cz>
 <20130130162257.GB21614@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130162257.GB21614@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-01-13 11:22:57, Johannes Weiner wrote:
> On Tue, Jan 29, 2013 at 09:51:04AM +0100, Michal Hocko wrote:
> > Ying has noticed me (via private email) that the patch is bogus because
> > the break out condition is incorrect. She said she would post a fix
> > but she's been probably too busy. If she doesn't oppose, could you add
> > the follow up fix, please?
> > 
> > I am really sorry about this mess.
> > ---
> > >From 6d23b59e96b8173fae2d0d397cb5e99f16899874 Mon Sep 17 00:00:00 2001
> > From: Ying Han <yinghan@google.com>
> > Date: Tue, 29 Jan 2013 09:42:28 +0100
> > Subject: [PATCH] mmotm:
> >  memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
> >  fix
> > 
> > We should break out of the hierarchy loop only if nr_reclaimed exceeded
> > nr_to_reclaim and not vice-versa. This patch fixes the condition.
> > 
> > Signed-off-by: Ying Han <yinghan@google.com>
> > ---
> >  mm/vmscan.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index d75c1ec..7528eae 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1985,7 +1985,7 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
> >  			 * whole hierarchy is not sufficient.
> >  			 */
> >  			if (!global_reclaim(sc) &&
> > -					sc->nr_to_reclaim >= sc->nr_reclaimed) {
> > +					sc->nr_to_reclaim <= sc->nr_reclaimed) {
> 
> This is just a really weird ordering of the operands, isn't it?  You
> compare the constant to the variable, like if (42 == foo->nr_pages).
> 
>     if (sc->nr_reclaimed >= sc->nr_to_reclaim)
> 
> would be less surprising.

No objections from me.
-- 
Michal Hocko
SUSE Labs
