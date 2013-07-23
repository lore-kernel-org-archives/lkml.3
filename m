Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab3GWJ05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:26:57 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:37534 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217Ab3GWJ0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:26:54 -0400
Date: Tue, 23 Jul 2013 11:25:16 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v3 12/16] cpufreq: kirkwood-cpufreq: remove device tree
 parsing for cpu nodes
Message-ID: <20130723092516.GC6846@lunn.ch>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1374492747-13879-13-git-send-email-Sudeep.KarkadaNagesha@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374492747-13879-13-git-send-email-Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 12:32:23PM +0100, Sudeep KarkadaNagesha wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> Now that the cpu device registration initialises the of_node(if available)
> appropriately for all the cpus, parsing here is redundant.
> 
> This patch removes all DT parsing and uses cpu->of_node instead.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> ---
>  drivers/cpufreq/kirkwood-cpufreq.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
> index c233ea6..25ac2cb 100644
> --- a/drivers/cpufreq/kirkwood-cpufreq.c
> +++ b/drivers/cpufreq/kirkwood-cpufreq.c
> @@ -14,7 +14,7 @@
>  #include <linux/clk.h>
>  #include <linux/clk-provider.h>
>  #include <linux/cpufreq.h>
> -#include <linux/of.h>
> +#include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <asm/proc-fns.h>
> @@ -175,9 +175,11 @@ static int kirkwood_cpufreq_probe(struct platform_device *pdev)
>  	if (IS_ERR(priv.base))
>  		return PTR_ERR(priv.base);
>  
> -	np = of_find_node_by_path("/cpus/cpu@0");
> -	if (!np)
> +	np = of_cpu_device_node_get(0);
> +	if (!np) {
> +		dev_err(&pdev->dev, "failed to get cpu device node\n");
>  		return -ENODEV;
> +	}
>  
>  	priv.cpu_clk = of_clk_get_by_name(np, "cpu_clk");
>  	if (IS_ERR(priv.cpu_clk)) {
> -- 
> 1.8.1.2

Hi Sudeep

I've not had chance to test it, but it looks O.K.

Acked-by: Andrew Lunn <andrew@lunn.ch>

	  Andrew

