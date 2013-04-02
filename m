Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab3DBInJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:43:09 -0400
Received: from mx2.parallels.com ([199.115.105.18]:55925 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275Ab3DBInF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:43:05 -0400
Message-ID: <515A9A42.3050908@parallels.com>
Date: Tue, 2 Apr 2013 12:43:46 +0400
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
References: <515A8A40.6020406@huawei.com>
In-Reply-To: <515A8A40.6020406@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 11:35 AM, Li Zefan wrote:
> If memcg_init_kmem() returns -errno when a memcg is being created,
> mem_cgroup_css_online() will decrement memcg and its parent's refcnt,
> (but strangely there's no mem_cgroup_put() for mem_cgroup_get() called
> in memcg_propagate_kmem()).
> 
> But then cgroup core will call mem_cgroup_css_free() to do cleanup...
> 

Not a kmemcg bug, but a real bug. Tested by forcing an ENOMEM condition
to happen manually, and Li patch fixes it.
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Acked-by: Glauber Costa <glommer@parallels.com>
