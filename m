Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbaJHJvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:51:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:60428 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbaJHJvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:51:12 -0400
Date: Wed, 8 Oct 2014 11:51:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 09/11] perf/x86/intel: Implement LRU monitoring ID
 allocation for CQM
Message-ID: <20141008095109.GD4750@worktop.programming.kicks-ass.net>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-10-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411567455-31264-10-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:04:13PM +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> It's possible to run into issues with re-using unused monitoring IDs
> because there may be stale cachelines associated with that ID from a
> previous allocation. This can cause the LLC occupancy values to be
> inaccurate.
> 
> To attempt to mitigate this problem we place the IDs on a least recently
> used list, essentially a FIFO. The basic idea is that the longer the
> time period between ID re-use the lower the probability that stale
> cachelines exist in the cache.

Do we want to provide a user configurable minumum guaranteed queue time?
