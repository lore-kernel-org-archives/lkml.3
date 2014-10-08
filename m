Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbaJHKxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:53:07 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:55895 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474AbaJHKxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:53:05 -0400
Date: Wed, 8 Oct 2014 11:53:01 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 09/11] perf/x86/intel: Implement LRU monitoring ID
 allocation for CQM
Message-ID: <20141008105301.GQ14343@console-pimps.org>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-10-git-send-email-matt@console-pimps.org>
 <20141008095109.GD4750@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008095109.GD4750@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Oct, at 11:51:09AM, Peter Zijlstra wrote:
> On Wed, Sep 24, 2014 at 03:04:13PM +0100, Matt Fleming wrote:
> > From: Matt Fleming <matt.fleming@intel.com>
> > 
> > It's possible to run into issues with re-using unused monitoring IDs
> > because there may be stale cachelines associated with that ID from a
> > previous allocation. This can cause the LLC occupancy values to be
> > inaccurate.
> > 
> > To attempt to mitigate this problem we place the IDs on a least recently
> > used list, essentially a FIFO. The basic idea is that the longer the
> > time period between ID re-use the lower the probability that stale
> > cachelines exist in the cache.
> 
> Do we want to provide a user configurable minumum guaranteed queue time?

Potentially, yeah. That might be better suited as part of the final
patch that includes the rotation code, which already has a delayed
workqueue.

We could add a minimum queue time before we start querying whether the
data occupancy value for an RMID has dropped to zero on all sockets.

That'd save us from an expensive smp_call_function_many() when we're
unlikely to succeed anyway.

-- 
Matt Fleming, Intel Open Source Technology Center
