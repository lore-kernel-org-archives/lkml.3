Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760213Ab3GaQjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:39:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55477 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab3GaQjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:39:14 -0400
Date: Wed, 31 Jul 2013 18:39:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/18] Basic scheduler support for automatic NUMA
 balancing V5
Message-ID: <20130731163903.GG3008@twins.programming.kicks-ass.net>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <20130725103620.GM27075@twins.programming.kicks-ass.net>
 <20130731103052.GR2296@suse.de>
 <20130731104814.GA3008@twins.programming.kicks-ass.net>
 <20130731115719.GT2296@suse.de>
 <20130731153018.GD3008@twins.programming.kicks-ass.net>
 <20130731161141.GX2296@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731161141.GX2296@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 05:11:41PM +0100, Mel Gorman wrote:
> RSS was another option it felt as arbitrary as a plain delay.

Right, it would avoid 'small' programs getting scanning done with the
rationale that their cost isn't that large since they don't have much
memory to begin with.

The same can be said for tasks that don't run much -- irrespective of
how much absolute runtime they've gathered.

Is there any other group of tasks that we do not want to scan?

Maybe if we can list all the various exclusions we can get to a proper
quantifier that way.

So far we've got:

 - doesn't run long
 - doesn't run much
 - doesn't have much memory

> Should I revert 5bca23035391928c4c7301835accca3551b96cc2 with an
> explanation that it potentially is completely useless in the purely
> multi-process shared case?

Yeah I suppose so..
