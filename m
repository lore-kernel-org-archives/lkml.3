Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab3LIOIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:08:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663Ab3LIOIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:08:48 -0500
Message-ID: <52A5CEE6.2080609@redhat.com>
Date: Mon, 09 Dec 2013 09:08:38 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/18] mm: numa: Serialise parallel get_user_page against
 THP migration
References: <1386572952-1191-1-git-send-email-mgorman@suse.de> <1386572952-1191-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1386572952-1191-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 02:08 AM, Mel Gorman wrote:
> Base pages are unmapped and flushed from cache and TLB during normal page
> migration and replaced with a migration entry that causes any parallel or
> gup to block until migration completes. THP does not unmap pages due to
> a lack of support for migration entries at a PMD level. This allows races
> with get_user_pages and get_user_pages_fast which commit 3f926ab94 ("mm:
> Close races between THP migration and PMD numa clearing") made worse by
> introducing a pmd_clear_flush().
> 
> This patch forces get_user_page (fast and normal) on a pmd_numa page to
> go through the slow get_user_page path where it will serialise against THP
> migration and properly account for the NUMA hinting fault. On the migration
> side the page table lock is taken for each PTE update.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
