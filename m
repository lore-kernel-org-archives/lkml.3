Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab3GDOcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 10:32:12 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:51910 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab3GDOcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 10:32:10 -0400
Message-ID: <1372948320.4838.6.camel@phoenix>
Subject: irqchip: sirfsoc: Question about SIRFSOC_NUM_IRQS setting
From: Axel Lin <axel.lin@ingics.com>
To: Barry Song <Baohua.Song@csr.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 04 Jul 2013 22:32:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_setup_generic_chip() setup max. 32 interrupts starting from gc->irq_base.

sirfsoc_irq_init()
  -> sirfsoc_alloc_gc()
    -> irq_setup_generic_chip()

In sirfsoc_irq_init(), current code calls
sirfsoc_alloc_gc(base + 4, 32, SIRFSOC_NUM_IRQS - 32); //Note, SIRFSOC_NUM_IRQS is 128

So I'm wondering if SIRFSOC_NUM_IRQS setting is correct or not.

PS. In initial commit 02c981c07bc95ac1e "ARM: CSR: Adding CSR SiRFprimaII board support"
SIRFSOC_INTENAL_IRQ_END is 59.

Regards,
Axel




