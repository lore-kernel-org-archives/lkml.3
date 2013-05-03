Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762242Ab3ECGDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:03:41 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:5419
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756340Ab3ECGDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:03:39 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 3 May 2013 14:03:29 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <robin.randhawa@arm.com>,
        <Steve.Bannister@arm.com>, <Liviu.Dudau@arm.com>,
        <charles.garcia-tobin@arm.com>, <arvind.chauhan@arm.com>
Subject: Re: [PATCH V2] cpufreq: cpu0: Free parent node for error cases
Message-ID: <20130503060327.GA19902@S2101-09.ap.freescale.net>
References: <03c6b0e0f41238c1b4346b4186040ff69e369b4a.1367556239.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <03c6b0e0f41238c1b4346b4186040ff69e369b4a.1367556239.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 10:14:25AM +0530, Viresh Kumar wrote:
> We are freeing parent node in success cases but not in failure cases. Lets do
> it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/cpufreq/cpufreq-cpu0.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index 3ab8294..8565d41 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -189,7 +189,8 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  
>  	if (!np) {
>  		pr_err("failed to find cpu0 node\n");
> -		return -ENOENT;
> +		ret = -ENOENT;
> +		goto out_put_parent;
>  	}
>  
>  	cpu_dev = &pdev->dev;
> @@ -264,6 +265,8 @@ out_free_table:
>  	opp_free_cpufreq_table(cpu_dev, &freq_table);
>  out_put_node:
>  	of_node_put(np);
> +out_put_parent:
> +	of_node_put(parent);
>  	return ret;
>  }
>  
> -- 
> 1.7.12.rc2.18.g61b472e
> 

