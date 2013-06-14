Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab3FNBSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 21:18:09 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:44950 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab3FNBSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 21:18:08 -0400
Message-ID: <51BA6F34.30001@huawei.com>
Date: Fri, 14 Jun 2013 09:17:40 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v3 5/9] memcg: use css_get/put when charging/uncharging
 kmem
References: <51B98D17.2050902@huawei.com> <20130613155319.GJ23070@dhcp22.suse.cz>
In-Reply-To: <20130613155319.GJ23070@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
>>  {
>> +	/*
>> +	 * We need to call css_get() first, because memcg_uncharge_kmem()
>> +	 * will call css_put() if it sees the memcg is dead.
>> +	 */
>> +	smb_wmb();
>>  	if (test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags))
>>  		set_bit(KMEM_ACCOUNTED_DEAD, &memcg->kmem_account_flags);
> 
> I do not feel strongly about that but maybe open coding this in
> mem_cgroup_css_offline would be even better. There is only single caller
> and there is smaller chance somebody will use the function incorrectly
> later on.
> 
> So I leave the decision on you because this doesn't matter much.
> 

Yeah, it should go away soon. I'll post a patch after this patchset gets
merged into -mm tree and then we can discuss there.

