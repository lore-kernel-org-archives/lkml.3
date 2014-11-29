Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaK2Rgl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 12:36:41 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:49382 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751395AbaK2Rgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 12:36:40 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18x42dUTwnY59mVYRb3wWHQ
Date: Sat, 29 Nov 2014 09:34:19 -0800
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>,
        Felipe Balbi <balbi@ti.com>, uwe@kleine-koenig.org
Subject: Re: [PATCH] tty: serial: serial-omap: depend on !8250_omap
Message-ID: <20141129173418.GY2817@atomide.com>
References: <1417039306-2384-1-git-send-email-bigeasy@linutronix.de>
 <20141129094823.GA10840@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141129094823.GA10840@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [141129 01:50]:
> * Sebastian Andrzej Siewior | 2014-11-26 23:01:46 [+0100]:
> 
> >Technically speaking this is not required. If both are enabled then the
> >Maikefile order says that 8250 one wins, the second is never probed.
> >
> >If we choose to enable 8250_omap via defconfig then one might get supprised
> >that his console isn't working anymore since nothing says use ttySx
> >instead ttyOx.
> >This patch _tries_ to bring this to the users' attention by not showing
> >the serial-omap driver once the 8250 one is enabled. So the user might
> >choose to use the help text which says that this driver (8250_omap)
> >uses ttySx instead ttyOx.
> >
> >Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> >---
> >This is my attempt to warn the defconfig user of the defconfig change
> >(which did not yet happen). Any suggestions?
> 
> This is was Uwe Kleine-König suggested off-list:
> 
> |Currently there are two drivers for the serial device. Until the new one
> |matured enough to drop the old one, let them conflict each other. They
> |both handle the same devices, but only one can be responsible for a
> |single device. There is no technical need, but having two drivers in the
> |same kernel might result in surprises.
> 
> I personally don't mind having two drivers enabled since the makefile
> order is always the same. My main concern is the ttyOx -> ttySx switch
> after the newer driver is enabled by default via defconfig (and the user
> does not know it). "make oldconfig" is covered by "default n".
> Uwe's has a point about "matured enough to drop the old one". It isn't
> mentioned anywhere that the newer driver supports also DMA. Is this
> something we want to add to the help text?
> Could someone that will probably be dealling with possible fallout comment
> on this? This patch shouldn't go in without an ACK.

Well the nightmare userspace switch from ttyS to ttyO few years ago is
something we want to avoid.. I think the best solution would be to make
serial-omap.c transparently provide support for ttyO using the new 8250
code so both ttyS and ttyO devices would just work. Otherwise it will
be years of "my serial port stopped working" questions again.

Regards,

Tony
