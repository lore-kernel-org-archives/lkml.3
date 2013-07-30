Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab3G3Jn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:43:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41638 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537Ab3G3Jde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:34 -0400
Date: Tue, 30 Jul 2013 11:33:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 00/10] Improve numa scheduling by consolidating tasks
Message-ID: <20130730093321.GO3008@twins.programming.kicks-ass.net>
References: <1375170505-5967-1-git-send-email-srikar@linux.vnet.ibm.com>
 <20130730081755.GF3008@twins.programming.kicks-ass.net>
 <20130730082001.GG3008@twins.programming.kicks-ass.net>
 <20130730091542.GA28656@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730091542.GA28656@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 02:45:43PM +0530, Srikar Dronamraju wrote:

> Can you please suggest workloads that I could try which might showcase
> why you hate pure process based approach?

2 processes, 1 sysvshm segment. I know there's multi-process MPI
libraries out there.

Something like: perf bench numa mem -p 2 -G 4096 -0 -z --no-data_rand_walk -Z
