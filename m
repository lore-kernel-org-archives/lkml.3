Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab3AZOkR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 09:40:17 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:57209
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746Ab3AZOkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 09:40:15 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sat, 26 Jan 2013 22:39:53 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
CC: <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/4] cpufreq, highbank: add support for highbank cpufreq
Message-ID: <20130126143950.GA7079@S2101-09.ap.freescale.net>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1359143205-20279-1-git-send-email-mark.langsdorf@calxeda.com>
 <1359143205-20279-5-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1359143205-20279-5-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Fri, Jan 25, 2013 at 01:46:45PM -0600, Mark Langsdorf wrote:
> +static int hb_cpufreq_driver_init(void)
> +{
> +	struct device *cpu_dev;
> +	struct clk *cpu_clk;
> +	struct device_node *np;
> +	int ret;
> +
> +	for_each_child_of_node(of_find_node_by_path("/cpus"), np)
> +		if (of_get_property(np, "operating-points", NULL))
> +			break;
> +
> +	if (!np) {
> +		pr_err("failed to find highbank cpufreq node\n");
> +		return -ENOENT;
> +	}
> +
...
> +out_put_node:
> +	of_node_put(np);
> +	return ret;
> +}
> +module_init(hb_cpufreq_driver_init);

As we are moving to multiplatform build, this init function will run
on all other platforms built together with highbank.  We should
probably eliminate that effect.  cpufreq-cpu0 driver is facing the
same problem, and I just sent a patch "cpufreq: instantiate cpufreq-cpu0
as a platform_driver" to address that.

Shawn

