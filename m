Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaK2Js2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 04:48:28 -0500
Received: from www.linutronix.de ([62.245.132.108]:36707 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaK2Js0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 04:48:26 -0500
Date: Sat, 29 Nov 2014 10:48:23 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Sekhar Nori <nsekhar@ti.com>, Felipe Balbi <balbi@ti.com>,
        uwe@kleine-koenig.org
Subject: Re: [PATCH] tty: serial: serial-omap: depend on !8250_omap
Message-ID: <20141129094823.GA10840@linutronix.de>
References: <1417039306-2384-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1417039306-2384-1-git-send-email-bigeasy@linutronix.de>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior | 2014-11-26 23:01:46 [+0100]:

>Technically speaking this is not required. If both are enabled then the
>Maikefile order says that 8250 one wins, the second is never probed.
>
>If we choose to enable 8250_omap via defconfig then one might get supprised
>that his console isn't working anymore since nothing says use ttySx
>instead ttyOx.
>This patch _tries_ to bring this to the users' attention by not showing
>the serial-omap driver once the 8250 one is enabled. So the user might
>choose to use the help text which says that this driver (8250_omap)
>uses ttySx instead ttyOx.
>
>Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>---
>This is my attempt to warn the defconfig user of the defconfig change
>(which did not yet happen). Any suggestions?

This is was Uwe Kleine-König suggested off-list:

|Currently there are two drivers for the serial device. Until the new one
|matured enough to drop the old one, let them conflict each other. They
|both handle the same devices, but only one can be responsible for a
|single device. There is no technical need, but having two drivers in the
|same kernel might result in surprises.

I personally don't mind having two drivers enabled since the makefile
order is always the same. My main concern is the ttyOx -> ttySx switch
after the newer driver is enabled by default via defconfig (and the user
does not know it). "make oldconfig" is covered by "default n".
Uwe's has a point about "matured enough to drop the old one". It isn't
mentioned anywhere that the newer driver supports also DMA. Is this
something we want to add to the help text?
Could someone that will probably be dealling with possible fallout comment
on this? This patch shouldn't go in without an ACK.

Sebastian
