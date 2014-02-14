Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaBNLEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:04:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaBNLEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:04:49 -0500
Date: Fri, 14 Feb 2014 11:04:46 +0000
From: Mel Gorman <mgorman@suse.de>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, riel@redhat.com,
        "'Minchan Kim'" <minchan@kernel.org>, weijie.yang.kh@gmail.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 2/2] mm/vmscan: not check compaction_ready on promoted
 zones
Message-ID: <20140214110446.GB6732@suse.de>
References: <000201cf2950$07a17ce0$16e476a0$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <000201cf2950$07a17ce0$16e476a0$%yang@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 02:42:34PM +0800, Weijie Yang wrote:
> We abort direct reclaim if find the zone is ready for compaction.
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
> Acked-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
