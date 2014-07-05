Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbaGEU1A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 16:27:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:41353 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbaGEU07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 16:26:59 -0400
Date: Sat, 5 Jul 2014 22:26:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Austin Schuh <austin@peloton-tech.com>
cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
In-Reply-To: <CANGgnMbhYB4VY+4L7qrWvRomi6tRjK+7hs7qBXzsDLND_sjpFA@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1407052226300.22031@nanos>
References: <CANGgnMbHckBQdKGN_N5Q6qEKc9n1CenxvMpeXog1NbSdL8UrTw@mail.gmail.com> <CANGgnMYDXerOUDOO9-RHMJKadKACA2KBGskZwoP-1ZwAhDEfVA@mail.gmail.com> <CAFLxGvxfBt7OvW=a2Kz08GLHSEiiOZsN-vB19CXnQiwqFxqMsA@mail.gmail.com> <CANGgnMYVoP-Z0Bv-VDEkJnvfa7Fi4-zY2F4A0PhMewGvwo3VVw@mail.gmail.com>
 <alpine.DEB.2.10.1406270027300.5170@nanos> <CANGgnMa+qtgJ3wwg_h5Rynw5vEvZpQZ6PvaUfXNQ8+Y3Yu5U0g@mail.gmail.com> <alpine.DEB.2.10.1406271249510.5170@nanos> <CANGgnMYcSoJa32CdGBxvj0c3NEnU=S=DD35YmZAtn8miCtK6kw@mail.gmail.com>
 <CANGgnMbhYB4VY+4L7qrWvRomi6tRjK+7hs7qBXzsDLND_sjpFA@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014, Austin Schuh wrote:
> I think I might have an answer for my own question, but I would
> appreciate someone else to double check.  If list_empty erroneously
> returns that there is work to do when there isn't work to do, we wake
> up an extra worker which then goes back to sleep.  Not a big loss.  If
> list_empty erroneously returns that there isn't work to do when there
> is, this should only be because someone is modifying the work list.
> When they finish, as far as I can tell, all callers then check to see
> if a worker needs to be started up, and start one.

Precisely.
