Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3IZUAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 16:00:33 -0400
Received: from ja.ssi.bg ([178.16.129.10]:46827 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751727Ab3IZUAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 16:00:31 -0400
Date: Thu, 26 Sep 2013 23:05:06 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Alexander Frolkin <avf@eldamar.org.uk>
cc: Simon Horman <horms@verge.net.au>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        lvs-devel@vger.kernel.org, Wensong Zhang <wensong@linux-vs.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: improved SH fallback strategy
In-Reply-To: <20130926100540.GB27583@eldamar.org.uk>
Message-ID: <alpine.LFD.2.00.1309262255400.1949@ja.ssi.bg>
References: <20130923115139.GA15034@eldamar.org.uk> <524099BA.5020303@cogentembedded.com> <20130924093238.GD18494@eldamar.org.uk> <20130925003033.GG26081@verge.net.au> <20130925092638.GD19768@eldamar.org.uk> <alpine.LFD.2.00.1309260817290.1640@ja.ssi.bg>
 <20130926100540.GB27583@eldamar.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Thu, 26 Sep 2013, Alexander Frolkin wrote:

> Improve the SH fallback realserver selection strategy.
> 
> With sh and sh-fallback, if a realserver is down, this attempts to
> distribute the traffic that would have gone to that server evenly
> among the remaining servers.
> 
> Signed-off-by: Alexander Frolkin <avf@eldamar.org.uk>

	Looks correct to me, just fix the below indentations.
Also, please use version number for your patches, eg.
[PATCHv2] ipvs: ...

> diff --git a/net/netfilter/ipvs/ip_vs_sh.c b/net/netfilter/ipvs/ip_vs_sh.c
> index 3588fae..533ea53 100644
> --- a/net/netfilter/ipvs/ip_vs_sh.c
> +++ b/net/netfilter/ipvs/ip_vs_sh.c

> +	IP_VS_DBG_BUF(6, "SH: selected unavailable server "
> +		"%s:%d, reselecting",
> +		IP_VS_DBG_ADDR(svc->af, &dest->addr),
> +		ntohs(dest->port));

	Indentation:

	IP_VS_DBG_BUF(6, "SH: selected unavailable server %s:%d, reselecting",
		      IP_VS_DBG_ADDR(svc->af, &dest->addr), ntohs(dest->port));


> +		IP_VS_DBG_BUF(6, "SH: selected unavailable "
> +			"server %s:%d (offset %d), reselecting",
> +			IP_VS_DBG_ADDR(svc->af, &dest->addr),
> +			ntohs(dest->port),
> +			roffset);

	Indentation:

		IP_VS_DBG_BUF(6, "SH: selected unavailable "
			      "server %s:%d (offset %d), reselecting",
			      IP_VS_DBG_ADDR(svc->af, &dest->addr),
			      ntohs(dest->port), roffset);

Regards

--
Julian Anastasov <ja@ssi.bg>
