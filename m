Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbaIBTg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 15:36:29 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40933 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754759AbaIBTg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 15:36:27 -0400
Date: Tue, 2 Sep 2014 20:36:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Sricharan R <r.sricharan@ti.com>
Subject: Re: [PATCH v11 07/19] irqchip: gic: Add support for FIQ management
Message-ID: <20140902193613.GX30401@n2100.arm.linux.org.uk>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-8-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409662853-29313-8-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 02:00:41PM +0100, Daniel Thompson wrote:
> +static void gic_enable_fiq(struct irq_data *d)
> +{
> +	gic_set_group_irq(d, 0);
> +}
> +
> +static void gic_disable_fiq(struct irq_data *d)
> +{
> +	gic_set_group_irq(d, 1);
> +}

I think both the above functions should also call gic_unmask_irq() and
gic_mask_irq() directly rather than looping through enable_irq()/
disable_irq().

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
