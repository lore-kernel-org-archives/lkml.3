Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaAFMff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:35:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57939 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaAFMfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:35:34 -0500
Date: Mon, 6 Jan 2014 13:35:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Calculate effective load even if local weight is 0
Message-ID: <20140106123519.GK31570@twins.programming.kicks-ass.net>
References: <20140106113912.GC6178@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106113912.GC6178@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 11:39:12AM +0000, Mel Gorman wrote:
> wake_affine uses a weight of 0 for sync wakeups on the grounds that it
> is assuming the waking task will sleep and not contribute to load in the
> near future. In this case, we still want to calculate the effective load
> of the sched entity hierarchy. As effective_load is no longer used by
> task_numa_compare since commit fb13c7ee (sched/numa: Use a system-wide
> search to find swap/migration candidates), this patch simply restores the
> historical behaviour.

Urgh.. yeah. We should merge this. Rik you ok with me adding a from and
sob from you?
