Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaGZT2M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:28:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbaGZTXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:23:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        dann frazier <dann.frazier@canonical.com>
Subject: [PATCH 3.15 105/109] gpio: dwapb: drop irq_setup_generic_chip()
Date: Sat, 26 Jul 2014 12:03:07 -0700
Message-Id: <20140726190227.011534912@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 11d3d334af07408ce3a68860c40006ddcd343da5 upstream.

The driver calls irq_alloc_domain_generic_chips() which creates a gc and
adds it to gc_list. The driver later then calls irq_setup_generic_chip()
which also initializes the gc and adds it to the gc_list() and this
corrupts the list. Enable LIST_DEBUG and you see the kernel complain.
This isn't required, irq_alloc_domain_generic_chips() did the init.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Alan Tull <delicious.quinoa@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: dann frazier <dann.frazier@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-dwapb.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -260,9 +260,6 @@ static void dwapb_configure_irqs(struct
 	ct->regs.ack = GPIO_PORTA_EOI;
 	ct->regs.mask = GPIO_INTMASK;
 
-	irq_setup_generic_chip(irq_gc, IRQ_MSK(port->bgc.gc.ngpio),
-			IRQ_GC_INIT_NESTED_LOCK, IRQ_NOREQUEST, 0);
-
 	irq_set_chained_handler(irq, dwapb_irq_handler);
 	irq_set_handler_data(irq, gpio);
 


