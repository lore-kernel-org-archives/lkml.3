Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaCLKph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:45:37 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:48496 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753034AbaCLKpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:45:36 -0400
Date: Wed, 12 Mar 2014 10:45:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Hans de Goede <hdegoede@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Carlo Caione <carlo.caione@gmail.com>
Subject: Re: [PATCH] irq: Add a new IRQF_ACK_BEFORE_UNMASK irq flag
Message-ID: <20140312104523.GE21483@n2100.arm.linux.org.uk>
References: <1394579583-29316-1-git-send-email-hdegoede@redhat.com> <alpine.DEB.2.02.1403120944270.18573@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403120944270.18573@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 11:38:24AM +0100, Thomas Gleixner wrote:
> If the interrupt chip has this behaviour then handle_level_irq as the
> flow handler is the wrong thing to start with because it always acks
> before calling the handler.

This sounds like the situation with the Dove PMC irqchip too, except
that it has the additional complication that "acking" any interrupt is
potentially distructive to other pending interrupts, so should be done
as infrequently as possible.

> +void unmask_threaded_irq(struct irq_desc *desc)
> +{
> +	struct irq_chip *chip = desc->irq_data.chip;
> +
> +	if (chip->flags & IRQCHIP_EOI_THREADED)
> +		chip->irq_eoi(&desc->irq_data);
> +
> +	if (chip->irq_unmask) {
> +		desc->irq_data.chip->irq_unmask(&desc->irq_data);

ITYM:
		chip->irq_unmask(&desc->irq_data);

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
