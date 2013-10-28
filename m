Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab3J1PQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:16:42 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:45409 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab3J1PQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:16:41 -0400
Date: Mon, 28 Oct 2013 16:16:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
Message-ID: <20131028151637.GA13251@gmail.com>
References: <525BD08C.2080101@t-online.de>
 <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
 <CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com>
 <alpine.DEB.2.02.1310251221310.5266@ionos.tec.linutronix.de>
 <CA+55aFxw1Hm4QVeEigkByP5RppSL30oHnLoR16C=henf-a=uFQ@mail.gmail.com>
 <20131026114303.GA24067@gmail.com>
 <526E79A2.9080303@t-online.de>
 <20131028150114.GA12905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028150114.GA12905@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> > I tried that patch, together with all the kobj debug options 
> > enabled. With that kernel configuration I was unable to 
> > reproduce the problem during 500 typical workload / reboot 
> > cycles. Without the debug options I was able to reproduce the 
> > last reported panic after 91 cycles. The debug options seem to 
> > change timing sufficiently to mask the bug ;-(
> 
> Could you send me the kernel config please?

I got your .config off-list, thanks Knut!

It has all DEBUG_OBJECT options enabled:

 CONFIG_DEBUG_OBJECTS=y
 # CONFIG_DEBUG_OBJECTS_SELFTEST is not set
 CONFIG_DEBUG_OBJECTS_FREE=y
 CONFIG_DEBUG_OBJECTS_TIMERS=y
 CONFIG_DEBUG_OBJECTS_WORK=y
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
 CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
 CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1

but it also has DEBUG_PAGEALLOC enabled:

 CONFIG_DEBUG_PAGEALLOC=y

I'd suggest disabling that one - it kind of overlaps debugobjects 
and it will definitely be a big slowdown.

I'd also suggest turning off lockdep for now:

 CONFIG_PROVE_LOCKING=y

because we know it does not trigger any useful warning. This too 
should speed up things a bit.

Whether this would make the crash reproducable again I don't know
:-/

Thanks,

	Ingo
