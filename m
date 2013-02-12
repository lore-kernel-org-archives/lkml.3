Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab3BLMPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 07:15:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58211 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759190Ab3BLMPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 07:15:19 -0500
Message-ID: <1360671314.4657.234.camel@marge.simpson.net>
Subject: Re: [PATCH] sched/rt: Unthrottle the highest RT task of the rq if
 there are no another available tasks to be picked
From: Mike Galbraith <bitbucket@online.de>
To: Stanislav Meduna <stano@meduna.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Tue, 12 Feb 2013 13:15:14 +0100
In-Reply-To: <5119F967.3040302@meduna.org>
References: <2260671360618316@web22h.yandex.ru>
	 <1360652809.4657.87.camel@marge.simpson.net> <5119F967.3040302@meduna.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:jkIN87xgKZVAOE6LUT4POikBddBK2q7x+oi4csZ6+Aw
 DeIO5JIbudbJUNLt0VDaVTDX7D4ZP2u7/gmQ6D05bRbhS191ll
 EoefETU13itECRVqVCCWiXVdPpddBDuYXyLifYF79qnIRi26BL
 M9kQSaDWKQWqRjymAIShxrBCFu41xhq1J8pCkDRGCkQMqbHl9s
 dp4/cSNvkWF5G6HCvD751gwZtsH6Yvp9M8DcUCpU/HPpcEEd4D
 zHTsl+Jt7kzFXaOeh2bxAW8oZOcGJb9mjhuaSoP1rj+xGcUIh2
 bJkdCYpeOAsxwO2Nv452rg/7zMbp/0+G6ZUo5QWOHjqaWeLK2x
 cGVV5T/VVHx9L7K64GopfyyMEcWe7vBMe0mMuoAeGRXA+KjC8T
 UgrHx6Q9ARbkA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 09:12 +0100, Stanislav Meduna wrote: 
> On 12.02.2013 08:06, Mike Galbraith wrote:
> 
> >> In this case pick_next_task takes idle tasks and idle wastes cpu
> >> time.
> 
> > That's not a waste of CPU time, that's utilization enforcement the thing
> > it is designed to do.
> 
> Well this is a philosophical question and the opinions will IMHO
> vary strongly. If the throttling kicks in, the system already
> is in the out-of-spec state.

Exactly, please don't feed the wild eyed psychopaths ;-)

> Is the goal now just to allow
> e.g. the ssh login to be able to kill the task and still try
> to do the best if otherwise (possibly masking the problem for
> months), or is it to enforce the utilization?

Both.  It has two modes of enforcement, sane mode is I WILL constrain
this thing you turned loose should it acts up, and not so sane mode,
where borrowing a cup of CPU from the neighbors is ok.  Workqueues.

> For example we have a PLC software where the end-user develops
> an application that will be executed in our realtime task.
> The application usually has a longer initialization part where
> the excess utilization can happen and should be tolerated
> and the running part where it is a bug if it happens. Here
> I would prefer the throttling to alert the user, but not
> to actually throttle if there is no non-RT task actually
> wanting to run. In other cases I would maybe prefer even
> killing the task, alerting the user to the fact.

That's not in the throttles job description.  It's not a monitor and
report system, it's a constraint system for very dangerous beasts.

> I have a related question: is the information that the throttling
> happened available somewhere except the log (where it gets only
> written once)? If not, would a patch exporting the count
> of throttlings via /sys be accepted?

I'm not the maintainer, so can't say.  Seems to me a trace point would
be better though.

-Mike

