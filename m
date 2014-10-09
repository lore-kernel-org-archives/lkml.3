Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbaJIJC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:02:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:38518 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbaJIJCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:02:53 -0400
Date: Thu, 9 Oct 2014 11:02:52 +0200
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
Message-ID: <20141009090252.GS10832@worktop.programming.kicks-ass.net>
References: <20141008060712.4379.42509@quantum>
 <1412749572-29449-1-git-send-email-mturquette@linaro.org>
 <1412749572-29449-3-git-send-email-mturquette@linaro.org>
 <20141008154851.GF1788@e105550-lin.cambridge.arm.com>
 <20141008223732.4379.78047@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008223732.4379.78047@quantum>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 03:37:32PM -0700, Mike Turquette wrote:
> It creates a dependency such that any ARM platform that wants to have
> frequency-invariant load must use CPUfreq. I don't think we want that
> dependency. CPUfreq is a likely back-end for many devices, but not all.
> 
> Consider near-future ARM devices that support ACPI for power management
> with no corresponding CPUfreq driver. For example if the CPPC driver is
> not hooked up to CPUfreq, platforms using CPPC will not jive with the
> ARM arch hook that depends on CPUfreq.

Oh crap no, CPPC will not add yet another interface to cpu frequency
stuff.
