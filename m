Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaFJRnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:43:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:54342 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbaFJRnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:43:19 -0400
Date: Tue, 10 Jun 2014 19:43:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Brad Mouring <bmouring@ni.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [patch V3 7/7] rtmutex: Avoid pointless requeueing in the deadlock
 detection chain walk
In-Reply-To: <20140610111942.668d4058@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406101943000.5170@nanos>
References: <20140609201118.387571774@linutronix.de> <20140609202336.506044876@linutronix.de> <20140610145725.GA29976@linuxgetsreal> <20140610111942.668d4058@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Steven Rostedt wrote:

> On Tue, 10 Jun 2014 09:57:25 -0500
> "Brad Mouring" <bmouring@ni.com> wrote:
> 
> 
> > > +		/* Store whether owner is blocked itself and drop locks */
> > > +		next_lock = task_blocked_on(task);
> > task_blocked_on(task) is not clear to me, the recipient of the
> > return is the only clue that hints at what the function does.
> 
> Well, this is more than confusing, it's the only user, all other users
> are task_blocked_on_lock(), and this causes the code not to compile.

Grr, yes.
