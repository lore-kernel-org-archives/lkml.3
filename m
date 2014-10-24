Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbaJXN4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:56:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36049 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658AbaJXN4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:56:11 -0400
Date: Fri, 24 Oct 2014 15:56:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: rjw@rjwysocki.net, nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 3/5] cpuidle: idle: menu: Don't reflect when a state
 selection failed
Message-ID: <20141024135606.GD21513@worktop.programming.kicks-ass.net>
References: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org>
 <1413822343-1972-3-git-send-email-daniel.lezcano@linaro.org>
 <20141024133810.GK12706@worktop.programming.kicks-ass.net>
 <544A5799.7020405@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544A5799.7020405@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 03:43:53PM +0200, Daniel Lezcano wrote:
> On 10/24/2014 03:38 PM, Peter Zijlstra wrote:
> >On Mon, Oct 20, 2014 at 06:25:41PM +0200, Daniel Lezcano wrote:
> >>+++ b/kernel/sched/idle.c
> >>@@ -162,7 +162,8 @@ use_default:
> >>  	/*
> >>  	 * Give the governor an opportunity to reflect on the outcome
> >>  	 */
> >>-	cpuidle_reflect(dev, entered_state);
> >>+	if (entered_state >= 0)
> >>+		cpuidle_reflect(dev, entered_state);
> >>
> >
> >Given we'll do use_default: when next_state < 0, we actually never get
> >here unless this is true.
> 
> There is the 'cpuidle_enter' call in between which may fail.

Hmm, indeed there is. I had not expected that one to fail like this.
