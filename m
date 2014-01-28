Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbaA1TPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:15:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34511 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557AbaA1TPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:15:11 -0500
Date: Tue, 28 Jan 2014 20:14:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: bsegall@google.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, daniel.lezcano@linaro.org,
        pjt@google.com, Steven Rostedt <rostedt@goodmis.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH 5/9] sched: Push put_prev_task() into pick_next_task()
Message-ID: <20140128191459.GF11314@laptop.programming.kicks-ass.net>
References: <20140128171634.974847076@infradead.org>
 <20140128171948.149077289@infradead.org>
 <xm264n4oj66d.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xm264n4oj66d.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 10:46:18AM -0800, bsegall@google.com wrote:
> > @@ -4734,7 +4729,7 @@ static void migrate_tasks(unsigned int d
> >  		if (rq->nr_running == 1)
> >  			break;
> >  
> > -		next = pick_next_task(rq);
> > +		next = pick_next_task(rq, NULL);
> 
> This seems to be incorrect without the if (prev) lines in
> pick_next_task_foo, since foo_nr_running isn't enough to save us.

ARgh, I knew there must've been a reason I had those :/
