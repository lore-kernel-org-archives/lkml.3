Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaKDIh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:37:26 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51916 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaKDIhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:37:25 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <54589017.9060604@jp.fujitsu.com>
Date: Tue, 4 Nov 2014 17:36:39 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>,
        Tejun Heo <tj@kernel.org>, David Miller <davem@davemloft.net>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct
 page
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/02 12:15), Johannes Weiner wrote:
> Memory cgroups used to have 5 per-page pointers.  To allow users to
> disable that amount of overhead during runtime, those pointers were
> allocated in a separate array, with a translation layer between them
> and struct page.
> 
> There is now only one page pointer remaining: the memcg pointer, that
> indicates which cgroup the page is associated with when charged.  The
> complexity of runtime allocation and the runtime translation overhead
> is no longer justified to save that *potential* 0.19% of memory.  With
> CONFIG_SLUB, page->mem_cgroup actually sits in the doubleword padding
> after the page->private member and doesn't even increase struct page,
> and then this patch actually saves space.  Remaining users that care
> can still compile their kernels without CONFIG_MEMCG.
> 
>     text    data     bss     dec     hex     filename
> 8828345 1725264  983040 11536649 b00909  vmlinux.old
> 8827425 1725264  966656 11519345 afc571  vmlinux.new
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>   include/linux/memcontrol.h  |   6 +-
>   include/linux/mm_types.h    |   5 +
>   include/linux/mmzone.h      |  12 --
>   include/linux/page_cgroup.h |  53 --------
>   init/main.c                 |   7 -
>   mm/memcontrol.c             | 124 +++++------------
>   mm/page_alloc.c             |   2 -
>   mm/page_cgroup.c            | 319 --------------------------------------------
>   8 files changed, 41 insertions(+), 487 deletions(-)
> 

Great! 
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

BTW, init/Kconfig comments shouldn't be updated ?
(I'm sorry if it has been updated since your latest fix.)




