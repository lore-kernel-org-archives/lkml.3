Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaEUWfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:35:17 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:55295 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaEUWfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:35:15 -0400
Date: Thu, 22 May 2014 02:35:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, shawn@churchofgit.com,
        akpm@linux-foundation.org, avagin@openvz.org, xemul@parallels.com,
        vdavydov@parallels.com
Subject: Re: [patch 3/3] timerfd: Implement write method
Message-ID: <20140521223511.GI12819@moon>
References: <20140428212517.200264067@openvz.org>
 <20140428213301.507657833@openvz.org>
 <alpine.DEB.2.02.1405220642100.9695@ionos.tec.linutronix.de>
 <20140521215707.GH12819@moon>
 <alpine.DEB.2.02.1405220658530.9695@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405220658530.9695@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 07:12:30AM +0900, Thomas Gleixner wrote:
> 
> There is a world outside of checkpoint/restore, really.

Yes, I simply don't know who else might use this write()
functionality for other purpose, I mean i don't see a
point to use it for anything else.

> So what's the semantics of that write function? We really want to have
> that agreed on and documented in the man page.

The idea was to provide a way to setup @ticks into (nonzero) value
which we get from show_fdinfo output. Then when we restore it
we setup the timer and set @ticks to the value it had at dump
moment.

> Right now the write will just update the ticks and nothing else. So
> what if there is a waiter already? What if there is a timer armed?
> 
> Can you please describe how checkpoint/restore is going to use all of
> this. How is the timer restored and how/when is the reader which was
> waiting in read/poll at the time of suspend reattached to it.

Thomas, I see what you mean. Need to think (I must admit I forgot about
polling of timerfds :( I were to restore timerfds like this

 - fetch data from fdinfo
 - use timer_create/settime to arm it
 - write @ticks then

but i didn't try restore polling waiters, my bad. Letme rework this
trying addressing your comments.
