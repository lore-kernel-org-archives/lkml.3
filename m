Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaFJRv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:51:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:37602 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752440AbaFJRv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:51:26 -0400
Date: Tue, 10 Jun 2014 13:51:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Brad Mouring <bmouring@ni.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [patch V3 7/7] rtmutex: Avoid pointless requeueing in the
 deadlock detection chain walk
Message-ID: <20140610135125.2a9190ec@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1406101943000.5170@nanos>
References: <20140609201118.387571774@linutronix.de>
	<20140609202336.506044876@linutronix.de>
	<20140610145725.GA29976@linuxgetsreal>
	<20140610111942.668d4058@gandalf.local.home>
	<alpine.DEB.2.10.1406101943000.5170@nanos>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014 19:43:16 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 10 Jun 2014, Steven Rostedt wrote:
> 
> > On Tue, 10 Jun 2014 09:57:25 -0500
> > "Brad Mouring" <bmouring@ni.com> wrote:
> > 
> > 
> > > > +		/* Store whether owner is blocked itself and drop locks */
> > > > +		next_lock = task_blocked_on(task);
> > > task_blocked_on(task) is not clear to me, the recipient of the
> > > return is the only clue that hints at what the function does.
> > 
> > Well, this is more than confusing, it's the only user, all other users
> > are task_blocked_on_lock(), and this causes the code not to compile.
> 
> Grr, yes.

Luckily you are not posting this to that grumpy IRQ maintainer. He'd
shoot some frozen sharks your way if you sent him patches like this ;-)

-- Steve
