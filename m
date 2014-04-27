Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaD0Sem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 14:34:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:58509 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaD0Sek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 14:34:40 -0400
Date: Sun, 27 Apr 2014 20:34:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Axel Lin <axel.lin@ingics.com>
cc: Tony Prisk <linux@prisktech.co.nz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: vt8500: Switch to a simple write clear for
 Interrupt Status Register
In-Reply-To: <1398611627.24297.1.camel@phoenix>
Message-ID: <alpine.DEB.2.02.1404272031210.6261@ionos.tec.linutronix.de>
References: <1398611627.24297.1.camel@phoenix>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2014, Axel Lin wrote:

> According to the datasheet, the attribute of Interrupt Status Register is RW0S,
> which means:
> 	Software can read the register.
> 	Software can also "write 1 to clear". "write 0" has no effect.
> Thus switch the read/modify/write to a simple write clear.
> 
> A read/modify/write does not make sense for an irq status register like this,
> since otherwise a read/modify/write can race with a device raising an interrupt
> and then clear the pending bit unintentionally.

That's right, but what you are not seeing is that this is the mask
callback which is supposed to mask the interrupt at the interrupt
controller level.

I have a hard time to see (even without reading the data sheet) how
clearing a potentially pending interrupt in the status register will
mask the interrupt line.

Thanks,

	tglx
