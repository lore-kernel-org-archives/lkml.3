Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaFWGqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 02:46:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49800 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaFWGq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 02:46:29 -0400
Date: Mon, 23 Jun 2014 08:46:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ben Segall <bsegall@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, pjt@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Fix potential near-infinite
 distribute_cfs_runtime loop
Message-ID: <20140623064625.GC19860@laptop.programming.kicks-ass.net>
References: <20140620222120.13814.21652.stgit@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620222120.13814.21652.stgit@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 03:21:20PM -0700, Ben Segall wrote:
> distribute_cfs_runtime intentionally only hands out enough runtime to
> bring each cfs_rq to 1 ns of runtime, expecting the cfs_rqs to then take
> the runtime they need only once they actually get to run. However, if
> they get to run sufficiently quickly, the period timer is still in
> distribute_cfs_runtime and no runtime is available, causing them to
> throttle. Then distribute has to handle them again, and this can go on
> until distribute has handed out all of the runtime 1ns at a time, which
> takes far too long.
> 
> Instead allow access to the same runtime that distribute is handing out,
> accepting that corner cases with very low quota may be able to spend the
> entire cfs_b->runtime during distribute_cfs_runtime, meaning that the
> runtime directly handed out by distribute_cfs_runtime was over quota. In
> addition, if a cfs_rq does manage to throttle like this, make sure the
> existing distribute_cfs_runtime no longer loops over it again.
> 
> Signed-off-by: Ben Segall <bsegall@google.com>

Thanks Ben!
