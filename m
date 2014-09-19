Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbaISK6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:58:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:58703 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaISK6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:58:49 -0400
Message-ID: <541C0C64.5010206@linutronix.de>
Date: Fri, 19 Sep 2014 12:58:44 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de> <1410377411-26656-10-git-send-email-bigeasy@linutronix.de> <20140911111721.GB17476@xps8300> <54118AAB.2010205@linutronix.de> <5419B825.5000201@linutronix.de> <20140919102212.GA31784@xps8300>
In-Reply-To: <20140919102212.GA31784@xps8300>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 12:22 PM, Heikki Krogerus wrote:
> Couldn't you just replace the handle_irq with a custom irq routine in
> the omap driver like you did with set_termios? Where you would do
> those tricks and/or call serial8250_handle_irq()?

Tricks within serial8250_handle_irq(), see [0]. It is not a lot but
still. I could provide my own handle irq, just asking what you would
prefer.

[0]
http://git.breakpoint.cc/cgit/bigeasy/linux.git/commit/?h=uart_v10_pre2&id=f26f161d998ee4a84a0aa6ddff69a435c25f204d

> The 8250_core changes in that patch #10 only modify
> serial8250_handle_irg right?

Correct. However there is another change due to the RX_DMA_BUG. A while
ago you said that this RX_DMA_BUG thing might be something that other
SoC could use, too.
If you ask me now for my own irq routine it would make sense to move RX
bug handling into omap specific code as well.

> Cheers,

Sebastian
