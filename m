Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219AbaH1FpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 01:45:18 -0400
Received: from mail-bl2on0086.outbound.protection.outlook.com ([65.55.169.86]:5060
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757129AbaH1FpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 01:45:16 -0400
X-Greylist: delayed 819 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Aug 2014 01:45:15 EDT
Date: Thu, 28 Aug 2014 13:30:03 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Viresh Kumar" <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/3] cpufreq: cpu0: Release clk and regulator in remove
 function
Message-ID: <20140828053002.GB23836@dragon>
References: <1409209212-18730-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409209212-18730-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130536774226373432;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009012)(6009001)(448002)(189002)(199003)(51704005)(24454002)(64706001)(31966008)(83506001)(85852003)(33656002)(46406003)(44976005)(23726002)(19580405001)(4396001)(95666004)(90102001)(79102001)(26826002)(77982001)(85326001)(57986006)(21056001)(83072002)(92566001)(81156004)(86362001)(110136001)(97756001)(102836001)(99396002)(83322001)(33716001)(6806004)(81342001)(69596002)(54356999)(19580395003)(74662001)(68736004)(80022001)(50466002)(47776003)(76482001)(107046002)(106466001)(87936001)(20776003)(97736001)(50986999)(74502001)(76176999)(85306004)(84676001)(46102001)(81542001)(104016003)(92726001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB359;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 031763BCAF
Authentication-Results: spf=permerror (sender IP is 192.88.158.2)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 12:00:10AM -0700, Pramod Gurav wrote:
> This function releases clk and regulator in remove function for clean
> unloading.
> 
> CC: Shawn Guo <shawn.guo@linaro.org>
> CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> CC: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/cpufreq/cpufreq-cpu0.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index 0d2172b..e1574f8 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -229,6 +229,8 @@ static int cpu0_cpufreq_remove(struct platform_device *pdev)
>  	cpufreq_cooling_unregister(cdev);
>  	cpufreq_unregister_driver(&cpu0_cpufreq_driver);
>  	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
> +	clk_put(cpu_clk);
> +	regulator_put(cpu_reg);

cpu_reg is optional for the driver, so it's more logical to check the
availability before actually putting it?

Shawn

>  
>  	return 0;
>  }
> -- 
> 1.7.0.4
> 
