Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3JGRKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:10:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab3JGRKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:10:43 -0400
Message-ID: <5252EAFF.8040700@redhat.com>
Date: Mon, 07 Oct 2013 13:10:23 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/63] mm: numa: Do not migrate or account for hinting
 faults on the zero page
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-13-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-13-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:28 AM, Mel Gorman wrote:
> The zero page is not replicated between nodes and is often shared between
> processes. The data is read-only and likely to be cached in local CPUs
> if heavily accessed meaning that the remote memory access cost is less
> of a concern. This patch prevents trapping faults on the zero pages. For
> tasks using the zero page this will reduce the number of PTE updates,
> TLB flushes and hinting faults.
> 
> [peterz@infradead.org: Correct use of is_huge_zero_page]
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
