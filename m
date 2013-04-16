Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3DPIkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 04:40:37 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:25334
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669Ab3DPIkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 04:40:32 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h1151h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 16 Apr 2013 16:40:15 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <robin.randhawa@arm.com>,
        <Steve.Bannister@arm.com>, <Liviu.Dudau@arm.com>,
        <charles.garcia-tobin@arm.com>, <arvind.chauhan@arm.com>,
        <linaro-kernel@lists.linaro.org>, <patches@linaro.org>
Subject: Re: [PATCH] cpufreq: cpu0: Put cpu parent node after using it
Message-ID: <20130416084013.GB11245@S2101-09.ap.freescale.net>
References: <377acb684be024176e1c64f7ca5b1937c3a23878.1366009701.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <377acb684be024176e1c64f7ca5b1937c3a23878.1366009701.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 12:39:37PM +0530, Viresh Kumar wrote:
> Parent node must be put after using it to balance its usage count. This was
> missing in cpufreq-cpu0 driver. Fix it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/cpufreq/cpufreq-cpu0.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index 31282fc..3ab8294 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -257,6 +257,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  	}
>  
>  	of_node_put(np);
> +	of_node_put(parent);
>  	return 0;
>  
>  out_free_table:
> -- 
> 1.7.12.rc2.18.g61b472e
> 

