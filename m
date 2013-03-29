Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3C2KsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 06:48:06 -0400
Received: from mx2.parallels.com ([199.115.105.18]:43490 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab3C2KsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 06:48:04 -0400
Message-ID: <5155718A.90108@parallels.com>
Date: Fri, 29 Mar 2013 14:48:42 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: take reference before releasing rcu_read_lock
References: <51556CE9.9060000@huawei.com>
In-Reply-To: <51556CE9.9060000@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2013 02:28 PM, Li Zefan wrote:
> The memcg is not referenced, so it can be destroyed at anytime right
> after we exit rcu read section, so it's not safe to access it.
> 
> To fix this, we call css_tryget() to get a reference while we're still
> in rcu read section.
> 
> This also removes a bogus comment above __memcg_create_cache_enqueue().
> 
Out of curiosity, did you see that happening ?

Theoretically, the race you describe seem real, and the fix is sound.

Acked-by: Glauber Costa <glommer@parallels.com>
