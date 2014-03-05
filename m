Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbaCEL3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:29:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40592 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbaCEL2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:28:30 -0500
Date: Wed, 5 Mar 2014 12:28:28 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: turn rate change failed warning into pr_debug
Message-ID: <20140305112828.GN24917@pengutronix.de>
References: <1389885175-14174-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389885175-14174-1-git-send-email-s.hauer@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:27:24 up 192 days, 20:58, 55 users,  load average: 0.13, 0.69,
 0.96
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

Any objections to this patch?

Sascha

On Thu, Jan 16, 2014 at 04:12:55PM +0100, Sascha Hauer wrote:
> If a rate change failed it's the opportunity of the caller to handle
> this. Do not spam the log with a message.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/clk/clk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 2cf2ea6..f0124d4 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1460,7 +1460,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
>  	/* notify that we are about to change rates */
>  	fail_clk = clk_propagate_rate_change(top, PRE_RATE_CHANGE);
>  	if (fail_clk) {
> -		pr_warn("%s: failed to set %s rate\n", __func__,
> +		pr_debug("%s: failed to set %s rate\n", __func__,
>  				fail_clk->name);
>  		clk_propagate_rate_change(top, ABORT_RATE_CHANGE);
>  		ret = -EBUSY;
> -- 
> 1.8.5.2
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
