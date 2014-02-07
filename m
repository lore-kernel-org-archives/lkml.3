Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaBGOYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:24:46 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:31384 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaBGOYo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:24:44 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18UZBWG4Q+5IDqFIMQoOVj+cPeUJU9GwXI=
X-DKIM: OpenDKIM Filter v2.0.1 titan 080CF520D38
Date: Fri, 7 Feb 2014 09:24:30 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] clk: respect the clock dependencies in of_clk_init
Message-ID: <20140207142430.GU8533@titan.lakedaemon.net>
References: <1391554766-11285-1-git-send-email-gregory.clement@free-electrons.com>
 <52F4DA40.4090804@elopez.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <52F4DA40.4090804@elopez.com.ar>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 10:06:08AM -0300, Emilio López wrote:

[snip a great explanation]

Guys, can I get some Tested-by's on this?

thx,

Jason.

> -----8<------
> 
> From ffdb49506e3ce92090c15e1f9b37f4d465097ac1 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
> Date: Thu, 6 Feb 2014 18:07:07 -0300
> Subject: [PATCH] clk: mvebu: fix name dependency during registration time
> 
> Currently, mvebu_clk_gating_setup has a silly dependency on clock
> registration order just to gather the parent clock name. This is
> completely unnecesary, as it supports using an already provided name
> via the clk_gating_soc_desc structs, and we can therefore solve this
> issue with a 69+/- line patch. But, given that the parent name is
> always "tclk" as default-hardcoded on mvebu_coreclk_setup(), we can
> just default-hardcode it here too and get away with solving this
> problem with a one-liner.
> ---
>  drivers/clk/mvebu/common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/mvebu/common.c b/drivers/clk/mvebu/common.c
> index 25ceccf..6c63b43 100644
> --- a/drivers/clk/mvebu/common.c
> +++ b/drivers/clk/mvebu/common.c
> @@ -121,7 +121,7 @@ void __init mvebu_clk_gating_setup(struct
> device_node *np,
>  	struct clk_gating_ctrl *ctrl;
>  	struct clk *clk;
>  	void __iomem *base;
> -	const char *default_parent = NULL;
> +	const char *default_parent = "tclk";
>  	int n;
> 
>  	base = of_iomap(np, 0);
> -- 
> 1.8.5.3
