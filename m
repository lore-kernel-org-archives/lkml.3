Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab3BGAHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:07:36 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33766 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab3BGAHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:07:34 -0500
Message-ID: <5112F043.6040700@wwwdotorg.org>
Date: Wed, 06 Feb 2013 17:07:31 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 02/14] mfd: ab8500: provide a irq_set_type() function
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com> <1360093715-6348-3-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1360093715-6348-3-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 12:48 PM, Linus Walleij wrote:
> From: Lee Jones <lee.jones@linaro.org>
> 
> In the AB8500 IRQ mask and unmask functions, we rely on testing for
> IRQ_TYPE_EDGE_RISING and IRQ_TYPE_EDGE_FALLING interrupts to
> physically mask and unmask the correct interrupt lines. In order
> for us to do that, the trigger needs to be set in the associated
> flags. However, unless a irq_set_type() function pointer is passed
> when registering the IRQ chip, the IRQ subsystem will refuse to do
> it. For that reason, we're providing one.

> diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c

> +static int ab8500_irq_set_type(struct irq_data *data, unsigned int type)
> +{
> +	return 0;
> +}

I think patch 0 implied that only rising/falling edges can be detected,
not levels? If so, should that function validate that the requested type
can be supported?
