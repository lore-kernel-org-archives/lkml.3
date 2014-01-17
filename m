Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaAQNdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:33:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34247 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbaAQNdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:33:17 -0500
Date: Fri, 17 Jan 2014 14:33:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, alex.shi@linaro.org
Subject: Re: [PATCH 2/4] sched: Fix race in idle_balance()
Message-ID: <20140117133311.GG11314@laptop.programming.kicks-ass.net>
References: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org>
 <1389949444-14821-2-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389949444-14821-2-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 10:04:02AM +0100, Daniel Lezcano wrote:
> The scheduler main function 'schedule()' checks if there are no more tasks
> on the runqueue. Then it checks if a task should be pulled in the current
> runqueue in idle_balance() assuming it will go to idle otherwise.
> 
> But the idle_balance() releases the rq->lock in order to lookup in the sched
> domains and takes the lock again right after. That opens a window where
> another cpu may put a task in our runqueue, so we won't go to idle but
> we have filled the idle_stamp, thinking we will.
> 
> This patch closes the window by checking if the runqueue has been modified
> but without pulling a task after taking the lock again, so we won't go to idle
> right after in the __schedule() function.

Did you actually observe this or was it found by reading the code?
