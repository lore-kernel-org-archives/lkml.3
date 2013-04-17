Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966599Ab3DQUXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 16:23:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60685 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936029Ab3DQUXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 16:23:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH v3] irqchip: Add support for ARMv7-M's NVIC
Date: Wed, 17 Apr 2013 22:23:43 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <1366214540-31166-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1366214540-31166-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201304172223.43707.arnd@arndb.de>
X-Provags-ID: V02:K0:oUSQtIM+3d4eaLtHf4B25dvDvHIX37AFGuc3FnBiJJN
 /nSGrOvIhTnhO6HYRFaV1wrSd7H2kPT+3aiPeiuRsmgLPGId0e
 p2sRHB0HXvXZ8fphFEZlRh65UZFp8kTcCLE4lgqDclaBtLlhBd
 Tr04KbZH4W55FidCOtActpbioqi30mOyxMQBhfCEwclNDuzde8
 5tuzLz4RNgwDjMQ2edT6RQK4rnoUWBtlxM6ekQo2b0Q1SPNsAo
 mUupkZeuCpplmCj8ToK1O0nQl03qrua0GnrSYweqAl0iglfG1U
 EEX1dTxOMC4L80FPJspsn6dS5VoJCjGM4gxYDQZboI0Dl/ArAT
 9Aj4FOeiYTT/D0EzZTXw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 April 2013, Uwe Kleine-König wrote:

> This patch triggers two checkpatch warnings:
> 
> 	WARNING: Avoid CamelCase: <nvic_do_IRQ>
> 	WARNING: Avoid CamelCase: <handle_IRQ>
> 
> but I think they are OK for consistency?!

You obviously have no choice for handle_IRQ, but I think the common way to
name the first-level interrupt handler would be "nvic_handle_irq" here.

> Moreover sparse tells me:
> 
> 	drivers/irqchip/irq-nvic.c:58:1: warning: symbol 'nvic_do_IRQ' was not declared. Should it be static?
> 
> nvic_do_IRQ is called from assembler only, so a declaration couldn't be
> shared and I couldn't find a nice place for a declaration. Suggestions
> welcome.

Can't you make it static and call set_handle_irq() on it from the
probe function?

> + * Each bank handles 32 irqs. Only the 16th (= last) bank handles only
> + * 16 irqs.
> + */
> +#define NVIC_MAX_IRQ		((NVIC_MAX_BANKS - 1) * 32 + 16)

Is this actually inherent to the hardware design, or is the number of irqs
actually customizable? Also, why do you care about the maximum? You only
use it to check against the device tree provided value, but I suppose
you could just as well trust that property to be correct.


	Arnd
