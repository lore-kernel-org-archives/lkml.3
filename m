Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbaAIUNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:13:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643AbaAIUNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:13:08 -0500
Message-ID: <52CEFD4F.3080804@redhat.com>
Date: Thu, 09 Jan 2014 14:49:35 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Alex Shi <alex.shi@linaro.org>,
        Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] x86: mm: Eliminate redundant page table walk during
 TLB range flushing
References: <1389278098-27154-1-git-send-email-mgorman@suse.de> <1389278098-27154-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1389278098-27154-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 09:34 AM, Mel Gorman wrote:
> When choosing between doing an address space or ranged flush, the x86
> implementation of flush_tlb_mm_range takes into account whether there are
> any large pages in the range. A per-page flush typically requires fewer
> entries than would covered by a single large page and the check is redundant.
>
> There is one potential exception. THP migration flushes single THP entries
> and it conceivably would benefit from flushing a single entry instead
> of the mm. However, this flush is after a THP allocation, copy and page
> table update potentially with any other threads serialised behind it. In
> comparison to that, the flush is noise. It makes more sense to optimise
> balancing to require fewer flushes than to optimise the flush itself.
>
> This patch deletes the redundant huge page check.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

