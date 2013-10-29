Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab3J2B2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 21:28:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63122 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756758Ab3J2B23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 21:28:29 -0400
Date: Mon, 28 Oct 2013 18:28:00 -0700
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH 5/6] edac: Add support for Krait CPU cache error detection
Message-ID: <20131029012759.GH4763@kartoffel>
References: <1383006690-6754-1-git-send-email-sboyd@codeaurora.org>
 <1383006690-6754-6-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1383006690-6754-6-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 12:31:29AM +0000, Stephen Boyd wrote:
> Add support for the Krait CPU cache error detection. This is a
> simplified version of the code originally written by Stepan
> Moskovchenko[1] ported to the EDAC device framework.
> 
> [1] https://www.codeaurora.org/cgit/quic/la/kernel/msm/tree/arch/arm/mach-msm/cache_erp.c?h=msm-3.4
> 
> Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/edac/Kconfig      |   8 ++
>  drivers/edac/Makefile     |   2 +
>  drivers/edac/krait_edac.c | 336 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 346 insertions(+)
>  create mode 100644 drivers/edac/krait_edac.c

[...]

> +static int krait_edac_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct edac_device_ctl_info *edev;
> +       struct krait_edac *p;
> +       int l1_irq, l2_irq;
> +       int ret;
> +       int cpu;
> +
> +       l1_irq = platform_get_irq(pdev, 0);
> +       if (l1_irq < 0)
> +               return l1_irq;
> +
> +       l2_irq = platform_get_irq(pdev, 1);
> +       if (l2_irq < 0)
> +               return l2_irq;

As you have optional interrupt-names, I would prefer that you attempted to
request interrupts by name if interrupt-names is present. Otherwise
interrupt-names brings no value.

Thanks,
Mark.
