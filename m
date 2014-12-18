Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaLRV0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:26:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaLRV0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:26:21 -0500
Date: Thu, 18 Dec 2014 13:26:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH V3 0/4] Reducing parameters of alloc_pages* family of
 functions
Message-Id: <20141218132619.4e6b349d0aa1744c41f985c7@linux-foundation.org>
In-Reply-To: <1418400805-4661-1-git-send-email-vbabka@suse.cz>
References: <1418400805-4661-1-git-send-email-vbabka@suse.cz>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2014 17:13:21 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:

> Vlastimil Babka (4):
>   mm: set page->pfmemalloc in prep_new_page()
>   mm, page_alloc: reduce number of alloc_pages* functions' parameters
>   mm: reduce try_to_compact_pages parameters
>   mm: microoptimize zonelist operations

That all looks pretty straightforward.  It would be nice to have a
summary of the code-size and stack-usage changes for the whole
patchset.

Can we move `struct alloc_context' into mm/internal.h?

I pity the poor schmuck who has to maintain this patchset for 2 months.
[2/4] already throws a large pile of rejects against page_alloc.c so
can you please refresh/retest/resend?


