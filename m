Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaBLLnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:43:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35115 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaBLLnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:43:09 -0500
Date: Wed, 12 Feb 2014 12:43:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:sched/core] sched: Push put_prev_task() into
 pick_next_task( )
Message-ID: <20140212114303.GC9987@twins.programming.kicks-ass.net>
References: <1328936700.2476.17.camel@laptop>
 <tip-606dba2e289446600a0b68422ed2019af5355c12@git.kernel.org>
 <124891392188453@web4h.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <124891392188453@web4h.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 11:00:53AM +0400, Kirill Tkhai wrote:
> > @@ -4748,7 +4743,7 @@ static void migrate_tasks(unsigned int dead_cpu)
> >                  if (rq->nr_running == 1)
> >                          break;
> >
> > - next = pick_next_task(rq);
> > + next = pick_next_task(rq, NULL);
> 
> pick_next_task() firstly checks for prev->sched_class, doesn't it ???
> 
> The same for pick_next_task_rt().

Right you are... and pick_next_task_dl(). Smatch caught the _{rt,dl}
ones, it failed to spot this one though.


