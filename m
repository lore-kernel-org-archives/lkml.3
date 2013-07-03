Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3GCSf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:35:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45150 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab3GCSf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:35:56 -0400
Date: Wed, 3 Jul 2013 20:35:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/13] mm: numa: Scan pages with elevated page_mapcount
Message-ID: <20130703183517.GC18898@dyad.programming.kicks-ass.net>
References: <1372861300-9973-1-git-send-email-mgorman@suse.de>
 <1372861300-9973-13-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372861300-9973-13-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 03:21:39PM +0100, Mel Gorman wrote:
> Initial support for automatic NUMA balancing was unable to distinguish
> between false shared versus private pages except by ignoring pages with an
> elevated page_mapcount entirely. This patch kicks away the training wheels
> as initial support for identifying shared/private pages is now in place.
> Note that the patch still leaves shared, file-backed in VM_EXEC vmas in
> place guessing that these are shared library pages. Migrating them are
> likely to be of major benefit as generally the expectation would be that
> these are read-shared between caches and that iTLB and iCache pressure is
> generally low.

This reminds me; there a clause in task_numa_work() that skips 'small' VMAs. I
don't see the point of that.

In fact; when using things like electric fence this might mean skipping most
memory.
