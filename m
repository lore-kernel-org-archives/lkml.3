Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbbAXRtQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 12:49:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:40938 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbbAXRtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 12:49:14 -0500
Date: Sat, 24 Jan 2015 18:48:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrea Adami <andrea.adami@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] ARM: sa1100: use ioremapped memory to access SC
 registers
In-Reply-To: <1421316574-10022-3-git-send-email-dbaryshkov@gmail.com>
Message-ID: <alpine.DEB.2.11.1501241846540.5526@nanos>
References: <1421316574-10022-1-git-send-email-dbaryshkov@gmail.com> <1421316574-10022-3-git-send-email-dbaryshkov@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015, Dmitry Eremin-Solenikov wrote:
>  static void sa1100_mask_irq(struct irq_data *d)
>  {
> -	ICMR &= ~BIT(d->hwirq);
> +	u32 reg;
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&lock, flags);

What's the exact point of that lock? And how is it related to the
$subject of the patch?

Thanks,

	tglx
