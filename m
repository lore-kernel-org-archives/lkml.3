Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaCMNhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:37:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:50736 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaCMNhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:37:08 -0400
Date: Thu, 13 Mar 2014 14:37:07 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Hans de Goede <hdegoede@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Carlo Caione <carlo.caione@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] irq: Add a new IRQF_ACK_BEFORE_UNMASK irq flag
Message-ID: <20140313133707.GA24821@linutronix.de>
References: <1394579583-29316-1-git-send-email-hdegoede@redhat.com>
 <alpine.DEB.2.02.1403120944270.18573@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403120944270.18573@ionos.tec.linutronix.de>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner | 2014-03-12 11:38:24 [+0100]:

>Untested patch below.

I assumed that I forgot that piece during backporting but infact it was
not part of the original patch.

--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -388,6 +388,7 @@ extern int no_irq_affinity;
  */
 extern void handle_level_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_fasteoi_late_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_edge_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_simple_irq(unsigned int irq, struct irq_desc *desc);


One side note: Since we need to specify IRQCHIP_EOI_THREADED and
handle_fasteoi_late_irq() as the handler, would it be easily doable to use
the handle_fasteoi_irq() handler and skip the EOI in the threaded mode?
But if it creates a mess then leave it as it is.

Sebastian
