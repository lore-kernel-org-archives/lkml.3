Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab3KGOF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:05:27 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52700 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754376Ab3KGOFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:05:24 -0500
Date: Thu, 7 Nov 2013 14:04:21 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "pjt@google.com" <pjt@google.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "paul@pwsan.com" <paul@pwsan.com>, "mgorman@suse.de" <mgorman@suse.de>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        "khilman@linaro.org" <khilman@linaro.org>,
        "Frank.Rowand@sonymobile.com" <Frank.Rowand@sonymobile.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Bench for testing scheduler
Message-ID: <20131107140421.GF13674@arm.com>
References: <CAKfTPtCh+f1FZxkWqU5=2PjGtfRaN8jVV3WdTCzLDAWSjMP7yw@mail.gmail.com>
 <1383831224-26134-1-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383831224-26134-1-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 01:33:43PM +0000, Vincent Guittot wrote:
> On 7 November 2013 12:32, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Thu, Nov 07, 2013 at 10:54:30AM +0000, Vincent Guittot wrote:
> >> During the Energy-aware scheduling mini-summit, we spoke about benches
> >> that should be used to evaluate the modifications of the scheduler.
> >> I’d like to propose a bench that uses cyclictest to measure the wake
> >> up latency and the power consumption. The goal of this bench is to
> >> exercise the scheduler with various sleeping period and get the
> >> average wakeup latency. The range of the sleeping period must cover
> >> all residency times of the idle state table of the platform. I have
> >> run such tests on a tc2 platform with the packing tasks patchset.
> >> I have use the following command:
> >> #cyclictest -t <number of cores> -q -e 10000000 -i <500-12000> -d 150 -l 2000
> >
> > cyclictest could be a good starting point but we need to improve it to
> > allow threads of different loads, possibly starting multiple processes
> > (can be done with a script), randomly varying load threads. These
> > parameters should be loaded from a file so that we can have multiple
> > configurations (per SoC and per use-case). But the big risk is that we
> > try to optimise the scheduler for something which is not realistic.
> 
> The goal of this simple bench is to measure the wake up latency and
> the reachable value of the scheduler on a platform but not to emulate
> a "real" use case. In the same way than sched-pipe tests a specific
> behavior of the scheduler, this bench tests the wake up latency of a
> system.

These figures are indeed useful to make sure we don't have any
regression in terms of latency but I would not use cyclictest (as it is)
to assess power improvements since the test is too artificial.

> Starting multi processes and adding some loads can also be useful but
> the target will be a bit different from wake up latency. I have one
> concern with randomness because it prevents from having repeatable and
> comparable tests and results.

We can avoid randomness but still make it varying by some predictable
function.

> I agree that we have to test "real" use cases but it doesn't prevent
> from testing the limit of a characteristic on a system

I agree. My point is not to use this as "the benchmark".

I would prefer to assess the impact on latency (and power) using a tool
independent from benchmarks like cyclictest (e.g. use the reports from
power sched). The reason is that once we have those tools/scripts in the
kernel, a third party can run it on real workloads and provide the
kernel developers with real numbers on performance vs power scheduling,
regressions between kernel versions etc. We can't create a power model
that you can run on an x86 for example and give you an indication of the
power saving on ARM, you need to run the benchmarks on the actual
hardware (that's why I don't think linsched is of much use from a power
perspective).

-- 
Catalin
