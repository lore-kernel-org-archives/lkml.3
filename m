Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaCYUnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:43:53 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:41167 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbaCYUnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:43:50 -0400
MIME-Version: 1.0
In-Reply-To: <532D83F1.5070001@linutronix.de>
References: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>
	<1395345324-18299-3-git-send-email-bigeasy@linutronix.de>
	<CANk1AXTjuBWa_DdKaV2dCPjhbKRHE9bR2uHyuoCYtt_-zk7EoQ@mail.gmail.com>
	<532D83F1.5070001@linutronix.de>
Date: Tue, 25 Mar 2014 21:43:49 +0100
Message-ID: <CACRpkdYxeieES5Y5tbCRfSe=Cnj2QsoU5KvSPZ99XsJ9AUrEmw@mail.gmail.com>
Subject: Re: [PATCH 2/3] gpio: dwapb: do not create the irq mapping upfront.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: delicious quinoa <delicious.quinoa@gmail.com>,
        Alan Tull <atull@altera.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 1:37 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:

> Linus, I don't understand why you need the mapping upfront.

This is because irqchips and gpiochips need to be orthogonal
APIs.

> I looked at
> those two links and you quote gpio_to_irq() which is not required.

In a *lot* of drivers it is implicitly required that gpio_to_irq()
is called first because they only call irq_create_mapping()
there. (And not in subsequent interrupt handlers etc.)

No matter what, I would worry less about that and spend
some time on using my new gpiolib helpers for
gpiochip_irqchip_add() and
gpiochip_set_chained_irqchip().

Yours,
Linus Walleij
