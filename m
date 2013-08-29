Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3H2NH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:07:27 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:58821 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272Ab3H2NHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:07:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 29 Aug 2013 21:07:27 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/16] cpufreq: cpu0: use cpufreq_generic_get() routine
Message-ID: <20130829130725.GL18729@S2101-09.ap.freescale.net>
References: <cover.1377272740.git.viresh.kumar@linaro.org>
 <6ae0de783646c5356717d761903502f354abfe84.1377272740.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6ae0de783646c5356717d761903502f354abfe84.1377272740.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 09:20:39PM +0530, Viresh Kumar wrote:
> We have common infrastructure available with us for getting a CPUs clk rate.
> Lets use it for this driver.
> 
> Cc: Shawn Guo <shawn.guo@linaro.org>

Both this and imx6q one,

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq-cpu0.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index 7273bfc..62e52e3 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -29,11 +29,6 @@ static struct clk *cpu_clk;
>  static struct regulator *cpu_reg;
>  static struct cpufreq_frequency_table *freq_table;
>  
> -static unsigned int cpu0_get_speed(unsigned int cpu)
> -{
> -	return clk_get_rate(cpu_clk) / 1000;
> -}
> -
>  static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
>  {
>  	struct opp *opp;
> @@ -99,6 +94,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
>  
>  static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
>  {
> +	policy->clk = cpu_clk;
>  	return cpufreq_generic_init(policy, freq_table, transition_latency);
>  }
>  
> @@ -106,7 +102,7 @@ static struct cpufreq_driver cpu0_cpufreq_driver = {
>  	.flags = CPUFREQ_STICKY,
>  	.verify = cpufreq_generic_frequency_table_verify,
>  	.target_index = cpu0_set_target,
> -	.get = cpu0_get_speed,
> +	.get = cpufreq_generic_get,
>  	.init = cpu0_cpufreq_init,
>  	.exit = cpufreq_generic_exit,
>  	.name = "generic_cpu0",
> -- 
> 1.7.12.rc2.18.g61b472e
> 

