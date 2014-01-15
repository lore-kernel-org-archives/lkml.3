Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaAOHgC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 02:36:02 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56628 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaAOHf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 02:35:59 -0500
Date: Wed, 15 Jan 2014 08:35:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@linaro.org>
Cc: mingo@redhat.com, tglx@linutronix.de, daniel.lezcano@linaro.org,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org
Subject: Re: [RFC PATCH] sched: find the latest idle cpu
Message-ID: <20140115073533.GU31570@twins.programming.kicks-ass.net>
References: <1389758879-19951-1-git-send-email-alex.shi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389758879-19951-1-git-send-email-alex.shi@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 12:07:59PM +0800, Alex Shi wrote:
> Currently we just try to find least load cpu. If some cpus idled,
> we just pick the first cpu in cpu mask.
> 
> In fact we can get the interrupted idle cpu or the latest idled cpu,
> then we may get the benefit from both latency and power.
> The selected cpu maybe not the best, since other cpu may be interrupted
> during our selecting. But be captious costs too much.

No, we should not do anything like this without first integrating
cpuidle.

At which point we have a sane view of the idle states and can make a
sane choice between them.
