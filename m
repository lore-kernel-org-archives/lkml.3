Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaGHDy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 23:54:57 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:21729 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751170AbaGHDyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 23:54:55 -0400
X-IronPort-AV: E=Sophos;i="5.00,854,1396972800"; 
   d="scan'208";a="32974112"
Message-ID: <53BB6B64.1080807@cn.fujitsu.com>
Date: Tue, 8 Jul 2014 11:54:12 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v10 1/7] mm: support madvise(MADV_FREE)
References: <1404694438-10272-1-git-send-email-minchan@kernel.org> <1404694438-10272-2-git-send-email-minchan@kernel.org>
In-Reply-To: <1404694438-10272-2-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.225.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

On 07/07/2014 08:53 AM, Minchan Kim wrote:
> Linux doesn't have an ability to free pages lazy while other OS
> already have been supported that named by madvise(MADV_FREE).
> 
> The gain is clear that kernel can discard freed pages rather than
> swapping out or OOM if memory pressure happens.
> 
> Without memory pressure, freed pages would be reused by userspace
> without another additional overhead(ex, page fault + allocation
> + zeroing).
> 
> How to work is following as.
> 
> When madvise syscall is called, VM clears dirty bit of ptes of
> the range. 

This should be updated because the implementation has been changed.
It also remove the page from the swapcache if it is.

Thank you for your effort!

-- 
Thanks.
Zhang Yanfei
