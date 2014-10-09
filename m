Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaJIRic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:38:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:41470 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaJIRi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:38:26 -0400
Date: Thu, 9 Oct 2014 19:38:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tuukka.tikkanen@linaro.org" <tuukka.tikkanen@linaro.org>
Subject: Re: [PATCH RFC 2/2] cpufreq: arm_big_little: provide cpu capacity
Message-ID: <20141009173823.GA10832@worktop.programming.kicks-ass.net>
References: <20141008060712.4379.42509@quantum>
 <1412749572-29449-1-git-send-email-mturquette@linaro.org>
 <1412749572-29449-3-git-send-email-mturquette@linaro.org>
 <20141008154851.GF1788@e105550-lin.cambridge.arm.com>
 <20141008223732.4379.78047@quantum>
 <20141009090252.GS10832@worktop.programming.kicks-ass.net>
 <20141009172513.4379.56718@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009172513.4379.56718@quantum>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 10:25:13AM -0700, Mike Turquette wrote:
> Quoting Peter Zijlstra (2014-10-09 02:02:52)
> > On Wed, Oct 08, 2014 at 03:37:32PM -0700, Mike Turquette wrote:
> > > It creates a dependency such that any ARM platform that wants to have
> > > frequency-invariant load must use CPUfreq. I don't think we want that
> > > dependency. CPUfreq is a likely back-end for many devices, but not all.
> > > 
> > > Consider near-future ARM devices that support ACPI for power management
> > > with no corresponding CPUfreq driver. For example if the CPPC driver is
> > > not hooked up to CPUfreq, platforms using CPPC will not jive with the
> > > ARM arch hook that depends on CPUfreq.
> > 
> > Oh crap no, CPPC will not add yet another interface to cpu frequency
> > stuff.
> 
> Right.
> 
> So let's say the ARM arch hook creates a dependency on CPUfreq to scale
> capacity as a function of cpu frequency (as it does in the ARM scale
> invariance series).
> 
> Then let's say that a hypothetical ARM platform named "foo" uses CPPC
> and not CPUfreq to scale frequency. Foo's implementation of CPPC does
> not use any of the full-auto or hw-auto stuff. It allows the OS to
> request minimum performance levels and the like.
> 
> In this case, how can foo take advantage of the scale invariant stuff?
> 
> Also, feel free to replace "CPPC" with "anything other than CPUfreq".
> The problem is a general one and not specific to CPPC or ACPI.

Well answer #1 is that you simply should not ever bypass cpufreq for
setting cpu frequencies (be this the existing cpufreq or the future
integrated cpufreq).

Answer #2 is that if you were allowed to create a second infrastructure
and you're not calling the right scheduler hooks right along with it,
you're buggy.

In short, your problem, not mine.
