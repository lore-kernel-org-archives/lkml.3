Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab3KKAXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 19:23:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab3KKAXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 19:23:06 -0500
Message-ID: <52802361.5040601@redhat.com>
Date: Sun, 10 Nov 2013 19:22:57 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: numa: Return the number of base pages altered by
 protection changes
References: <20131109143718.GC5040@suse.de>
In-Reply-To: <20131109143718.GC5040@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2013 09:37 AM, Mel Gorman wrote:
> Commit 0255d491 (mm: Account for a THP NUMA hinting update as one PTE
> update) was added to account for the number of PTE updates when marking
> pages prot_numa. task_numa_work was using the old return value to track
> how much address space had been updated. Altering the return value causes
> the scanner to do more work than it is configured or documented to in a
> single unit of work.
> 
> This patch reverts 0255d491 and accounts for the number of THP updates
> separately in vmstat. It is up to the administrator to interpret the pair
> of values correctly. This is a straight-forward operation and likely to
> only be of interest when actively debugging NUMA balancing problems.
> 
> The impact of this patch is that the NUMA PTE scanner will scan slower when
> THP is enabled and workloads may converge slower as a result. On the flip
> size system CPU usage should be lower than recent tests reported. This is
> an illustrative example of a short single JVM specjbb test

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
