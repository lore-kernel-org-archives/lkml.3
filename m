Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab3BGANt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:13:49 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37078 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945Ab3BGANr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:13:47 -0500
Message-ID: <5112F1B9.6010700@wwwdotorg.org>
Date: Wed, 06 Feb 2013 17:13:45 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 09/14] pinctrl/abx500: use direct IRQ defines
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com> <1360093715-6348-10-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1360093715-6348-10-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 12:48 PM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Make it harder to do mistakes by introducing the actual
> defined ABx500 IRQ number into the IRQ cluster definitions.
> Deduct cluster offset from the GPIO offset to make each
> cluster coherent.

Shouldn't this patch be squashed into the previous patch to avoid churn?

>  static struct abx500_pinctrl_soc_data ab9540_soc = {

> @@ -273,8 +273,7 @@ static int abx500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)

> -			hwirq = gpio + cluster->to_irq;
> -
> +			hwirq = gpio - cluster->start + cluster->to_irq;
>  			return irq_create_mapping(pct->parent->domain, hwirq);

In particular, this change implies that the previous patch was simply
incorrect, although I haven't really thought about it in detail.
