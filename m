Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935152AbaH1GPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 02:15:45 -0400
Received: from mail-bn1on0081.outbound.protection.outlook.com ([157.56.110.81]:64736
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752439AbaH1GPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 02:15:43 -0400
Date: Thu, 28 Aug 2014 14:15:23 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Viresh Kumar" <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/3] cpufreq: cpu0: Convert pr_ to dev_ as struct device
 is available
Message-ID: <20140828061521.GD23836@dragon>
References: <1409209212-18730-1-git-send-email-pramod.gurav@smartplayin.com>
 <1409209212-18730-3-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409209212-18730-3-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130536801412456593;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009012)(6009001)(448002)(52314003)(24454002)(51704005)(189002)(199003)(50466002)(47776003)(76482001)(74662001)(80022001)(68736004)(575784001)(33716001)(6806004)(69596002)(81342001)(19580395003)(54356999)(46102001)(104016003)(81542001)(76176999)(74502001)(84676001)(85306004)(92726001)(87936001)(106466001)(107046002)(50986999)(20776003)(97736001)(46406003)(44976005)(90102001)(95666004)(4396001)(23726002)(19580405001)(83506001)(85852003)(33656002)(64706001)(31966008)(81156004)(21056001)(57986006)(92566001)(83072002)(97756001)(102836001)(110136001)(99396002)(83322001)(86362001)(26826002)(79102001)(85326001)(77982001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB359;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 031763BCAF
Authentication-Results: spf=permerror (sender IP is 192.88.158.2)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 12:00:12AM -0700, Pramod Gurav wrote:
> CC: Shawn Guo <shawn.guo@linaro.org>
> CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> CC: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/cpufreq/cpufreq-cpu0.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index 0652cea..8f0b02f 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -126,7 +126,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  
>  	np = of_node_get(cpu_dev->of_node);
>  	if (!np) {
> -		pr_err("failed to find cpu0 node\n");
> +		dev_err(cpu_dev, "failed to find cpu0 node\n");

There are more pr_* calls in the driver.  Since you do not get rid of
all of them anyway, and pr_fmt(fmt) definition in the file also gives
good context of the messages, I'm not fond of the change.

Shawn

>  		return -ENOENT;
>  	}
>  
> @@ -141,14 +141,14 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  			ret = -EPROBE_DEFER;
>  			goto out_put_node;
>  		}
> -		pr_warn("failed to get cpu0 regulator: %ld\n",
> +		dev_warn(cpu_dev, "failed to get cpu0 regulator: %ld\n",
>  			PTR_ERR(cpu_reg));
>  	}
>  
>  	cpu_clk = clk_get(cpu_dev, NULL);
>  	if (IS_ERR(cpu_clk)) {
>  		ret = PTR_ERR(cpu_clk);
> -		pr_err("failed to get cpu0 clock: %d\n", ret);
> +		dev_err(cpu_dev, "failed to get cpu0 clock: %d\n", ret);
>  		goto out_put_reg;
>  	}
>  
> @@ -157,7 +157,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  
>  	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
>  	if (ret) {
> -		pr_err("failed to init cpufreq table: %d\n", ret);
> +		dev_err(cpu_dev, "failed to init cpufreq table: %d\n", ret);
>  		goto out_put_clk;
>  	}
>  
> @@ -193,7 +193,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  
>  	ret = cpufreq_register_driver(&cpu0_cpufreq_driver);
>  	if (ret) {
> -		pr_err("failed register driver: %d\n", ret);
> +		dev_err(cpu_dev, "failed register driver: %d\n", ret);
>  		goto out_free_table;
>  	}
>  
> @@ -204,7 +204,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  	if (of_find_property(np, "#cooling-cells", NULL)) {
>  		cdev = of_cpufreq_cooling_register(np, cpu_present_mask);
>  		if (IS_ERR(cdev))
> -			pr_err("running cpufreq without cooling device: %ld\n",
> +			dev_err(cpu_dev, "running cpufreq without cooling device: %ld\n",
>  			       PTR_ERR(cdev));
>  	}
>  
> -- 
> 1.7.0.4
> 
