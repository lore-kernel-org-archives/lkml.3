Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab3HEEJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 00:09:53 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:47434 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3HEEJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 00:09:52 -0400
Message-ID: <51FF2560.8020206@huawei.com>
Date: Mon, 5 Aug 2013 12:09:04 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        Aristeu Rozanski <aris@redhat.com>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <containers@lists.linux-foundation.org>
Subject: Re: [PATCH cgroup/for-3.12] cgroup: make css_for_each_descendant()
 and friends include the origin css in the iteration
References: <20130804230703.GA12029@htj.dyndns.org>
In-Reply-To: <20130804230703.GA12029@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Previously, all css descendant iterators didn't include the origin
> (root of subtree) css in the iteration.  The reasons were maintaining
> consistency with css_for_each_child() and that at the time of
> introduction more use cases needed skipping the origin anyway;
> however, given that css_is_descendant() considers self to be a
> descendant, omitting the origin css has become more confusing and
> looking at the accumulated use cases rather clearly indicates that
> including origin would result in simpler code overall.
> 
> While this is a change which can easily lead to subtle bugs, cgroup
> API including the iterators has recently gone through major
> restructuring and no out-of-tree changes will be applicable without
> adjustments making this a relatively acceptable opportunity for this
> type of change.
> 
> The conversions are mostly straight-forward.  If the iteration block
> had explicit origin handling before or after, it's moved inside the
> iteration.  If not, if (pos == origin) continue; is added.  Some
> conversions add extra reference get/put around origin handling by
> consolidating origin handling and the rest.  While the extra ref
> operations aren't strictly necessary, this shouldn't cause any
> noticeable difference.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Matt Helsley <matthltc@us.ibm.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: Aristeu Rozanski <aris@redhat.com>

I was wondering this would be better when I converted cgroup_cfts_commits()
to use this iterator.

Acked-by: Li Zefan <lizefan@huawei.com>

