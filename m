Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbaEHCyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 22:54:07 -0400
Received: from mail-by2on0068.outbound.protection.outlook.com ([207.46.100.68]:5326
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751542AbaEHCyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 22:54:03 -0400
X-Greylist: delayed 1078 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 May 2014 22:54:03 EDT
Date: Thu, 8 May 2014 10:21:38 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Maxime COQUELIN <maxime.coquelin@st.com>
CC: Mike Turquette <mturquette@linaro.org>, Fabio Estevam <festevam@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: divider: Fix table round up function
Message-ID: <20140508022135.GC2794@dragon>
References: <1399481332-9550-1-git-send-email-maxime.coquelin@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1399481332-9550-1-git-send-email-maxime.coquelin@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(24454002)(51704005)(189002)(199002)(33716001)(19580405001)(33656001)(44976005)(64706001)(80022001)(76482001)(97756001)(83322001)(57986002)(83506001)(84676001)(20776003)(47776003)(69596002)(68736004)(23726002)(97736001)(6806004)(46102001)(77982001)(83072002)(85852003)(50466002)(81342001)(19580395003)(81542001)(92726001)(86362001)(87936001)(99396002)(54356999)(76176999)(77096999)(74502001)(46406003)(2009001)(74662001)(4396001)(21056001)(50986999);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB019;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0205EDCD76
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 06:48:52PM +0200, Maxime COQUELIN wrote:
> Commit 1d9fe6b97 ("clk: divider: Fix best div calculation for power-of-two and
> table dividers") introduces a regression in its _table_round_up function.
> 
> When the divider passed to this function is greater than the max divider
> available in the table, this function returns table's max divider.
> Problem is that it causes an infinite loop in clk_divider_bestdiv() because
> _next_div() will never return a value greater than maxdiv.
> 
> Instead of returning table's max divider, this patch returns INT_MAX.
> 
> Reported-by: Fabio Estevam <festevam@gmail.com>
> Reported-by: Shawn Guo <shawn.guo@freescale.com>
> Tested-by: Fabio Estevam <festevam@gmail.com>
> Cc: Mike Turquette <mike.turquette@linaro.org>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>

Tested-by: Shawn Guo <shawn.guo@freescale.com>

Thanks for the fix.

Shawn

> ---
>  drivers/clk/clk-divider.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index b3c8396..cf9114a 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -158,7 +158,7 @@ static bool _is_valid_div(struct clk_divider *divider, unsigned int div)
>  static int _round_up_table(const struct clk_div_table *table, int div)
>  {
>  	const struct clk_div_table *clkt;
> -	int up = _get_table_maxdiv(table);
> +	int up = INT_MAX;
>  
>  	for (clkt = table; clkt->div; clkt++) {
>  		if (clkt->div == div)
> -- 
> 1.9.1
> 
