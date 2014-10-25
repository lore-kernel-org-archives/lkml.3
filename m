Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaJYTf7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:35:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:51028 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaJYTf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:35:57 -0400
Date: Sat, 25 Oct 2014 21:35:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>, Phong Vo <pvo@apm.com>,
        Linus Walleij <linus.walleij@linaro.org>, Tin Huynh <tnhuynh@apm.com>,
        Y Vo <yvo@apm.com>, Toan Le <toanle@apm.com>,
        Bjorn Andersson <bjorn@kryo.se>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] genirq: Allow the irqchip state of an IRQ to be
 save/restored
In-Reply-To: <1414232097-4328-2-git-send-email-marc.zyngier@arm.com>
Message-ID: <alpine.DEB.2.11.1410252131110.5308@nanos>
References: <1414232097-4328-1-git-send-email-marc.zyngier@arm.com> <1414232097-4328-2-git-send-email-marc.zyngier@arm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2014, Marc Zyngier wrote:
> +int irq_get_irqchip_state(unsigned int irq, int state)
> +{
> +	struct irq_desc *desc;
> +	struct irq_data *data;
> +	struct irq_chip *chip;
> +	int val;
> +
> +	desc = irq_to_desc(irq);
> +	if (!desc)
> +		return -EINVAL;
> +
> +	data = irq_desc_get_irq_data(desc);
> +
> +	chip = irq_desc_get_chip(desc);
> +	if (!chip->irq_get_irqchip_state)
> +		return -EINVAL;
> +
> +	chip_bus_lock(desc);
> +	val = chip->irq_get_irqchip_state(data, state);

Hmm. What's the irq_get_irqchip_state() callback supposed to return?

Thanks,

	tglx
