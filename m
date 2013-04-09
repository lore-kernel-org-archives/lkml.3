Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936852Ab3DIDNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 23:13:06 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:34386 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934544Ab3DIDND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 23:13:03 -0400
Message-ID: <51638709.207@huawei.com>
Date: Tue, 9 Apr 2013 11:12:09 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH 2/8] cgroup: implement cgroup_from_id()
References: <51627DA9.7020507@huawei.com> <51627DEB.4090104@huawei.com> <20130408154319.GD3021@htj.dyndns.org>
In-Reply-To: <20130408154319.GD3021@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/8 23:43, Tejun Heo wrote:
> On Mon, Apr 08, 2013 at 04:20:59PM +0800, Li Zefan wrote:
>> +/**
>> + * cgroup_from_id - lookup cgroup by id
>> + * @ss: cgroup subsys to be looked into.
>> + * @id: the id
>> + *
>> + * Returns pointer to cgroup if there is valid one with id.
>> + * NULL if not. Should be called under rcu_read_lock()
>> + */
>> +struct cgroup *cgroup_from_id(struct cgroup_subsys *ss, int id)
>> +{
> 
> 	rcu_lockdep_assert(rcu_read_lock_held(), ..
.);

will update

> 
>> +	return idr_find(&ss->root->cgroup_idr, id);

