Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab3JGN4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 09:56:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab3JGN4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 09:56:07 -0400
Message-ID: <5252BD63.6060606@redhat.com>
Date: Mon, 07 Oct 2013 09:55:47 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/63] mm: Wait for THP migrations to complete during
 NUMA hinting faults
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-6-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-6-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:28 AM, Mel Gorman wrote:
> The locking for migrating THP is unusual. While normal page migration
> prevents parallel accesses using a migration PTE, THP migration relies on
> a combination of the page_table_lock, the page lock and the existance of
> the NUMA hinting PTE to guarantee safety but there is a bug in the scheme.
> 
> If a THP page is currently being migrated and another thread traps a
> fault on the same page it checks if the page is misplaced. If it is not,
> then pmd_numa is cleared. The problem is that it checks if the page is
> misplaced without holding the page lock meaning that the racing thread
> can be migrating the THP when the second thread clears the NUMA bit
> and faults a stale page.
> 
> This patch checks if the page is potentially being migrated and stalls
> using the lock_page if it is potentially being migrated before checking
> if the page is misplaced or not.
> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
