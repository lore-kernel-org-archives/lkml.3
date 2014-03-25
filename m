Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaCYTkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:40:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:54999 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbaCYTkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:40:16 -0400
Message-ID: <5331DB9C.4020208@linutronix.de>
Date: Tue, 25 Mar 2014 20:40:12 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: delicious quinoa <delicious.quinoa@gmail.com>
CC: Alan Tull <atull@altera.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH 6/7] gpio: dwapb: use a second irq chip
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>	<1395505004-22650-7-git-send-email-bigeasy@linutronix.de> <CANk1AXTUr2MevsXphxicgZEPC2tQBUh6pEXa78Fa6Jt4bPiRdQ@mail.gmail.com>
In-Reply-To: <CANk1AXTUr2MevsXphxicgZEPC2tQBUh6pEXa78Fa6Jt4bPiRdQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 07:48 PM, delicious quinoa wrote:
> I'm trying to test against recent tag next-20140312.  Got a build error.
> 
> /home/atull/repos/linux-socfpga/drivers/gpio/gpio-dwapb.c:254:11:
> error: 'struct irq_chip' has no member named 'irq_request_resources'
> /home/atull/repos/linux-socfpga/drivers/gpio/gpio-dwapb.c:254:36:
> error: 'dwapb_irq_reqres' undeclared (first use in this function)
> /home/atull/repos/linux-socfpga/drivers/gpio/gpio-dwapb.c:255:11:
> error: 'struct irq_chip' has no member named 'irq_release_resources'
> /home/atull/repos/linux-socfpga/drivers/gpio/gpio-dwapb.c:255:36:
> error: 'dwapb_irq_relres' undeclared (first use in this function)
> Build failed...

The change in the driver got first introduced in commit 57ef0428
("gpio: switch drivers to use new callback") and it builds for me. You
probably miss the change in the core code c1bacba ("genirq: Provide
irq_request/release_resources chip callbacks").

I pushed to
	git://git.breakpoint.cc/bigeasy/linux.git gpio_dw_v3

my gpio-next + my patches + linux-next which is currently at -next-
20140325 btw. With those you should not get the build anymore.

> Alan Tull
> aka
> delicious quinoa

Sebastian
