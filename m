Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3ILOl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:41:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54421 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3ILOlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:41:55 -0400
Date: Thu, 12 Sep 2013 15:40:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Fan Rong <cinifr@gmail.com>
Cc: coosty@163.com, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.co, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/4] Add smp support for Allwinner A20(sunxi 7i).
Message-ID: <20130912144008.GM12758@n2100.arm.linux.org.uk>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com> <1378968687-8200-2-git-send-email-cinifr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378968687-8200-2-git-send-email-cinifr@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some other comments:

On Thu, Sep 12, 2013 at 02:51:24PM +0800, Fan Rong wrote:
> +    /* L1RSTDISABLE hold low */
> +	pwr_reg = readl(cc_base + AW_CPUCFG_GENCTL);
> +	pwr_reg &= ~(1<<cpu);

If you pass your patch through checkpatch.pl, it will warn about some of
this.  You should have one space each side of <<.

> +    /* step3: clear power-off gating */
> +	pwr_reg = readl(cc_base + AW_CPU1_PWROFF_REG);
> +	pwr_reg &= ~(1);

You don't need the parens here.

> +	pwr_reg = readl(cc_base + AW_CPUCFG_DBGCTL1);
> +	pwr_reg |= (1<<cpu);

Nor here.

> +static int sunxi7i_boot_secondary(unsigned int cpu, struct task_struct *idle)
> +{
> +	pr_debug("[%s] enter cpu %d\n", __func__, cpu);
> +	spin_lock(&boot_lock);
> +	enable_aw_cpu(cpu);
> +	spin_unlock(&boot_lock);

What exactly does this spinlock protect?  The core code already provides
the guarantee that only one CPU will be brought online or taken offline
at a time.
