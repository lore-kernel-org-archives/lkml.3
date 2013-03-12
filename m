Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab3CLH6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 03:58:20 -0400
Received: from [213.199.154.206] ([213.199.154.206]:52167 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755132Ab3CLH6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 03:58:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 12 Mar 2013 15:57:19 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Nishanth Menon <nm@ti.com>
CC: cpufreq <cpufreq@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 2/2] cpufreq: cpufreq-cpu0: provide compatibility string
 for DT matchup
Message-ID: <20130312075716.GH18574@S2101-09.ap.freescale.net>
References: <1363043130-30270-1-git-send-email-nm@ti.com>
 <1363043130-30270-3-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1363043130-30270-3-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copied devicetree-discuss list.

On Mon, Mar 11, 2013 at 06:05:30PM -0500, Nishanth Menon wrote:
> commit 5553f9e (cpufreq: instantiate cpufreq-cpu0 as a platform_driver)
> now forces platform device to be registered for allowing cpufreq-cpu0
> to be used by SoCs. example: drivers/cpufreq/highbank-cpufreq.c
> 
> However, for SoCs that wish to link up using device tree, instead
> of platform device, provide compatibility string match:
> compatible = "cpufreq,cpu0";

This compatible is merely added for asking DT core code to populate
a platform_device for cpufreq driver.  It's not describing
hardware/cpus, and it does not belong to device tree.

Shawn

> 
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: cpufreq@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-omap@vger.kernel.org
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |    3 +++
>  drivers/cpufreq/cpufreq-cpu0.c                     |    6 ++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> index f180963..a5699f0 100644
> --- a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> +++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> @@ -10,6 +10,8 @@ under node /cpus/cpu@0.
>  Required properties:
>  - operating-points: Refer to Documentation/devicetree/bindings/power/opp.txt
>    for details
> +- compatible: if platform_device is *not* used, should be:
> +  "cpufreq,cpu0"
>  
>  Optional properties:
>  - clock-name: If the clock is not converted to device tree, then describe
> @@ -24,6 +26,7 @@ Examples:
>  cpus {
>  	#address-cells = <1>;
>  	#size-cells = <0>;
> +	compatible = "cpufreq,cpu0";
>  
>  	cpu@0 {
>  		compatible = "arm,cortex-a9";
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index 28223c9..a6f0a9b 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -277,9 +277,15 @@ static int cpu0_cpufreq_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static struct of_device_id of_cpu0_cpufreq_match[] = {
> +	{ .compatible = "cpufreq,cpu0", },
> +	{ /* end */ }
> +};
> +
>  static struct platform_driver cpu0_cpufreq_platdrv = {
>  	.driver = {
>  		.name	= "cpufreq-cpu0",
> +		.of_match_table = of_cpu0_cpufreq_match,
>  		.owner	= THIS_MODULE,
>  	},
>  	.probe		= cpu0_cpufreq_probe,
> -- 
> 1.7.9.5
> 

