Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaAQPX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:23:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37642 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbaAQPXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:23:55 -0500
Date: Fri, 17 Jan 2014 16:23:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, alex.shi@linaro.org
Subject: Re: [PATCH 4/4] sched: Idle task shortcut optimization
Message-ID: <20140117152352.GL11314@laptop.programming.kicks-ass.net>
References: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org>
 <1389949444-14821-4-git-send-email-daniel.lezcano@linaro.org>
 <20140117140939.GH11314@laptop.programming.kicks-ass.net>
 <52D947B3.3010601@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D947B3.3010601@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 04:09:39PM +0100, Daniel Lezcano wrote:
> On 01/17/2014 03:09 PM, Peter Zijlstra wrote:
> >On Fri, Jan 17, 2014 at 10:04:04AM +0100, Daniel Lezcano wrote:
> >>+	schedstat_inc(rq, sched_goidle);
> >>+#ifdef CONFIG_SMP
> >>+	/* Trigger the post schedule to do an idle_enter for CFS */
> >>+	rq->post_schedule = 1;
> >>+#endif
> >>+	return rq->idle;
> >
> >Urgh, that retains the stupid idle crap like it is.
> >
> >I've not yet tested this, but is there a reason something like the below
> >couldn't work?
> 
> I tested it by running hackbench and it seems to work as expected.

Thanks, I was still looking through the throttling. I'll keep it then
:-)
