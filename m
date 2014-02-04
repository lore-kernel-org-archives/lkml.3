Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbaBDUKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:10:46 -0500
Received: from www.linutronix.de ([62.245.132.108]:49077 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbaBDUKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:10:40 -0500
Date: Tue, 4 Feb 2014 21:10:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Josh Cartwright <joshc@codeaurora.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH v5 4/6] spmi: pmic_arb: add support for interrupt
 handling
In-Reply-To: <1391468739-20987-5-git-send-email-joshc@codeaurora.org>
Message-ID: <alpine.DEB.2.02.1402042107311.24986@ionos.tec.linutronix.de>
References: <1391468739-20987-1-git-send-email-joshc@codeaurora.org> <1391468739-20987-5-git-send-email-joshc@codeaurora.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014, Josh Cartwright wrote:
> +static void qpnpint_irq_ack(struct irq_data *d)
> +{
> +	struct spmi_pmic_arb_dev *pa = irq_data_get_irq_chip_data(d);
> +	u8 irq  = d->hwirq >> 8;
> +	u8 apid = d->hwirq;
> +	unsigned long flags;
> +	u8 data;
> +
> +	spin_lock_irqsave(&pa->lock, flags);

This wants to be a raw_spinlock - think about RT!

Looks sane otherwise.

Thanks,

	tglx
