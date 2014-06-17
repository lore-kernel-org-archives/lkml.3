Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbaFQOTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:19:48 -0400
Received: from forward18.mail.yandex.net ([95.108.253.143]:48505 "EHLO
	forward18.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932915AbaFQOTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:19:47 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
In-Reply-To: <1401396751.1628.4.camel@localhost.localdomain>
References: <5362122B.8060305@yandex.ru>
	  <alpine.DEB.2.02.1405032041460.6261@ionos.tec.linutronix.de>
	 <1399314660.6978.3.camel@localhost.localdomain>
	 <alpine.DEB.2.10.1405282157100.3952@nanos> <1401396751.1628.4.camel@localhost.localdomain>
Subject: Re: [RFC] rtmutex: Do not boost fair tasks each other
MIME-Version: 1.0
Message-Id: <4717441403014772@web18g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 17 Jun 2014 18:19:32 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thomas,

have you seen this version?

Thanks,
Kirill

30.05.2014, 00:52, "Kirill Tkhai" <tkhai@yandex.ru>:
> ÷ óÒ, 28/05/2014 × 22:26 +0200, Thomas Gleixner ÐÉÛÅÔ:
>> šOn Mon, 5 May 2014, Kirill Tkhai wrote:
>>> š÷ óÂ, 03/05/2014 × 20:54 +0200, Thomas Gleixner ÐÉÛÅÔ:
>>>> šThough exercising that code path as much as we can is not a bad thing
>>>> šeither. So I'd like to see that made compile time conditional on one
>>>> šof the lock testing CONFIG items.
>>> š+#ifndef CONFIG_RT_MUTEX_BOOST_ALL
>> šNo, not another pointless config option. Read what I said. What's
>> šwrong with using an existing config item, e.g DEBUG_RT_MUTEXES?
>>> š+#define heritable_prio(prio) (rt_prio(prio) || dl_prio(prio))
>> šinheritable please. It's not priority heritance and never will be.
>
> Thanks for comments. Here is new version.
>
> [PATCH] rtmutex: Do not boost owner's prio if waiter is SCHED_OTHER
>
> Higher priority does not provide exclusive privilege
> of one fair class task over the other. In this case
> priority boosting is pointless, and it may worsen
> performance.
>
> This patch makes boosting, which is requested by fair
> class waiters, optional. It's disabled by default, but
> it's possible to enable it for debugging purposes to
> have more cases of priority inheritance.
>
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
>
> škernel/locking/rtmutex.c | 28 +++++++++++++++++++++-------
> š1 file changed, 21 insertions(+), 7 deletions(-)
