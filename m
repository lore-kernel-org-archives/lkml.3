Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab3GLKPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 06:15:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60426 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab3GLKPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 06:15:00 -0400
Date: Fri, 12 Jul 2013 12:14:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/16] sched: Reschedule task on preferred NUMA node once
 selected
Message-ID: <20130712101408.GV25631@dyad.programming.kicks-ass.net>
References: <1373536020-2799-1-git-send-email-mgorman@suse.de>
 <1373536020-2799-9-git-send-email-mgorman@suse.de>
 <20130711123038.GH25631@dyad.programming.kicks-ass.net>
 <20130711130322.GC2355@suse.de>
 <20130711131158.GJ25631@dyad.programming.kicks-ass.net>
 <20130711140914.GE2355@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711140914.GE2355@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 03:09:14PM +0100, Mel Gorman wrote:
> That might be necessary when the machine is overloaded. As a
> starting point the following should retry the migrate a number of times
> until success. The retry is checked on every fault but should not fire
> more than once every 100ms.
 
Yeah, something like that might work. But getting a working imbalance bound is
important. The current very weak direct migration is the only thing that keeps
the system from massively skewing load.
