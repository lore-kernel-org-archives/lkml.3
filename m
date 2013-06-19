Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934664Ab3FSKxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:53:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:54078 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934011Ab3FSKxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:53:04 -0400
Date: Wed, 19 Jun 2013 12:53:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/timer.c: using spin_lock_irqsave instead of
 spin_lock + local_irq_save, especially when CONFIG_LOCKDEP not defined
In-Reply-To: <51C1861A.6030901@asianux.com>
Message-ID: <alpine.DEB.2.02.1306191249260.4013@ionos.tec.linutronix.de>
References: <51C11E83.8030902@asianux.com> <alpine.DEB.2.02.1306191029530.4013@ionos.tec.linutronix.de> <51C17D01.2060208@asianux.com> <alpine.DEB.2.02.1306191151390.4013@ionos.tec.linutronix.de> <51C1861A.6030901@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jun 2013, Chen Gang wrote:

> On 06/19/2013 05:59 PM, Thomas Gleixner wrote:
> > I'm well aware how that works. And there is no difference whether you
> > do:
> > 
> > 	local_irq_save(flags);
> > 	spin_lock(&lock);
> > or
> > 	spin_lock_irqsave(&lock, flags);
> 
> if CONFIG_LOCKDEP is not defined, they are not semantically the same.

Care to explain _your_ spinlock semantics to me?

The factual ones are:

    spin_lock_irqsave() returns with the lock held, interrupts and
    preemption disabled. 

    spin_lock() returns with the lock held, preemption disabled. It
    does not affect interrupt disabled/enabled state

So
	local_irq_save(flags);
	spin_lock(&lock);

is semantically the same as 

	spin_lock_irqsave(&lock, flags);

And this is completely independent of LOCKDEP.

Thanks,

	tglx

    
