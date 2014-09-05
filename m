Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaIEVNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:13:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:34543 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaIEVNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:13:45 -0400
Date: Fri, 5 Sep 2014 23:13:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nishanth Menon <nm@ti.com>
cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        Mark Brown <broonie@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 3/3] mfd: palmas: Add support for optional wakeup
In-Reply-To: <1409950311-25236-4-git-send-email-nm@ti.com>
Message-ID: <alpine.DEB.2.10.1409052311210.5472@nanos>
References: <1409950311-25236-1-git-send-email-nm@ti.com> <1409950311-25236-4-git-send-email-nm@ti.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2014, Nishanth Menon wrote:
> +	if (!palmas->wakeirq)
> +		goto no_wake_irq;
> +
> +	ret = devm_request_irq(palmas->dev, palmas->wakeirq,
> +			       palmas_wake_irq,
> +			       IRQF_ONESHOT | pdata->irq_flags,

Why is this marked IRQF_ONESHOT?

> +			       dev_name(palmas->dev),
> +			       &palmas);
> +	if (ret < 0)
> +		goto err_i2c;

Why err and not doing the obvious clearing of palmas->wakeirq and
keep at least the i2c functional?

Thanks,

	tglx
