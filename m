Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaJSVi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 17:38:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:41974 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaJSViY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 17:38:24 -0400
Date: Sun, 19 Oct 2014 23:38:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Oleg Nesterov <oleg@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
Message-ID: <20141019213821.GH23531@worktop.programming.kicks-ass.net>
References: <1413376300.24793.55.camel@tkhai>
 <20141017213641.GB32576@redhat.com>
 <4323181413620101@web21o.yandex.ru>
 <20141018205614.GA15934@redhat.com>
 <33631413674011@web7o.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33631413674011@web7o.yandex.ru>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 03:13:31AM +0400, Kirill Tkhai wrote:

I'm too tired for all this, but:

> +	smp_rmb(); /* Pairs with dst_rq->lock unlocking which implies smp_wmb */

RELEASE does not imply a WMB.
