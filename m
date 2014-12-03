Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaLCKuC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:50:02 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:63644 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaLCKt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:49:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Agner <stefan@agner.ch>
Cc: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        daniel.lezcano@linaro.org, tglx@linutronix.de, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] irqchip: nvic: support routable irq domain ops
Date: Wed, 03 Dec 2014 11:49:50 +0100
Message-ID: <4576226.8jDcZiCptE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417565531-4507-5-git-send-email-stefan@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch> <1417565531-4507-5-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:iunaBZIvkv2PMsaRhyv2rk3hLTPxZr/amqb+t8JkaQc
 vrX37MbN4JZ+oRWGg4XjRaTGaLNOR5WjqQuYGpXx1TIaXNT0Wz
 hbk6zuf2b3qfm3CsGA9yyyMFNx65XURCH0hmGabQDGbaUjAFmb
 ekeCOX+ehqgEuXFgLteK+bFeCIZ7HymYQs7QKqdXUFaEG50cF5
 yb7lfMb1M4Cuat2JpmUjgvJrEdV+mrgwWGGRw80UkuYmCbeoD9
 Nr1PZ+PjgmH9BNSnoa3K9uHUAEsrHiPnlZ+IUEbGmOo5wGDVec
 GhU4ZTlvNqaIWkWR7oEQnEMW7uHRQRdwGVsQVFsKyeWMjAzCke
 9IZ7tayh0Fd5TvSlE5HQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 01:12:03 Stefan Agner wrote:
> +#ifdef CONFIG_ARM_NVIC
> +extern const struct irq_domain_ops *nvic_routable_irq_domain_ops;
> +static inline void __init register_routable_domain_ops
> +                                       (const struct irq_domain_ops *ops)
> +{
> +               nvic_routable_irq_domain_ops = ops;
> +}
> +#endif /* CONFIG_ARM_NVIC */
> 

As you mentioned, this conflicts with the gic specific declaration.
Why not remove the #ifdef here and rename the function to
nvic_register_routable_domain_ops() ?

If that doesn't work, I guess we need something more generic
and move the routable_irq_domain_ops to some common location.

	Arnd
