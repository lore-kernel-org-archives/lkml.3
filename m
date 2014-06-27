Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaF0RfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 13:35:00 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:45398 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaF0Re5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 13:34:57 -0400
Message-ID: <1403890493.5830.33.camel@marge.simpson.net>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Austin Schuh <austin@peloton-tech.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>
Date: Fri, 27 Jun 2014 19:34:53 +0200
In-Reply-To: <20140627100157.6b0143a5@gandalf.local.home>
References: <CANGgnMbHckBQdKGN_N5Q6qEKc9n1CenxvMpeXog1NbSdL8UrTw@mail.gmail.com>
	 <CANGgnMYDXerOUDOO9-RHMJKadKACA2KBGskZwoP-1ZwAhDEfVA@mail.gmail.com>
	 <CAFLxGvxfBt7OvW=a2Kz08GLHSEiiOZsN-vB19CXnQiwqFxqMsA@mail.gmail.com>
	 <CANGgnMYVoP-Z0Bv-VDEkJnvfa7Fi4-zY2F4A0PhMewGvwo3VVw@mail.gmail.com>
	 <alpine.DEB.2.10.1406270027300.5170@nanos>
	 <CANGgnMa+qtgJ3wwg_h5Rynw5vEvZpQZ6PvaUfXNQ8+Y3Yu5U0g@mail.gmail.com>
	 <1403873856.5827.56.camel@marge.simpson.net>
	 <20140627100157.6b0143a5@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-27 at 10:01 -0400, Steven Rostedt wrote:

> This seems like a lot of hacks.

It is exactly that, lacking proper pooper-scooper, show rt kernel how to
not step in it.

> I'm wondering if it would work if we
> just have the rt_spin_lock_slowlock not call schedule(), but call
> __schedule() directly. I mean it would keep with the mainline paradigm
> as spinlocks don't sleep there, and one going to sleep in the -rt
> kernel is similar to it being preempted by a very long NMI.

Problem being that we do sleep there, do need wakeup.  I have a hack
that turns them back into spinning locks, but it.. works too :)

> Does a spin_lock going to sleep really need to do all the presched and
> postsched work?

It would be lovely if we didn't have to do any of that.  On the IO bit,
I haven't seen hard evidence that the spinlock bit is absolutely
required (better not be, it doesn't guarantee anything), but the
combined hack did kill IO deadlock of multiple filesystems.

-Mike

