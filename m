Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936720Ab3DIDCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 23:02:33 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:22700 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934408Ab3DIDCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 23:02:32 -0400
Message-ID: <51638463.70009@huawei.com>
Date: Tue, 9 Apr 2013 11:00:51 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH 4/8] memcg: convert to use cgroup_from_id()
References: <51627DA9.7020507@huawei.com> <51627E09.5010605@huawei.com> <20130408145333.GL17178@dhcp22.suse.cz>
In-Reply-To: <20130408145333.GL17178@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/8 22:53, Michal Hocko wrote:
> On Mon 08-04-13 16:21:29, Li Zefan wrote:
>> This is a preparation to kill css_id.
>>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
> 
> I would be tempted to stuff this into the same patch which introduces
> cgroup_from_id but this is just a minor thing.
> 

yeah it's not a big deal, just want to separate changes to cgroup and memcg.

> Acked-by: Michal Hocko <mhocko@suse.cz>
> 
>> ---
>>  mm/memcontrol.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 14f1375..3561d0b 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2769,15 +2769,15 @@ static void __mem_cgroup_cancel_local_charge(struct mem_cgroup *memcg,
>>   */
>>  static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
>>  {
>> -	struct cgroup_subsys_state *css;
>> +	struct cgroup *cgrp;
>>  
>>  	/* ID 0 is unused ID */
>>  	if (!id)
>>  		return NULL;
>> -	css = css_lookup(&mem_cgroup_subsys, id);
>> -	if (!css)
>> +	cgrp = cgroup_from_id(&mem_cgroup_subsys, id);
>> +	if (!cgrp)
>>  		return NULL;
>> -	return mem_cgroup_from_css(css);
>> +	return mem_cgroup_from_cont(cgrp);
>>  }
>>  
>>  struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
>> -- 
>> 1.8.0.2

