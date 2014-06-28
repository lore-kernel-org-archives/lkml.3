Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaF1HLX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 03:11:23 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:47760 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaF1HLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 03:11:22 -0400
Message-ID: <1403939478.5930.30.camel@marge.simpson.net>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Austin Schuh <austin@peloton-tech.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>
Date: Sat, 28 Jun 2014 09:11:18 +0200
In-Reply-To: <CANGgnMbJ9f4gSz0HbtnCLosYHKyfXwhMt-svUQbBe_d9bv2LGQ@mail.gmail.com>
References: <CANGgnMbHckBQdKGN_N5Q6qEKc9n1CenxvMpeXog1NbSdL8UrTw@mail.gmail.com>
	 <CANGgnMYDXerOUDOO9-RHMJKadKACA2KBGskZwoP-1ZwAhDEfVA@mail.gmail.com>
	 <CAFLxGvxfBt7OvW=a2Kz08GLHSEiiOZsN-vB19CXnQiwqFxqMsA@mail.gmail.com>
	 <CANGgnMYVoP-Z0Bv-VDEkJnvfa7Fi4-zY2F4A0PhMewGvwo3VVw@mail.gmail.com>
	 <alpine.DEB.2.10.1406270027300.5170@nanos>
	 <CANGgnMa+qtgJ3wwg_h5Rynw5vEvZpQZ6PvaUfXNQ8+Y3Yu5U0g@mail.gmail.com>
	 <1403873856.5827.56.camel@marge.simpson.net>
	 <20140627100157.6b0143a5@gandalf.local.home>
	 <1403890493.5830.33.camel@marge.simpson.net>
	 <20140627135415.7246e87e@gandalf.local.home>
	 <1403892474.5830.41.camel@marge.simpson.net>
	 <20140627141903.16817c28@gandalf.local.home>
	 <CANGgnMZrx1s5AomG-L_F74215RE1uJOekTjYmLX0voG4NgakTg@mail.gmail.com>
	 <1403926333.5113.12.camel@marge.simpson.net>
	 <CANGgnMbJ9f4gSz0HbtnCLosYHKyfXwhMt-svUQbBe_d9bv2LGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-27 at 23:20 -0700, Austin Schuh wrote:

> For workqueues, as long as the helper doesn't block on a lock which
> requires the work queue to be freed up, it will eventually become
> unblocked and make progress.  The helper _should_ only need the pool
> lock, which will wake the helper back up when it is available again.
> Nothing should go to sleep in an un-recoverable way with the work pool
> lock held.

Well, Thomas killed taking a lock from within the core of a lock, so
that wart shrank back to microscopic.  Applying that same ointment to
the plug puller gizmo and schedule_work() would be most excellent.

-Mike

