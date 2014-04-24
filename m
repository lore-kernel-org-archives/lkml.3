Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaDXUYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 16:24:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43395 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaDXUYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 16:24:49 -0400
Date: Thu, 24 Apr 2014 22:24:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Roman Gushchin <klamm@yandex-team.ru>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>
Subject: Re: Real-time scheduling policies and hyper-threading
Message-ID: <20140424202443.GE26782@laptop.programming.kicks-ass.net>
References: <36851398363372@webcorp2g.yandex-team.ru>
 <20140424185858.GB26782@laptop.programming.kicks-ass.net>
 <968281398370612@web21g.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <968281398370612@web21g.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 12:16:52AM +0400, Kirill Tkhai wrote:
> 24.04.2014, 22:59, "Peter Zijlstra" <peterz@infradead.org>:
> 
> [snip]
> 
> >>  Does anyone use rt-scheduler for runtime-like cpu-bound tasks?
> >
> > So in general cpu bound tasks in the RT classes (FIFO/RR/DEADLINE) are
> > bad and can make the system go funny.
> >
> > For general system health it is important that various system tasks
> > (kthreads usually) can run. Many of these kthreads run at !rt prios, and
> > by having cpu bound tasks in rt prios they don't get to run.
> 
> One more word to this. I had such expirience on 2.6.33 kernel with RT patch
> and weak hardware (sparc32).
> 
> Networking was actively used and application did not use any IO operations.
> 
> User needs to set all RT priorities by himself. It's necessary to set RT
> priorities at least for softirqs and rcus. RT bandwidth must be switched
> off.
> 
> The most giving optimization, which I receive, was after rejection from NAPI
> for network adapters and splitting interrupt handler on hard and threadparts.
> In this case game with binding for everything strongly improves the picture
> for single problem.

Sure, it can be made to work, but you really need to know what you're
doing and you get to keep all pieces when it comes apart :-)
