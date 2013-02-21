Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3BUTvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:51:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:51956 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3BUTvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:51:14 -0500
Date: Thu, 21 Feb 2013 20:51:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: paulmck@linux.vnet.ibm.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linuxfoundation.org,
        peterz@infradead.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/urgent] irq: Ensure irq_exit() code runs with interrupts
 disabled
In-Reply-To: <CAFTL4hzCWpCdx0=8M5+VjNZvfCKb=9sGX=_9dU=20rW6nag6Dw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1302212050480.22263@ionos>
References: <alpine.LFD.2.02.1302202155320.22263@ionos> <tip-630e7580f681475d92d87e78373e4136096e12f2@git.kernel.org> <CAFTL4hzCWpCdx0=8M5+VjNZvfCKb=9sGX=_9dU=20rW6nag6Dw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2013, Frederic Weisbecker wrote:
> >  void irq_exit(void)
> >  {
> > +#ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
> > +       unsigned long flags;
> > +
> > +       local_irq_save(flags);
> > +#else
> > +       WARN_ON_ONCE(!irqs_disabled();
> 
> Missing closing parenthesis.

Dammit.
 
