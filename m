Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaIXREi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:04:38 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:16741 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaIXREg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:04:36 -0400
X-CheckPoint: {5422F9A4-2-2100090A-C0000000}
Message-ID: <5422F9A3.2010303@tilera.com>
Date: Wed, 24 Sep 2014 13:04:35 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, <akpm@linux-foundation.org>
CC: <kirill.shutemov@linux.intel.com>, <khlebnikov@openvz.org>,
        <riel@redhat.com>, <mgorman@suse.de>, <n-horiguchi@ah.jp.nec.com>,
        <mhocko@suse.cz>, <hughd@google.com>, <vbabka@suse.cz>,
        <walken@google.com>, <minchan@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH 2/3] mm: introduce VM_BUG_ON_MM
References: <1410032326-4380-1-git-send-email-sasha.levin@oracle.com> <1410032326-4380-2-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1410032326-4380-2-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/6/2014 3:40 PM, Sasha Levin wrote:
> Very similar to VM_BUG_ON_PAGE and VM_BUG_ON_VMA, dump struct_mm
> when the bug is hit.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>   include/linux/mmdebug.h |   10 +++++++
>   mm/debug.c              |   69 +++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 79 insertions(+)
>
> [...]
> diff --git a/mm/debug.c b/mm/debug.c
> index c19af12..8418893 100644
> --- a/mm/debug.c
> +++ b/mm/debug.c
> +#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
> +		"tlb_flush_pending %d\n",
> +#endif

Putting the comma that separates the format string from the arguments
inside an ifdef means that if you don't build with NUMA_BALANCING or
COMPACTION you get a compile error.  Perhaps this instead:

+#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
+		"tlb_flush_pending %d\n"
+#endif
-		mm, mm->mmap, mm->vmacache_seqnum, mm->task_size,
+		, mm, mm->mmap, mm->vmacache_seqnum, mm->task_size,

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
