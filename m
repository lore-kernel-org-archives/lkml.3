Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3HDLiE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 07:38:04 -0400
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:55195
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab3HDLh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 07:37:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(z37d4lz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sun, 4 Aug 2013 19:38:46 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 02/15] cpufreq: cpufreq-cpu0: initialize .owner field
 with THIS_MODULE
Message-ID: <20130804113844.GE18119@S2101-09.ap.freescale.net>
References: <cover.1375279948.git.viresh.kumar@linaro.org>
 <8f37155d1524de4298f7b1de08b3474fe2d97241.1375279948.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8f37155d1524de4298f7b1de08b3474fe2d97241.1375279948.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 07:49:11PM +0530, Viresh Kumar wrote:
> CPUFreq core does following at multiple places:
> module_{get|put}(cpufreq_driver->owner)).
> 
> This is done to make sure module doesn't get unloaded if it is currently in use.
> This will work only if the .owner field of cpufreq driver is initialized with a
> valid pointer.
> 
> This field wasn't initialized for this driver, lets initialize it with
> THIS_MODULE.
> 
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

For this and imx6q-cpufreq one,

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/cpufreq/cpufreq-cpu0.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index ad1fde2..a087bf1 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -169,6 +169,7 @@ static struct cpufreq_driver cpu0_cpufreq_driver = {
>  	.init = cpu0_cpufreq_init,
>  	.exit = cpu0_cpufreq_exit,
>  	.name = "generic_cpu0",
> +	.owner = THIS_MODULE,
>  	.attr = cpu0_cpufreq_attr,
>  };
>  
> -- 
> 1.7.12.rc2.18.g61b472e
> 

