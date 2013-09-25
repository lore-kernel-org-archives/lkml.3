Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab3IYOHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:07:35 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:26284 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755447Ab3IYOHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:07:33 -0400
Date: Wed, 25 Sep 2013 10:07:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Peter Hurley <peter@hurleysoftware.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>, Dave Airlie <airlied@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: BUG: sleeping function called from invalid context on
 3.10.10-rt7
Message-ID: <20130925100730.0b63628e@gandalf.local.home>
In-Reply-To: <523CC728.4040302@tuebingen.mpg.de>
References: <20130911102809.GA31663@uudg.org>
	<20130911092623.42efd930@gandalf.local.home>
	<5230895B.5070400@hurleysoftware.com>
	<20130911113845.6d56a556@gandalf.local.home>
	<5230C52E.3050801@hurleysoftware.com>
	<5238B288.3000704@hurleysoftware.com>
	<CAKMK7uG9s8W6yebkmuJe0XHGsoru4_9FzGqfmKWtMFyCAfQZqA@mail.gmail.com>
	<523CC728.4040302@tuebingen.mpg.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for the late reply, I was at Linux Plumbers, and had a bunch of
stuff to catch up on when I returned.

On Sat, 21 Sep 2013 00:07:36 +0200
Mario Kleiner <mario.kleiner@tuebingen.mpg.de> wrote:

 
> Steven, would it then be acceptable to convert that "faster" lock into a 
> raw_spinlock_t or is this unacceptable? If so, the preempt_disable() 
> could stay, right?

If a spinlock is tight (not held for more than 2us on todays
processors), and has little contention, than I would be fine with
converting it to raw. And if that's the only lock held you could do the
preempt_disable() call.

In fact, if you want, you can leave the preempt_disable() out of
mainline, and send a patch to us that uses "preempt_disable_rt()" and
add a comment to it. In the -rt patch, preempt_disable_rt() is a nop
when PREEMPT_RT is not set, and is preempt_disable() when it is.


-- Steve
