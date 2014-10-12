Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaJLM43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 08:56:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:52585 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaJLM41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 08:56:27 -0400
MIME-Version: 1.0
In-Reply-To: <1412001499-19369-3-git-send-email-grygorii.strashko@ti.com>
References: <1412001499-19369-1-git-send-email-grygorii.strashko@ti.com>
	<1412001499-19369-3-git-send-email-grygorii.strashko@ti.com>
Date: Sun, 12 Oct 2014 05:56:23 -0700
Message-ID: <CAMAWPa-sKGu_o0CDLCk_uKofxwOjXiiFBedjEP=OhQFmo+ehCA@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] ARM: keystone: pm: switch to use generic pm domains
From: Kevin Hilman <khilman@kernel.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kevin Hilman <khilman@linaro.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, grant.likely@secretlab.ca,
        ulf.hansson@linaro.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii,

On 9/29/14 7:38 AM, Grygorii Strashko wrote:
> This patch switches Keystone 2 PM code to use Generic PM domains
> instead of PM clock domains because of the lack of DT support
> for the last.
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

IMO, this approach is much better.

One minor nit below...

> diff --git a/arch/arm/mach-keystone/pm_domain.c b/arch/arm/mach-keystone/pm_domain.c
> index ca79dda..3eb5257 100644
> --- a/arch/arm/mach-keystone/pm_domain.c
> +++ b/arch/arm/mach-keystone/pm_domain.c
> @@ -12,69 +12,110 @@
>   * version 2, as published by the Free Software Foundation.
>   */
>
> +#include <linux/clk.h>
>  #include <linux/init.h>
> -#include <linux/pm_runtime.h>
>  #include <linux/pm_clock.h>
> +#include <linux/pm_domain.h>
>  #include <linux/platform_device.h>
> -#include <linux/clk-provider.h>
>  #include <linux/of.h>
>
> -#ifdef CONFIG_PM_RUNTIME
> -static int keystone_pm_runtime_suspend(struct device *dev)
> +#ifdef CONFIG_PM_GENERIC_DOMAINS
> +
> +struct keystone_domain {
> + struct generic_pm_domain base;
> + struct device *dev;
> +};

I think the name 'base' for this field leads to confusion later in the
code, since base usually means something else in drivers.  How about
'genpd'?

Kevin
