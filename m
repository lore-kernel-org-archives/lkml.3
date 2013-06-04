Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab3FDGF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:05:56 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44092 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab3FDGFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:05:55 -0400
X-AuditID: 9c93016f-b7cfdae000002fc1-4c-51ad83c10239
Date: Tue, 4 Jun 2013 15:05:53 +0900
From: Minchan Kim <minchan@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, tim.c.chen@linux.intel.com
Subject: Re: [v5][PATCH 6/6] mm: vmscan: drain batch list during long
 operations
Message-ID: <20130604060553.GF14719@blaptop>
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

Nice idea but I could see drain before pageout but congestion_wait?

-- 
Kind regards,
Minchan Kim
