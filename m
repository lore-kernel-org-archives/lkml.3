Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab3KSHGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 02:06:03 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:43023 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab3KSHGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 02:06:00 -0500
Date: Tue, 19 Nov 2013 08:05:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Marek Belisko <marek@goldelico.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH/RFC] wait_for_completion_timeout() considered harmful.
Message-ID: <20131119070557.GD32367@gmail.com>
References: <20131117080603.2a0d3b6d@notabene.brown>
 <20131118152746.937b2b7971d7a4bba4ef996d@linux-foundation.org>
 <20131118234209.GO16796@laptop.programming.kicks-ass.net>
 <20131118174902.312d8fa6@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118174902.312d8fa6@lwn.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jonathan Corbet <corbet@lwn.net> wrote:

> On Tue, 19 Nov 2013 00:42:09 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > I briefly talked to Thomas about this earlier today and we need to 
> > fix this at a lower level -- the quick 'n dirty solution is to add 
> > 1 jiffy down in the timer-wheel when we enqueue these things.
> 
> That can lead to situations like the one I encountered years ago 
> where msleep(1) would snooze for 20ms.  I didn't get much love for 
> my idea of switching msleep() to hrtimers back then, but I still 
> think it might be be better to provide the resolution that the 
> interface appears to promise.

That looks like a sensible approach - mind resending that patch? We 
can put it into the timer tree and see what happens.

Thanks,

	Ingo
