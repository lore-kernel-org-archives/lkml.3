Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054Ab3BMKiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:38:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab3BMKiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:38:13 -0500
Date: Wed, 13 Feb 2013 11:38:11 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Tejun Heo <htejun@gmail.com>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v3 4/7] memcg: remove memcg from the reclaim iterators
Message-ID: <20130213103811.GC23562@dhcp22.suse.cz>
References: <20130211223943.GC15951@cmpxchg.org>
 <20130212095419.GB4863@dhcp22.suse.cz>
 <20130212151002.GD15951@cmpxchg.org>
 <20130212154330.GG4863@dhcp22.suse.cz>
 <20130212161332.GI4863@dhcp22.suse.cz>
 <20130212162442.GJ4863@dhcp22.suse.cz>
 <63d3b5fa-dbc6-4bc9-8867-f9961e644305@email.android.com>
 <20130212171216.GA17663@dhcp22.suse.cz>
 <20130212173741.GD25235@cmpxchg.org>
 <511B4ACF.90209@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511B4ACF.90209@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 13-02-13 12:11:59, Glauber Costa wrote:
> On 02/12/2013 09:37 PM, Johannes Weiner wrote:
> >> > All reads from root->dead_count are atomic already, so I am not sure
> >> > what you mean here. Anyway, I hope I won't make this even more confusing
> >> > if I post what I have right now:
> > Yes, but we are doing two reads.  Can't the memcg that we'll store in
> > last_visited be offlined during this and be freed after we drop the
> > rcu read lock?  If we had just one read, we would detect this
> > properly.
> > 
> 
> I don't want to add any more confusion to an already fun discussion, but
> IIUC, you are trying to avoid triggering a second round of reclaim in an
> already dead memcg, right?

No this is not about the second round of the reclaim but rather
iteration racing with removal. And we want to do it as lightweight as
possible. We cannot work with memcg directly because it might have
disappeared in the mean time and we do not want to hold a reference on
it because there would be no guarantee somebody will release it later
on. So mark_dead && test_and_clear_dead would not work in this context.
[...]
-- 
Michal Hocko
SUSE Labs
