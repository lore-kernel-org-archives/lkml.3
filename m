Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806Ab3GSOcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:32:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:50101 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3GSOcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:32:23 -0400
Date: Fri, 19 Jul 2013 16:32:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
cc: linux-kernel@vger.kernel.org, sreenivasulu velpula <svelpula@nvidia.com>
Subject: Re: [PATCH] kernel: irq: Call irq_chip->irq_mask in irq_disable
In-Reply-To: <1373380007-6019-1-git-send-email-ldewangan@nvidia.com>
Message-ID: <alpine.DEB.2.02.1307191627560.4089@ionos.tec.linutronix.de>
References: <1373380007-6019-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jul 2013, Laxman Dewangan wrote:

> From: sreenivasulu velpula <svelpula@nvidia.com>
> 
> If interrupt driver has implemented the irq_mask/irq_unmask
> callbacks for disable/enable interrupt then call these APIs
> from irq_disable/irq_enable.
> 
> Currently, on irq_disable(), it just look for the callback
> irq_disable() implemented by chip interrupt driver not the
> irq_mask().
> 
> Add check for the valid callback of irq_mask() and if it is
> there then call it from irq_disable.

No. That changes the semantics of lazy irq disable and breaks
suspend/resume because we rely on NOT masking interrupts to detect a
wakeup.

The irq_disable() merily marks the interrupt disabled and only touches
the hardware when the interrupt controller provides an explicit
irq_disable() callback.

Thanks,

	tglx
