Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbaGNPdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:33:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:40518 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbaGNPdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:33:15 -0400
Date: Mon, 14 Jul 2014 17:33:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 V2] workqueue: remove the del_timer_sync()s in
 maybe_create_worker()
In-Reply-To: <20140714142707.GB31610@htj.dyndns.org>
Message-ID: <alpine.DEB.2.10.1407141731240.24854@nanos>
References: <1405265479-827-1-git-send-email-laijs@cn.fujitsu.com> <1405325601-12437-1-git-send-email-laijs@cn.fujitsu.com> <1405325601-12437-2-git-send-email-laijs@cn.fujitsu.com> <20140714142707.GB31610@htj.dyndns.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014, Tejun Heo wrote:

> Hello,
> 
> On Mon, Jul 14, 2014 at 04:13:21PM +0800, Lai Jiangshan wrote:
> > It is said in the document that the timer which is being
> > deleted by del_timer_sync() should not be restarted:
> >   Synchronization rules: Callers must prevent restarting of
> >   the timer, otherwise this function is meaningless.
> > 
> > Repeating timer may cause the del_timer_sync() spin longer,
> > or even spin forever in very very very very extreme condition.
> 
> I'm fairly sure del_timer_sync() can delete self-requeueing timers.
> The implementation busy-waits if the queued timer is the currently
> executing one and dequeues only while the timer isn't running which
> should be able to handle self-requeueing ones just fine.  Thomas,
> del_timer_sync() can reliably delete self-requeueing ones, right?

Yes. If the timer callback is running on the other cpu, then it waits
for the callback to finish before checking whether the timer is
enqueued or not.

Thanks,

	tglx


