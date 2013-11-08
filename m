Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab3KHAGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:06:52 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:2902 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754793Ab3KHAGo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:06:44 -0500
From: "Rowand, Frank" <Frank.Rowand@sonymobile.com>
To: Vincent Guittot <vincent.guittot@linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>
CC: "Morten.Rasmussen@arm.com" <Morten.Rasmussen@arm.com>,
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
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 8 Nov 2013 01:04:17 +0100
Subject: RE: Bench for testing scheduler
Thread-Topic: Bench for testing scheduler
Thread-Index: Ac7bvk9y4OojQjUTQpeWO1F0IS7zhQAV8Fxl
Message-ID: <8251B150E4DF5041A62C3EA9F0AB2E060255308A9E7B@SELDMBX99.corpusers.net>
References: <CAKfTPtCh+f1FZxkWqU5=2PjGtfRaN8jVV3WdTCzLDAWSjMP7yw@mail.gmail.com>,<1383831224-26134-1-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1383831224-26134-1-git-send-email-vincent.guittot@linaro.org>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, sv-SE
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

Thanks for creating some benchmark numbers!


On Thursday, November 07, 2013 5:33 AM, Vincent Guittot [vincent.guittot@linaro.org] wrote:
> 
> On 7 November 2013 12:32, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > Hi Vincent,
> >
> > (for whatever reason, the text is wrapped and results hard to read)
> 
> Yes, i have just seen that. It looks like gmail has wrapped the lines.
> I have added the results which should not be wrapped, at the end of this email
> 
> >
> >
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

The number of loops ("-l 2000") should be much larger to create useful
results.  I don't have a specific number that is large enough, I just
know from experience that 2000 is way too small.  For example, running
cyclictest several times with the same values on my laptop gives values
that are not consistent:

   $ sudo ./cyclictest -t -q -e 10000000 -i 500 -d 150 -l 2000
   # /dev/cpu_dma_latency set to 10000000us
   T: 0 ( 9703) P: 0 I:500 C:   2000 Min:      2 Act:   90 Avg:   77 Max:     243
   T: 1 ( 9704) P: 0 I:650 C:   1557 Min:      2 Act:   58 Avg:   68 Max:     226
   T: 2 ( 9705) P: 0 I:800 C:   1264 Min:      2 Act:   54 Avg:   81 Max:    1017
   T: 3 ( 9706) P: 0 I:950 C:   1065 Min:      2 Act:   11 Avg:   80 Max:     260
   
   $ sudo ./cyclictest -t -q -e 10000000 -i 500 -d 150 -l 2000
   # /dev/cpu_dma_latency set to 10000000us
   T: 0 ( 9709) P: 0 I:500 C:   2000 Min:      2 Act:   45 Avg:   74 Max:     390
   T: 1 ( 9710) P: 0 I:650 C:   1554 Min:      2 Act:   82 Avg:   61 Max:     810
   T: 2 ( 9711) P: 0 I:800 C:   1263 Min:      2 Act:   83 Avg:   74 Max:     287
   T: 3 ( 9712) P: 0 I:950 C:   1064 Min:      2 Act:  103 Avg:   79 Max:     551
   
   $ sudo ./cyclictest -t -q -e 10000000 -i 500 -d 150 -l 2000
   # /dev/cpu_dma_latency set to 10000000us
   T: 0 ( 9716) P: 0 I:500 C:   2000 Min:      2 Act:   82 Avg:   72 Max:     252
   T: 1 ( 9717) P: 0 I:650 C:   1556 Min:      2 Act:  115 Avg:   77 Max:     354
   T: 2 ( 9718) P: 0 I:800 C:   1264 Min:      2 Act:   59 Avg:   78 Max:    1143
   T: 3 ( 9719) P: 0 I:950 C:   1065 Min:      2 Act:  104 Avg:   70 Max:     238
   
   $ sudo ./cyclictest -t -q -e 10000000 -i 500 -d 150 -l 2000
   # /dev/cpu_dma_latency set to 10000000us
   T: 0 ( 9722) P: 0 I:500 C:   2000 Min:      2 Act:   82 Avg:   68 Max:     213
   T: 1 ( 9723) P: 0 I:650 C:   1555 Min:      2 Act:   65 Avg:   65 Max:    1279
   T: 2 ( 9724) P: 0 I:800 C:   1264 Min:      2 Act:   91 Avg:   69 Max:     244
   T: 3 ( 9725) P: 0 I:950 C:   1065 Min:      2 Act:   58 Avg:   76 Max:     242


> >
> > cyclictest could be a good starting point but we need to improve it to
> > allow threads of different loads, possibly starting multiple processes
> > (can be done with a script), randomly varying load threads. These
> > parameters should be loaded from a file so that we can have multiple
> > configurations (per SoC and per use-case). But the big risk is that we
> > try to optimise the scheduler for something which is not realistic.
> 
> The goal of this simple bench is to measure the wake up latency and the reachable value of the scheduler on a platform but not to emulate a "real" use case. In the same way than sched-pipe tests a specific behavior of the scheduler, this bench tests the wake up latency of a system.
> 
> Starting multi processes and adding some loads can also be useful but the target will be a bit different from wake up latency. I have one concern with randomness because it prevents from having repeatable and comparable tests and results.
> 
> I agree that we have to test "real" use cases but it doesn't prevent from testing the limit of a characteristic on a system
> 
> >
> >
> > We are working on describing some basic scenarios (plain English for
> > now) and one of them could be video playing with threads for audio and
> > video decoding with random change in the workload.
> >
> > So I think the first step should be a set of tools/scripts to analyse
> > the scheduler behaviour, both in terms of latency and power, and these
> > can use perf sched. We can then run some real life scenarios (e.g.
> > Android video playback) and build a benchmark that matches such
> > behaviour as close as possible. We can probably use (or improve) perf
> > sched replay to also simulate such workload (we may need additional
> > features like thread dependencies).
> >
> >> The figures below give the average wakeup latency and power
> >> consumption for default scheduler behavior, packing tasks at cluster
> >> level and packing tasks at core level. We can see both wakeup latency
> >> and power consumption variation. The detailed result is not a simple
> >> single value which makes comparison not so easy but the average of all
> >> measurements should give us a usable “score”.
> >
> > How did you assess the power/energy?
> 
> I have use the embedded joule meter of the tc2.
> 
> >
> > Thanks.
> >
> > --
> > Catalin
> 
>             |  Default average results                  |  Cluster Packing average results          |  Core Packing average results
>             |  Latency     stddev  A7 energy A15 energy |  Latency     stddev  A7 energy A15 energy |  Latency     stddev  A7 energy A15 energy
>             |     (us)                   (J)        (J) |     (us)                   (J)        (J) |     (us)                   (J)        (J)
>             |      879                794890    2364175 |      416                879688      12750 |      189                897452      30052
> 
>  Cyclictest |  Default                                  |  Packing at Cluster level                 |  Packing at Core level
>    Interval |  Latency     stddev  A7 energy A15 energy |  Latency     stddev  A7 energy A15 energy |  Latency     stddev  A7 energy A15 energy
>        (us) |     (us)                   (J)        (J) |     (us)                   (J)        (J) |     (us)                   (J)        (J)
>         500         24          1    1147477    2479576         21          1    1136768      11693         22          1    1126062      30138
>         700         22          1    1136084    3058419         21          0    1125280      11761         21          1    1109950      23503

< snip >

Some questions about what these metrics are:

The cyclictest data is reported per thread.  How did you combine the per thread data
to get a single latency and stddev value?

Is "Latency" the average latency?

stddev is not reported by cyclictest.  How did you create this value?  Did you
use the "-v" cyclictest option to report detailed data, then calculate stddev from
the detailed data?

Thanks,

-Frank