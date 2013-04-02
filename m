Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750Ab3DBIGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:06:37 -0400
Received: from mx2.parallels.com ([199.115.105.18]:57359 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509Ab3DBIGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:06:34 -0400
Message-ID: <515A91B4.3090607@parallels.com>
Date: Tue, 2 Apr 2013 12:07:16 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: don't do cleanup manually if mem_cgroup_css_online()
 fails
References: <515A8A40.6020406@huawei.com> <515A90ED.7010208@huawei.com>
In-Reply-To: <515A90ED.7010208@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 12:03 PM, Li Zefan wrote:
> On 2013/4/2 15:35, Li Zefan wrote:
>> If memcg_init_kmem() returns -errno when a memcg is being created,
>> mem_cgroup_css_online() will decrement memcg and its parent's refcnt,
> 
>> (but strangely there's no mem_cgroup_put() for mem_cgroup_get() called
>> in memcg_propagate_kmem()).
> 
> The comment in memcg_propagate_kmem() suggests it knows mem_cgroup_css_free()
> will be called in failure, while mem_cgroup_css_online() doesn't know.
> 
This is a bit suspicious. At first your analysis seems fair, but I've
extensively tested memcg teardown process with kmemcg (and even
uncovered some bugs at that), and it works when and how expected.

Also, note that this teardown code long predates kmemcg.

I am not saying your are wrong - on the contrary, you seem to be right,
but I think this one needs to be handled with extra care. I will run
some tests, take a look, and get back to you.

