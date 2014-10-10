Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaJJJOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:14:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:45163 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaJJJOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:14:44 -0400
Date: Fri, 10 Oct 2014 11:14:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@redhat.com,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        mturquette@linaro.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] sched: Introduce scale-invariant load tracking
Message-ID: <20141010091441.GF10832@worktop.programming.kicks-ass.net>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
 <1411403047-32010-2-git-send-email-morten.rasmussen@arm.com>
 <20141008005007.GA7017@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008005007.GA7017@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 08:50:07AM +0800, Yuyang Du wrote:
> Hi Morten,
> 
> Sorry for late jumping in.
> 
> The problem seems to be self-evident. But for the implementation to be
> equally attractive it needs to account for every freq change for every task,
> or anything less than that makes it less attractive.

I'm not entirely sure that is indeed required.

> But this should be very hard. Intel Architecture has limitation to capture all
> the freq changes in software and also the intel_pstate should have no
> notification.

So current Intel arch takes P-states as hints and then can mostly lower
their actual frequency, right? In this case still accounting at the
higher frequency is not a problem, the hardware conserves more power
than we know, but that's the right kind of error to have :-)

For the full automatic hardware, that's basically hardware without DVFS
capability so we should not bother at all and simply disable this
scaling.

> For every task, this makes the updating of the entire queue in load tracking
> more needed, so once again, ping maintainers for the rewrite patches, :)

Could you remind me what your latest version is; please reply to those
patches with a new email so that I can more conveniently locate it.
