Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbbAEQ3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:29:06 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:13001 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbbAEQ3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:29:03 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+AppG1SmcnojWmHVnJzPgY
Date: Mon, 5 Jan 2015 08:25:09 -0800
From: Tony Lindgren <tony@atomide.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, drake@endlessm.com, loeliger@gmail.com,
        Mark Rutland <mark.rutland@arm.com>, nm@ti.com, khilman@linaro.org
Subject: Re: [PATCH v11 5/9] ARM: l2c: Get outer cache .write_sec callback
 from mach_desc only if not NULL
Message-ID: <20150105162508.GE4081@atomide.com>
References: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
 <1420460348-20302-6-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420460348-20302-6-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Szyprowski <m.szyprowski@samsung.com> [150105 04:22]:
> From: Tomasz Figa <t.figa@samsung.com>
> 
> Certain platforms (i.e. Exynos) might need to set .write_sec callback
> from firmware initialization which is happenning in .init_early callback
> of machine descriptor. However current code will overwrite the pointer
> with whatever is present in machine descriptor, even though it can be
> already set earlier. This patch fixes this by making the assignment
> conditional, depending on whether current .write_sec callback is NULL.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/kernel/irq.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
> index ad857bada96c..350f188c92d2 100644
> --- a/arch/arm/kernel/irq.c
> +++ b/arch/arm/kernel/irq.c
> @@ -109,7 +109,8 @@ void __init init_IRQ(void)
>  
>  	if (IS_ENABLED(CONFIG_OF) && IS_ENABLED(CONFIG_CACHE_L2X0) &&
>  	    (machine_desc->l2c_aux_mask || machine_desc->l2c_aux_val)) {
> -		outer_cache.write_sec = machine_desc->l2c_write_sec;
> +		if (!outer_cache.write_sec)
> +			outer_cache.write_sec = machine_desc->l2c_write_sec;
>  		ret = l2x0_of_init(machine_desc->l2c_aux_val,
>  				   machine_desc->l2c_aux_mask);
>  		if (ret)
> -- 
> 1.9.2
> 
