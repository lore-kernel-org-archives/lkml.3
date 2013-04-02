Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761128Ab3DBOUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:20:17 -0400
Received: from mx2.parallels.com ([199.115.105.18]:45294 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761035Ab3DBOUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:20:15 -0400
Message-ID: <515AE948.1000704@parallels.com>
Date: Tue, 2 Apr 2013 18:20:56 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: don't do cleanup manually if mem_cgroup_css_online()
 fails
References: <515A8A40.6020406@huawei.com> <20130402121600.GK24345@dhcp22.suse.cz> <20130402141646.GQ24345@dhcp22.suse.cz>
In-Reply-To: <20130402141646.GQ24345@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 06:16 PM, Michal Hocko wrote:
>  mem_cgroup_css_online
>       memcg_init_kmem
>         mem_cgroup_get		# refcnt = 2
>           memcg_update_all_caches
>             memcg_update_cache_size	# fails with ENOMEM

Here is the thing: this one in kmem only happens for kmem enabled
memcgs. For those, we tend to do a get once, and put only when the last
kmem reference is gone.

For non-kmem memcgs, refcnt will be 1 here, and will be balanced out by
the mem_cgroup_put() in css_free.

