Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaEUX37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:29:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:45683 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbaEUX36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:29:58 -0400
Date: Thu, 22 May 2014 08:30:04 +0900 (JST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: linux-kernel@vger.kernel.org, shawn@churchofgit.com,
        akpm@linux-foundation.org, avagin@openvz.org, xemul@parallels.com,
        vdavydov@parallels.com
Subject: Re: [patch 3/3] timerfd: Implement write method
In-Reply-To: <20140521223511.GI12819@moon>
Message-ID: <alpine.DEB.2.02.1405220826460.9695@ionos.tec.linutronix.de>
References: <20140428212517.200264067@openvz.org> <20140428213301.507657833@openvz.org> <alpine.DEB.2.02.1405220642100.9695@ionos.tec.linutronix.de> <20140521215707.GH12819@moon> <alpine.DEB.2.02.1405220658530.9695@ionos.tec.linutronix.de>
 <20140521223511.GI12819@moon>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014, Cyrill Gorcunov wrote:
> On Thu, May 22, 2014 at 07:12:30AM +0900, Thomas Gleixner wrote:
> > 
> > There is a world outside of checkpoint/restore, really.
> 
> Yes, I simply don't know who else might use this write()
> functionality for other purpose, I mean i don't see a
> point to use it for anything else.
> 
> > So what's the semantics of that write function? We really want to have
> > that agreed on and documented in the man page.
> 
> The idea was to provide a way to setup @ticks into (nonzero) value
> which we get from show_fdinfo output. Then when we restore it
> we setup the timer and set @ticks to the value it had at dump
> moment.

That's not describing the semantics. It's describing what you use it
for.
 
> > Right now the write will just update the ticks and nothing else. So
> > what if there is a waiter already? What if there is a timer armed?
> > 
> > Can you please describe how checkpoint/restore is going to use all of
> > this. How is the timer restored and how/when is the reader which was
> > waiting in read/poll at the time of suspend reattached to it.
> 
> Thomas, I see what you mean. Need to think (I must admit I forgot about
> polling of timerfds :( I were to restore timerfds like this
> 
>  - fetch data from fdinfo
>  - use timer_create/settime to arm it
>  - write @ticks then

That's clear to me.

So again you have to answer the questions:

   Do we just allow the write unconditionally?
   Do we care about waking readers/pollers?
 
Whatever the answer is, it needs to be documented coherently in the
changelog, in the code and in the man page.

Thanks,

	tglx
