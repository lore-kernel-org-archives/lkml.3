Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034Ab3LIObO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:31:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab3LIObL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:31:11 -0500
Message-ID: <52A5D424.7030901@redhat.com>
Date: Mon, 09 Dec 2013 09:31:00 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/18] mm: numa: Do not clear PTE for pte_numa update
References: <1386572952-1191-1-git-send-email-mgorman@suse.de> <1386572952-1191-6-git-send-email-mgorman@suse.de>
In-Reply-To: <1386572952-1191-6-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 02:08 AM, Mel Gorman wrote:
> The TLB must be flushed if the PTE is updated but change_pte_range is clearing
> the PTE while marking PTEs pte_numa without necessarily flushing the TLB if it
> reinserts the same entry. Without the flush, it's conceivable that two processors
> have different TLBs for the same virtual address and at the very least it would
> generate spurious faults. This patch only unmaps the pages in change_pte_range for
> a full protection change.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
