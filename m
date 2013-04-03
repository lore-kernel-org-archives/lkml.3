Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762096Ab3DCIjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:39:09 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:11629 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761488Ab3DCIjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:39:06 -0400
Message-ID: <515BEA61.9080100@huawei.com>
Date: Wed, 3 Apr 2013 16:37:53 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH -v2] memcg: don't do cleanup manually if mem_cgroup_css_online()
 fails
References: <515A8A40.6020406@huawei.com> <20130402121600.GK24345@dhcp22.suse.cz> <20130402141646.GQ24345@dhcp22.suse.cz> <515AE948.1000704@parallels.com> <20130402142825.GA32520@dhcp22.suse.cz> <515AEC3A.2030401@parallels.com> <20130402150422.GB32520@dhcp22.suse.cz> <515BA6C9.2000704@huawei.com> <20130403074300.GA14384@dhcp22.suse.cz> <515BDEF2.1080900@huawei.com> <20130403081843.GC14384@dhcp22.suse.cz>
In-Reply-To: <20130403081843.GC14384@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> But memcg_update_cache_sizes calls memcg_kmem_clear_activated on the
>>> error path.
>>>
>>
>> But memcg_kmem_mark_dead() checks the ACCOUNT flag not the ACCOUNTED flag.
>> Am I missing something?
>>
> 
> Dang. You are right! Glauber, is there any reason why
> memcg_kmem_mark_dead checks only KMEM_ACCOUNTED_ACTIVE rather than
> KMEM_ACCOUNTED_MASK?
> 
> This all is very confusing to say the least.
> 
> Anyway, this all means that Li's first patch is correct. I am not sure I
> like it though. I think that the refcount cleanup should be done as
> close to where it has been taken as possible otherwise we will end up in
> this "chase the nasty details" again and again. There are definitely two
> bugs here. The one introduced by e4715f01 and the other one introduced
> even earlier (I haven't checked that history yet). I think we should do
> something like the 2 follow up patches but if you guys think that the smaller
> patch from Li is more appropriate then I will not block it.
> 

Or we can queue my patch for 3.9, and then see if we want to change the
tear down process, and if yes we make the change for 3.10.

