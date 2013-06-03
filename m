Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab3FCMYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:24:30 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:42850 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662Ab3FCMY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:24:28 -0400
Message-ID: <51AC8A85.5020605@mellanox.com>
Date: Mon, 3 Jun 2013 15:22:29 +0300
From: Amir Vadai <amirv@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v8 net-next 2/7] net: add low latency socket poll
References: <20130603080107.18273.34279.stgit@ladj378.jer.intel.com> <20130603080128.18273.2408.stgit@ladj378.jer.intel.com>
In-Reply-To: <20130603080128.18273.2408.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.222.66.109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 11:01, Eliezer Tamir wrote:
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index 741db5fc..ae98c95 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -19,6 +19,7 @@
>  #include <net/ip.h>
>  #include <net/sock.h>
>  #include <net/net_ratelimit.h>
> +#include <net/ll_poll.h>
>  
>  static int one = 1;
>  
> @@ -284,6 +285,15 @@ static struct ctl_table net_core_table[] = {
>  		.proc_handler	= flow_limit_table_len_sysctl
>  	},
>  #endif /* CONFIG_NET_FLOW_LIMIT */
> +#ifdef CONFIG_NET_LL_RX_POLL
> +	{
> +		.procname	= "low_latency_poll",
> +		.data		= &sysctl_net_ll_poll,
> +		.maxlen		= sizeof(unsigned long),
One more thing I just noticed: should be 'sizeof(int)'.
Because proc_dointvec is expecting an int, sizeof(unsigned long) will
produce an array of two ints.


> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec
> +	},
> +#endif
>  #endif /* CONFIG_NET */
>  	{
>  		.procname	= "netdev_budget",

