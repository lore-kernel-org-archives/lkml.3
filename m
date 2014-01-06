Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaAFMRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:17:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57698 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaAFMRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:17:38 -0500
Date: Mon, 6 Jan 2014 13:17:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mike Galbraith <bitbucket@online.de>
Subject: Re: [PATCH] sched/auto_group: fix consume memory even if add
 'noautogroup' in the cmdline
Message-ID: <20140106121719.GH31570@twins.programming.kicks-ass.net>
References: <1388139751-19632-1-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388139751-19632-1-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 06:22:31PM +0800, Wanpeng Li wrote:
> We have a server which have 200 CPUs and 8G memory, there is auto_group creation 

I'm hoping that is 8T, otherwise that's a severely under provisioned
system, that's a mere 40M per cpu, does that even work?

> which will almost consume 12MB memory even if add 'noautogroup' in the kernel 
> boot parameter. In addtion, SLUB per cpu partial caches freeing that is local to 
> a processor which requires the taking of locks at the price of more indeterminism 
> in the latency of the free. This patch fix it by check noautogroup earlier to avoid 
> free after unnecessary memory consumption.

That's just a bad changelog. It fails to explain the actual problem and
it babbles about unrelated things like SLUB details.

Also, I'm not entirely sure what the intention was of this code, I've so
far tried to ignore the entire autogroup fest... 

It looks like it creates and maintains the entire autogroup hierarchy,
such that if you at runtime enable the sysclt and move tasks 'back' to
the root cgroup you get the autogroup behaviour.

Was this intended? Mike?

This patch obviously breaks that.
