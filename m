Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279AbaJITAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:00:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48740 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaJITAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:00:47 -0400
Date: Thu, 9 Oct 2014 21:00:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@redhat.com,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        tuukka.tikkanen@linaro.org
Subject: Re: [PATCH RFC 1/2] sched: cfs: introduce capacity_ops
Message-ID: <20141009190035.GB10832@worktop.programming.kicks-ass.net>
References: <20141008060712.4379.42509@quantum>
 <1412749572-29449-1-git-send-email-mturquette@linaro.org>
 <1412749572-29449-2-git-send-email-mturquette@linaro.org>
 <20141008083721.GE10832@worktop.programming.kicks-ass.net>
 <20141008232836.4379.3339@quantum>
 <20141009090024.GR10832@worktop.programming.kicks-ass.net>
 <20141009173433.4379.58492@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009173433.4379.58492@quantum>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 10:34:33AM -0700, Mike Turquette wrote:
> Quoting Peter Zijlstra (2014-10-09 02:00:24)
> > On Wed, Oct 08, 2014 at 04:28:36PM -0700, Mike Turquette wrote:
> > > > Yeah, like hell no. We do not want modules to affect scheduler
> > > > behaviour.
> > > 
> > > If a CPUfreq driver is the best place to know how frequency affects the
> > > capacity of a CPU for a given system, are you suggesting that we must
> > > compile that code into the kernel image instead of it being a loadable
> > > module?
> > 
> > Ideally we'll end up doing away with the cpufreq policy modules and
> > integrate the entire thing into the scheduler.
> 
> I said "CPUfreq driver", not "CPUfreq governor". Certainly the scheduler
> can pick a capacity state/p-state/frequency and, in doing so, replace
> the CPUfreq policy bits.
> 
> My question above was about the necessity to select the right CPUfreq
> driver at compile-time and lose support for those drivers to be loadable
> modules. Sounds like a bad idea.

Drivers should not care one way or another.
