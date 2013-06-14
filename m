Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab3FNRUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 13:20:53 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36359 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3FNRUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 13:20:51 -0400
Message-ID: <51BB50EF.1050207@gmail.com>
Date: Fri, 14 Jun 2013 10:20:47 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Ralf Baechle <ralf@linux-mips.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 6/7] MIPS: octeon: use irq_get_trigger_type() to get IRQ
 flags
References: <1371228049-27080-1-git-send-email-javier.martinez@collabora.co.uk> <1371228049-27080-7-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1371228049-27080-7-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 09:40 AM, Javier Martinez Canillas wrote:
> Use irq_get_trigger_type() to get the IRQ trigger type flags
> instead calling irqd_get_trigger_type(irq_desc_get_irq_data(irq))
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Acked-by: David Daney <david.daney@cavium.com>

> ---
>   arch/mips/cavium-octeon/octeon-irq.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
> index a22f06a..7181def 100644
> --- a/arch/mips/cavium-octeon/octeon-irq.c
> +++ b/arch/mips/cavium-octeon/octeon-irq.c
> @@ -607,7 +607,7 @@ static void octeon_irq_ciu_gpio_ack(struct irq_data *data)
>
>   static void octeon_irq_handle_gpio(unsigned int irq, struct irq_desc *desc)
>   {
> -	if (irqd_get_trigger_type(irq_desc_get_irq_data(desc)) & IRQ_TYPE_EDGE_BOTH)
> +	if (irq_get_trigger_type(irq) & IRQ_TYPE_EDGE_BOTH)
>   		handle_edge_irq(irq, desc);
>   	else
>   		handle_level_irq(irq, desc);
>

