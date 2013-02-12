Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437Ab3BLOqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:46:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25994 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759743Ab3BLOqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:46:20 -0500
X-Authority-Analysis: v=2.0 cv=f8jK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=rOv3JLMg7xwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=BPVqIK5J9eQA:10 a=5-8zOE42ewE3rZXYn4MA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360680378.21867.8.camel@gandalf.local.home>
Subject: Re: [PATCH] sched/rt: Unthrottle the highest RT task of the rq if
 there are no another available tasks to be picked
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Kirill Tkhai <tkhai@yandex.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Tue, 12 Feb 2013 09:46:18 -0500
In-Reply-To: <1360652809.4657.87.camel@marge.simpson.net>
References: <2260671360618316@web22h.yandex.ru>
	 <1360652809.4657.87.camel@marge.simpson.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 08:06 +0100, Mike Galbraith wrote:
> On Tue, 2013-02-12 at 01:31 +0400, Kirill Tkhai wrote: 
> > It's possible a situation when rq->rt is throttled or
> > it has no child entities and there are RT tasks ready
> > for execution in the rq which are the only tasks
> > of TASK_RUNNING state. In this case pick_next_task
> > takes idle tasks and idle wastes cpu time.
> 
> That's not a waste of CPU time, that's utilization enforcement the thing
> it is designed to do.  I'd rather see borrowing go away, bodyguard being
> either a ruthless thug who may save your bacon, or unemployed.  AFAIKT,
> the throttle is useless in any other role, just having it standing
> around glaring across the room occasionally can turn sensitive realtime
> into a quaking heap of jello.

I guess what Mike is saying is, you can do a bunch of tests, and if it
happens to throttle, you wont notice because the system happened to be
idle.

Now if you are running in production, and hit the throttle, where
there's tasks to run, you're production system just went *THUNK*.

Now in argument for the "borrowing" of idle, I do believe that the
throttle does still occur, and you get a nasty output on the console.
But not everyone reads those.

-- Steve

