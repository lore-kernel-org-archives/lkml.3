Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3KGRm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:42:56 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52569 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753887Ab3KGRmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:42:53 -0500
Date: Thu, 7 Nov 2013 17:42:14 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Alex Shi <alex.shi@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Ingo Molnar <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Paul Walmsley <paul@pwsan.com>, Mel Gorman <mgorman@suse.de>,
        Juri Lelli <juri.lelli@gmail.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Frank.Rowand@sonymobile.com" <Frank.Rowand@sonymobile.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Bench for testing scheduler
Message-ID: <20131107174214.GB25590@e103034-lin>
References: <CAKfTPtCh+f1FZxkWqU5=2PjGtfRaN8jVV3WdTCzLDAWSjMP7yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKfTPtCh+f1FZxkWqU5=2PjGtfRaN8jVV3WdTCzLDAWSjMP7yw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On Thu, Nov 07, 2013 at 10:54:30AM +0000, Vincent Guittot wrote:
> Hi,
> 
> During the Energy-aware scheduling mini-summit, we spoke about benches
> that should be used to evaluate the modifications of the scheduler.
> I’d like to propose a bench that uses cyclictest to measure the wake
> up latency and the power consumption. The goal of this bench is to
> exercise the scheduler with various sleeping period and get the
> average wakeup latency. The range of the sleeping period must cover
> all residency times of the idle state table of the platform. I have
> run such tests on a tc2 platform with the packing tasks patchset.
> I have use the following command:
> #cyclictest -t <number of cores> -q -e 10000000 -i <500-12000> -d 150 -l 2000

I think cyclictest is a useful model small(er) periodic tasks for
benchmarking energy related patches. However, it doesn't have a
good-enough-performance criteria as it is. I think that is a strict
requirement for all energy related benchmarks.

Measuring latency gives us a performance metric while the energy tells
us how energy efficient we are. But without a latency requirement we
can't really say if a patch helps energy-awareness unless it improves
both energy _and_ performance. That is the case for your packing patches
for this particular benchmark with this specific configuration. That is
a really good result. However, in the general case patches may trade a
bit of performance to get better energy, which is also good if
performance still meets the requirement of the application/user. So we
need a performance criteria to tells us when we sacrifice too much
performance when trying to save power. Without it it is just a
performance benchmark where we measure power.

Coming up with a performance criteria for cyclictest is not so easy as
it doesn't really model any specific application. I guess sacrificing a
bit of latency is acceptable if it comes with significant energy
savings. But a huge performance impact might not be, even if it comes
with massive energy savings. So maybe the criteria would consist of both
a minimum latency requirement (e.g. up to 10% increase) and a
requirement for improved energy per work.

As I see it, it the only way we can validate energy efficiency of
patches that trade performance for improved energy.

Morten

