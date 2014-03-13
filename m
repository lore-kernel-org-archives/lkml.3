Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaCMNcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:32:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:50699 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbaCMNct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:32:49 -0400
Date: Thu, 13 Mar 2014 14:32:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: Hans de Goede <hdegoede@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Carlo Caione <carlo.caione@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH] irq: Add a new IRQF_ACK_BEFORE_UNMASK irq flag
In-Reply-To: <20140313130905.GA23445@linutronix.de>
Message-ID: <alpine.DEB.2.02.1403131420430.18573@ionos.tec.linutronix.de>
References: <1394579583-29316-1-git-send-email-hdegoede@redhat.com> <alpine.DEB.2.02.1403120944270.18573@ionos.tec.linutronix.de> <20140313130905.GA23445@linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014, Sebastian Andrzej Siewior wrote:

> * Thomas Gleixner | 2014-03-12 11:38:24 [+0100]:
> 
> >Untested patch below.
> Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> on DA850 / OMAP-L138. Without:
>   59:        560   cp_intc  ohci_hcd:usb2
> with the patch
>   59:        280   cp_intc  ohci_hcd:usb2
> 
> that makes a difference of 280 interrupts. Prior the patch each
> interrupt was handled twice and returned once with IRQ_HANDLED and the
> second time with IRQ_NONE. With the proper EOI ack I don't see the
> IRQ_NONE anymore.

Right. The documentation of L138 clearly says, that you need to ack
the interrupt AFTER the handler has run. But the driver uses
handle_edge_irq, which acks BEFORE the handler has run.

Quality stuff.

Thanks,

	tglx






