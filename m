Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaBMQLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:11:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbaBMQLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:11:24 -0500
Message-ID: <52FCEE9C.2040001@redhat.com>
Date: Thu, 13 Feb 2014 11:11:08 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Weijie Yang <weijie.yang@samsung.com>, "'Mel Gorman'" <mgorman@suse.de>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Minchan Kim'" <minchan@kernel.org>, weijie.yang.kh@gmail.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm/vmscan: not check compaction_ready on promoted
 zones
References: <000101cf2865$2a8411a0$7f8c34e0$%yang@samsung.com>
In-Reply-To: <000101cf2865$2a8411a0$7f8c34e0$%yang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 09:41 PM, Weijie Yang wrote:
> We abort direct reclaim if find the zone is ready for compaction.
> 
> Sometimes the zone is just a promoted highmem zone to force scan
> pinning highmem, which is not the intended zone the caller want to
> alloc page from. In this situation, setting aborted_reclaim to
> indicate the caller turn back to retry allocation is waste of time
> and could cause a loop in __alloc_pages_slowpath().
> 
> This patch do not check compaction_ready() on promoted zones to avoid
> the above situation, only set aborted_reclaim if the caller intended
> zone is ready to compaction.
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
