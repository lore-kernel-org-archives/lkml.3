Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbaFKCjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 22:39:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:44658 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbaFKCi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 22:38:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="353374253"
Date: Wed, 11 Jun 2014 02:35:05 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>, len.brown@intel.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140610183505.GC5487@intel.com>
References: <20140604172712.GJ13930@laptop.programming.kicks-ass.net>
 <2484761.vkWavnsDx3@vostro.rjw.lan>
 <20140605065205.GA3213@twins.programming.kicks-ass.net>
 <539086B3.2010804@gmail.com>
 <20140605202930.GA15484@intel.com>
 <20140606080543.GR6758@twins.programming.kicks-ass.net>
 <20140606003520.GB22261@intel.com>
 <20140606105036.GQ3213@twins.programming.kicks-ass.net>
 <20140607232628.GC22261@intel.com>
 <20140610101622.GB6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610101622.GB6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 12:16:22PM +0200, Peter Zijlstra wrote:
> What other target would you optimize for? The purpose here is to build
> an energy aware scheduler, one that schedules tasks so that the total
> amount of energy, for the given amount of work, is minimal.
> 
> So we can't measure in Watt, since if we forced the CPU into the lowest
> P-state (or even C-state for that matter) work would simply not
> complete. So we need a complete energy term.
> 
> Now. IPC is instructions/cycle, Watt is Joule/second, so IPC/Watt is
> 
> instructions   second
> ------------ * ------ ~ instructions / joule
>   cycle        joule
> 
> Seeing how both cycles and seconds are time units.
> 
> So for any given amount of instructions, the work needs to be done, we
> want the minimal amount of energy consumed, and IPC/Watt is the natural
> metric to measure this over an entire workload.

Ok, I understand. Whether we take IPC/watt as an input metric in scheduler or
as a goal for scheduler, we definitely need to try both.

Thanks, Peter.

Yuyang
