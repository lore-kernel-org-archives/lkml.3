Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3FDXhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:37:19 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:65151 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3FDXhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 19:37:17 -0400
X-AuditID: 9c93017e-b7bd9ae000006882-7d-51ae7a2b4e6a
Date: Wed, 5 Jun 2013 08:37:16 +0900
From: Minchan Kim <minchan@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, tim.c.chen@linux.intel.com
Subject: Re: [v5][PATCH 6/6] mm: vmscan: drain batch list during long
 operations
Message-ID: <20130604233716.GD31006@blaptop>
References: <20130603200202.7F5FDE07@viggo.jf.intel.com>
 <20130603200210.259954C3@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603200210.259954C3@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 01:02:10PM -0700, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This was a suggestion from Mel:
> 
> 	http://lkml.kernel.org/r/20120914085634.GM11157@csn.ul.ie
> 
> Any pages we collect on 'batch_for_mapping_removal' will have
> their lock_page() held during the duration of their stay on the
> list.  If some other user is trying to get at them during this
> time, they might end up having to wait.
> 
> This ensures that we drain the batch if we are about to perform a
> pageout() or congestion_wait(), either of which will take some
> time.  We expect this to help mitigate the worst of the latency
> increase that the batching could cause.
> 
> I added some statistics to the __remove_mapping_batch() code to
> track how large the lists are that we pass in to it.  With this
> patch, the average list length drops about 10% (from about 4.1 to
> 3.8).  The workload here was a make -j4 kernel compile on a VM
> with 200MB of RAM.
> 
> I've still got the statistics patch around if anyone is
> interested.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>


-- 
Kind regards,
Minchan Kim
