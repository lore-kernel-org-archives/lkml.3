Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab3FRKFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:05:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39989 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab3FRKFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:05:45 -0400
Date: Tue, 18 Jun 2013 12:05:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] spin_unlock*_no_resched()
Message-ID: <20130618100541.GN3204@twins.programming.kicks-ass.net>
References: <1022041371038807@web30d.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1022041371038807@web30d.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 04:06:47PM +0400, Kirill Tkhai wrote:
> There are many constructions like:
> 
> 	spin_unlock_irq(lock);
> 	schedule();
> 
> In case of preemptible kernel we check if task needs reschedule
> at the end of spin_unlock(). So if TIF_NEED_RESCHED is set
> we call schedule() twice and we have a little overhead here.
> Add primitives to avoid these situations.
> 

Aside from the excellent comments you received from Steven, please also
include a patch that converts some (if not all) of these many callsites
you found so that there's a user of the new code in the kernel.

That way we can simply build + run the kernel and have more confidence
things work as supposed.
