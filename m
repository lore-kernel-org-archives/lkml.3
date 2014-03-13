Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaCMNJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:09:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:50470 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaCMNJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:09:10 -0400
Date: Thu, 13 Mar 2014 14:09:05 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Hans de Goede <hdegoede@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Carlo Caione <carlo.caione@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] irq: Add a new IRQF_ACK_BEFORE_UNMASK irq flag
Message-ID: <20140313130905.GA23445@linutronix.de>
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
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

on DA850 / OMAP-L138. Without:
  59:        560   cp_intc  ohci_hcd:usb2
with the patch
  59:        280   cp_intc  ohci_hcd:usb2

that makes a difference of 280 interrupts. Prior the patch each
interrupt was handled twice and returned once with IRQ_HANDLED and the
second time with IRQ_NONE. With the proper EOI ack I don't see the
IRQ_NONE anymore.

Sebastian
