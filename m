Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaEWBv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 21:51:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:54845 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaEWBvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 21:51:54 -0400
Date: Fri, 23 May 2014 10:51:50 +0900 (JST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Florian Fainelli <f.fainelli@gmail.com>
cc: linux-arm-kernel@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, jason@lakedaemon.net
Subject: Re: [PATCH v2 1/2] irqchip: add Broadcom Set Top Box Level-2 interrupt
 controller
In-Reply-To: <1400776606-22427-2-git-send-email-f.fainelli@gmail.com>
Message-ID: <alpine.DEB.2.02.1405231047050.9995@ionos.tec.linutronix.de>
References: <1400776606-22427-1-git-send-email-f.fainelli@gmail.com> <1400776606-22427-2-git-send-email-f.fainelli@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014, Florian Fainelli wrote:
> +static void brcmstb_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct brcmstb_l2_intc_data *b = irq_desc_get_handler_data(desc);
> +	struct irq_chip *chip = irq_get_chip(irq);

irq_desc_get_chip() is what you want here. irq_get_chip() is doing a
full lookop of desc, which is silly as you have desc already.

Thanks,

	tglx
