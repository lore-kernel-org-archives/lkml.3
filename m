Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377AbaFYXcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 19:32:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaFYXcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 19:32:52 -0400
Date: Wed, 25 Jun 2014 16:32:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] mm: vmscan: Do not reclaim from lower zones if they
 are balanced
Message-Id: <20140625163250.354f12cd0fa5ff16e32056bf@linux-foundation.org>
In-Reply-To: <1403683129-10814-4-git-send-email-mgorman@suse.de>
References: <1403683129-10814-1-git-send-email-mgorman@suse.de>
	<1403683129-10814-4-git-send-email-mgorman@suse.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014 08:58:46 +0100 Mel Gorman <mgorman@suse.de> wrote:

> Historically kswapd scanned from DMA->Movable in the opposite direction
> to the page allocator to avoid allocating behind kswapd direction of
> progress. The fair zone allocation policy altered this in a non-obvious
> manner.
> 
> Traditionally, the page allocator prefers to use the highest eligible zone
> until the watermark is depleted, woke kswapd and moved onto the next zone.
> kswapd scans zones in the opposite direction so the scanning lists on
> 64-bit look like this;
> 
> ...
>
> Note that this patch makes a large performance difference for lower
> numbers of threads and brings performance closer to 3.0 figures. It was
> also tested against xfs and there are similar gains although I don't have
> 3.0 figures to compare against. There are still regressions for higher
> number of threads but this is related to changes in the CFQ IO scheduler.
> 

Why did this patch make a difference to sequential read performance? 
IOW, by what means was/is reclaim interfering with sequential reads?

