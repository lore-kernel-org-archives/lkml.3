Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660AbaJ3Oqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:46:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:53285 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760642AbaJ3Oqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:46:47 -0400
Date: Thu, 30 Oct 2014 15:46:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk,
        rafael.j.wysocki@intel.com, mingo@kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        mturquette@linaro.org, tuukka.tikkanen@linaro.org,
        nicolas.pitre@linaro.org, patches@linaro.org
Subject: Re: [RFD PATCH 10/10] sched: io_latency: Tracking via buckets
Message-ID: <20141030144634.GH23531@worktop.programming.kicks-ass.net>
References: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
 <1413986273-28522-11-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413986273-28522-11-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 03:57:53PM +0200, Daniel Lezcano wrote:
> The size of the bucket is the bucket interval and represent the resolution
> of the statistic model. Eg with a bucket interval of 1us, it leads us to
> do statitics on all numbers, with of course a bad prediction because the
> number of latencies is big. A big interval can give better statistics,
> but can give us a misprediction as the interval is larger.
> 
> Choosing the size of the bucket interval vs the idle sleep time is the
> tradeoff to find. With a 200us bucket interval, the measurements show
> we still have good predictions, less mispredictions and cover the idle
> state target residency.
> 

For the record:

The suggestion in DUS was to align the bucket sizes with the various
break even times of the actual C states.

I forgot who suggested this; it might have been Morten; but it seems to
make sense.
