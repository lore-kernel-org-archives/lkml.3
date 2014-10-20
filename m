Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaJTI4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:56:41 -0400
Received: from relay.parallels.com ([195.214.232.42]:34901 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaJTI4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:56:38 -0400
Message-ID: <1413795392.19914.14.camel@tkhai>
Subject: Re: [PATCH] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
From: Kirill Tkhai <ktkhai@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <tkhai@yandex.ru>, Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Date: Mon, 20 Oct 2014 12:56:32 +0400
In-Reply-To: <20141019213821.GH23531@worktop.programming.kicks-ass.net>
References: <1413376300.24793.55.camel@tkhai>
	 <20141017213641.GB32576@redhat.com> <4323181413620101@web21o.yandex.ru>
	 <20141018205614.GA15934@redhat.com> <33631413674011@web7o.yandex.ru>
	 <20141019213821.GH23531@worktop.programming.kicks-ass.net>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Вс, 19/10/2014 в 23:38 +0200, Peter Zijlstra пишет:
> On Sun, Oct 19, 2014 at 03:13:31AM +0400, Kirill Tkhai wrote:
> 
> I'm too tired for all this, but:
> 
> > +	smp_rmb(); /* Pairs with dst_rq->lock unlocking which implies smp_wmb */
> 
> RELEASE does not imply a WMB.

Thanks, please see, I've sent new version.

