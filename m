Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab3JNNeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:34:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56760 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab3JNNeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:34:14 -0400
Date: Mon, 14 Oct 2013 15:33:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: mingo@kernel.org, pjt@google.com, arjan@linux.intel.com, rjw@sisk.pl,
        dirk.j.brandewie@intel.com, vincent.guittot@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        corbet@lwn.net, tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 4/7] sched: power: Remove power capacity hints for
 kworker threads
Message-ID: <20131014133356.GN3081@twins.programming.kicks-ass.net>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
 <1381511957-29776-5-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381511957-29776-5-git-send-email-morten.rasmussen@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 06:19:14PM +0100, Morten Rasmussen wrote:
> Removing power hints for kworker threads enables easier use of
> workqueues in the power driver late callback. That would otherwise
> lead to an endless loop unless it is prevented in the power driver.

There's many kworker users; some of them actually consume lots of
cputime. Therefore how did you come to the conclusion that excepting all
users was the better choice of a little added complexity in the one
place where it actually matters?
