Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab3LQIMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:12:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab3LQIMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:12:05 -0500
Date: Tue, 17 Dec 2013 09:12:02 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@gmail.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, devel@openvz.org,
        Glauber Costa <glommer@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] memcg: fix memcg_size() calculation
Message-ID: <20131217081202.GA26640@dhcp22.suse.cz>
References: <965cbb70fb55fe50a77382537b9a1b7455deac86.1387007793.git.vdavydov@parallels.com>
 <20131216164730.GD26797@dhcp22.suse.cz>
 <CAA6-i6rX7-F9UO2DO3gwC2SHNuSv2Fn48eLb1BZmc3HjCkbuvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA6-i6rX7-F9UO2DO3gwC2SHNuSv2Fn48eLb1BZmc3HjCkbuvQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 17-12-13 11:48:20, Glauber Costa wrote:
> On Mon, Dec 16, 2013 at 8:47 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > On Sat 14-12-13 12:15:33, Vladimir Davydov wrote:
> >> The mem_cgroup structure contains nr_node_ids pointers to
> >> mem_cgroup_per_node objects, not the objects themselves.
> >
> > Ouch! This is 2k per node which is wasted. What a shame I haven't
> > noticed this back then when reviewing 45cf7ebd5a033 (memcg: reduce the
> > size of struct memcg 244-fold)
> >
> IIRC, they weren't pointers back then. I think they were embedded in
> the structure, and I let
> them embedded.
> My mind may be tricking me, but I think I recall that Johannes changed
> them to pointers
> in a later time. No ?

It was wrapped by mem_cgroup_lru_info back then but the memcg_size
hasn't changed after 54f72fe022d9 (memcg: clean up memcg->nodeinfo) so
the missing * was there since 45cf7ebd5a033

> In any case, this is correct.

-- 
Michal Hocko
SUSE Labs
