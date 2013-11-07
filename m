Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab3KGLd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:33:28 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50763 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754543Ab3KGLd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:33:26 -0500
Date: Thu, 7 Nov 2013 11:32:26 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Alex Shi <alex.shi@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Ingo Molnar <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul Walmsley <paul@pwsan.com>, Mel Gorman <mgorman@suse.de>,
        Juri Lelli <juri.lelli@gmail.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Frank.Rowand@sonymobile.com" <Frank.Rowand@sonymobile.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Bench for testing scheduler
Message-ID: <20131107113226.GE13674@arm.com>
References: <CAKfTPtCh+f1FZxkWqU5=2PjGtfRaN8jVV3WdTCzLDAWSjMP7yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKfTPtCh+f1FZxkWqU5=2PjGtfRaN8jVV3WdTCzLDAWSjMP7yw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

(for whatever reason, the text is wrapped and results hard to read)

On Thu, Nov 07, 2013 at 10:54:30AM +0000, Vincent Guittot wrote:
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

cyclictest could be a good starting point but we need to improve it to
allow threads of different loads, possibly starting multiple processes
(can be done with a script), randomly varying load threads. These
parameters should be loaded from a file so that we can have multiple
configurations (per SoC and per use-case). But the big risk is that we
try to optimise the scheduler for something which is not realistic.

We are working on describing some basic scenarios (plain English for
now) and one of them could be video playing with threads for audio and
video decoding with random change in the workload.

So I think the first step should be a set of tools/scripts to analyse
the scheduler behaviour, both in terms of latency and power, and these
can use perf sched. We can then run some real life scenarios (e.g.
Android video playback) and build a benchmark that matches such
behaviour as close as possible. We can probably use (or improve) perf
sched replay to also simulate such workload (we may need additional
features like thread dependencies).

> The figures below give the average wakeup latency and power
> consumption for default scheduler behavior, packing tasks at cluster
> level and packing tasks at core level. We can see both wakeup latency
> and power consumption variation. The detailed result is not a simple
> single value which makes comparison not so easy but the average of all
> measurements should give us a usable “score”.

How did you assess the power/energy?

Thanks.

-- 
Catalin
