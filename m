Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaDXU1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 16:27:12 -0400
Received: from forward17.mail.yandex.net ([95.108.253.142]:48128 "EHLO
	forward17.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaDXU1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 16:27:10 -0400
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2014 16:27:10 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: Peter Zijlstra <peterz@infradead.org>,
        Roman Gushchin <klamm@yandex-team.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>
In-Reply-To: <20140424185858.GB26782@laptop.programming.kicks-ass.net>
References: <36851398363372@webcorp2g.yandex-team.ru> <20140424185858.GB26782@laptop.programming.kicks-ass.net>
Subject: Re: Real-time scheduling policies and hyper-threading
MIME-Version: 1.0
Message-Id: <968281398370612@web21g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 25 Apr 2014 00:16:52 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

24.04.2014, 22:59, "Peter Zijlstra" <peterz@infradead.org>:

[snip]

>> šDoes anyone use rt-scheduler for runtime-like cpu-bound tasks?
>
> So in general cpu bound tasks in the RT classes (FIFO/RR/DEADLINE) are
> bad and can make the system go funny.
>
> For general system health it is important that various system tasks
> (kthreads usually) can run. Many of these kthreads run at !rt prios, and
> by having cpu bound tasks in rt prios they don't get to run.

One more word to this. I had such expirience on 2.6.33 kernel with RT patch
and weak hardware (sparc32).

Networking was actively used and application did not use any IO operations.

User needs to set all RT priorities by himself. It's necessary to set RT
priorities at least for softirqs and rcus. RT bandwidth must be switched
off.

The most giving optimization, which I receive, was after rejection from NAPI
for network adapters and splitting interrupt handler on hard and threadparts.
In this case game with binding for everything strongly improves the picture
for single problem.

Kirill
