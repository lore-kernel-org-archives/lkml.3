Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab3ITQX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:23:58 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:53541 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752147Ab3ITQX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:23:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ET08SngZ2+ZZGbtabq0eP
Date: Fri, 20 Sep 2013 09:23:43 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] omap2: Change clk dev id for rng to
 omap3-rom-rng
Message-ID: <20130920162342.GS9994@atomide.com>
References: <1379534757-20870-1-git-send-email-pali.rohar@gmail.com>
 <1379683507-30793-1-git-send-email-pali.rohar@gmail.com>
 <1379683507-30793-2-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379683507-30793-2-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130920 06:33]:
> Name omap_rng is already used by omap_rng driver which is for omap2 and omap4.
> For omap3 HS devices there is new driver omap3-rom-rng which needs that clk.
> And because there cannot be two drivers with same name, rename omap3 clk dev id.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  arch/arm/mach-omap2/cclock3xxx_data.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
> index 334b767..5059338 100644
> --- a/arch/arm/mach-omap2/cclock3xxx_data.c
> +++ b/arch/arm/mach-omap2/cclock3xxx_data.c
> @@ -3274,7 +3274,7 @@ static struct omap_clk omap36xx_clks[] = {
>   */
>  static struct omap_clk omap34xx_omap36xx_clks[] = {
>  	CLK(NULL,	"aes1_ick",	&aes1_ick),
> -	CLK("omap_rng",	"ick",		&rng_ick),
> +	CLK("omap3-rom-rng",	"ick",		&rng_ick),
>  	CLK(NULL,	"sha11_ick",	&sha11_ick),
>  	CLK(NULL,	"des1_ick",	&des1_ick),
>  	CLK(NULL,	"cam_mclk",	&cam_mclk),

Hmm are you sure the omap_rng is not available on
any of the omap3 GP versions? If so, the omap_rng
alias should be kept as well.

Regards,

Tony
