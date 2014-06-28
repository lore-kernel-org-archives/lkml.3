Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaF1DcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 23:32:18 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61949 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaF1DcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 23:32:16 -0400
Message-ID: <1403926333.5113.12.camel@marge.simpson.net>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Austin Schuh <austin@peloton-tech.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>
Date: Sat, 28 Jun 2014 05:32:13 +0200
In-Reply-To: <CANGgnMZrx1s5AomG-L_F74215RE1uJOekTjYmLX0voG4NgakTg@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-27 at 18:18 -0700, Austin Schuh wrote:

> It would be more context switches, but I wonder if we could kick the
> workqueue logic completely out of the scheduler into a thread.  Have
> the scheduler increment/decrement an atomic pool counter, and wake up
> the monitoring thread to spawn new threads when needed?  That would
> get rid of the recursive pool lock problem, and should reduce
> scheduler latency if we would need to spawn a new thread.

I was wondering the same thing, and not only for workqueue, but also the
plug pulling.  It's kind of a wart to have that stuff sitting in the
hear of the scheduler in the first place, would be nice if it just went
away.  When a task can't help itself, you _could_ wake a proxy do that
for you.  Trouble is, I can imagine that being a heck of a lot of
context switches with some loads.. and who's gonna help the helper when
he blocks while trying to help?

-Mike

