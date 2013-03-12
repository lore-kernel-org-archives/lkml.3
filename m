Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab3CLQC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:02:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33383 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab3CLQC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:02:28 -0400
Date: Tue, 12 Mar 2013 16:01:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irqchip: Add support for ARMv7-M's NVIC
Message-ID: <20130312160101.GW4977@n2100.arm.linux.org.uk>
References: <1363103673-24720-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1363103673-24720-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 04:54:33PM +0100, Uwe Kleine-König wrote:
> +#include <asm/irq.h>
> +#include <asm/io.h>

linux/io.h

> +	unsigned int irqs, i, irq_base;
> +
> +	irq_base = irq_alloc_descs(-1, 16, irqs - 16, numa_node_id());
> +	if (IS_ERR_VALUE(irq_base)) {

Erm... irq_alloc_descs() returns a negative number on error.

	if ((int)irq_base < 0)

or make irq_base an int, and use:

	if (irq_base < 0)
