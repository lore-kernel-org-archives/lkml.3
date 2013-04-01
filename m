Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab3DAFDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 01:03:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51327 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab3DAFDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 01:03:50 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <5159151E.9070204@jp.fujitsu.com>
Date: Mon, 01 Apr 2013 14:03:26 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: take reference before releasing rcu_read_lock
References: <51556CE9.9060000@huawei.com>
In-Reply-To: <51556CE9.9060000@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/03/29 19:28), Li Zefan wrote:
> The memcg is not referenced, so it can be destroyed at anytime right
> after we exit rcu read section, so it's not safe to access it.
> 
> To fix this, we call css_tryget() to get a reference while we're still
> in rcu read section.
> 
> This also removes a bogus comment above __memcg_create_cache_enqueue().
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


