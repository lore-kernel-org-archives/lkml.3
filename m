Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbaDVLsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:48:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589AbaDVLso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:48:44 -0400
Date: Tue, 22 Apr 2014 13:48:39 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>,
        kamezawa.hiroyu@jp.fujitsu.com, Cgroups <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm/memcontrol.c: remove meaningless while loop in
 mem_cgroup_iter()
Message-ID: <20140422114838.GK29311@dhcp22.suse.cz>
References: <1397861935-31595-1-git-send-email-nasa4836@gmail.com>
 <20140422094759.GC29311@dhcp22.suse.cz>
 <CAHz2CGWrk3kuR=BLt2vT-8gxJVtJcj6h17ase9=1CoWXwK6a3w@mail.gmail.com>
 <20140422103420.GI29311@dhcp22.suse.cz>
 <CAHz2CGUZyv-dvUUoSi2Vk_vgPAMqRN4yEg4F4XsKQ8udHeo2bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHz2CGUZyv-dvUUoSi2Vk_vgPAMqRN4yEg4F4XsKQ8udHeo2bQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-04-14 18:58:11, Jianyu Zhan wrote:
[...]
> This reminds me of my draft edition of this patch, I specifically handle
> this case as:
> 
> if (reclaim) {
>                if (!memcg ) {
>                               iter->generation++;
>                               if (!prev) {
>                                     memcg = root;
>                                     mem_cgroup_iter_update(iter, NULL, memcg, root,  seq);
>                                     goto out_unlock:
>                               }
>               }
>               mem_cgroup_iter_update(iter, last_visited, memcg, root,
>                                 seq);
>               if (!prev && memcg)
>                         reclaim->generation = iter->generation;
> }
> 
> This is literally manual unwinding the second while loop, and thus omit
> the while loop,
> to save a   mem_cgroup_iter_update() and a mem_cgroup_iter_update()
> 
> But it maybe a bit hard to read.

Dunno, this particular case is more explicit but it is also uglier so I
do not think this is an overall improvement. I would rather keep the
current state unless the change either simplifies the generated code
or it is much better to read.

Thanks!
-- 
Michal Hocko
SUSE Labs
