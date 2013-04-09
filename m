Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936769Ab3DIC6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:58:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33538 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934602Ab3DIC6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:58:10 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <516383AD.9010305@jp.fujitsu.com>
Date: Tue, 09 Apr 2013 11:57:49 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 12/12] memcg: don't need to free memcg via RCU or workqueue
References: <5162648B.9070802@huawei.com> <51626570.8000400@huawei.com>
In-Reply-To: <51626570.8000400@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/08 15:36), Li Zefan wrote:
> Now memcg has the same life cycle with its corresponding cgroup, and
> a cgroup is freed via RCU and then mem_cgroup_css_free() is called
> in a work function, so we can simply call __mem_cgroup_free() in
> mem_cgroup_css_free().
> 
> This actually reverts 59927fb984de1703c67bc640c3e522d8b5276c73
> ("memcg: free mem_cgroup by RCU to fix oops").
> 
> Cc: Hugh Dickins <hughd@google.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Very nice.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



