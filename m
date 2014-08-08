Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbaHHKpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:45:31 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:7704
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755216AbaHHKpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:45:22 -0400
Date: Fri, 8 Aug 2014 12:45:11 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 
	Thunderbird/31.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        Michal Simek <michal.simek@xilinx.com>
CC: <kernel-janitors@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 12/14] ll_temac: delete unneeded test before of_node_put
References: <1407492475-26283-12-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1407492475-26283-12-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-imss-version: 2.032
X-imss-result: Passed
X-imss-scanInfo: M:P L:N SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:3.51.1032(14006.000)
X-imss-scores: Clean:99.90000 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Message-ID: <8c6f53e8-f0ae-4b5e-b852-50603bff0060@BN1BFFO11FD029.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009004)(6009001)(438002)(24454002)(51704005)(164054003)(377454003)(479174003)(189002)(199002)(77982001)(85306004)(65806001)(74662001)(47776003)(80022001)(33646002)(4396001)(1496007)(104016003)(79102001)(64706001)(106466001)(21056001)(107046002)(81542001)(74316001)(70736001)(74502001)(20776003)(50466002)(76482001)(102836001)(50986999)(99396002)(54356999)(76176999)(15202345003)(46102001)(85852003)(83072002)(83506001)(6806004)(95666004)(86362001)(81342001)(87936001)(44976005)(31696002)(23676002)(92726001)(83322001)(15975445006)(19580405001)(19580395003)(65826006)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB053;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 12:07 PM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Of_node_put supports NULL as its argument, so the initial test is not
> necessary.
> 
> Suggested by Uwe Kleine-König.
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e;
> @@
> 
> -if (e)
>    of_node_put(e);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/net/ethernet/xilinx/ll_temac_main.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
> index 8a6e5c2..36f4459 100644
> --- a/drivers/net/ethernet/xilinx/ll_temac_main.c
> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
> @@ -1148,8 +1148,7 @@ static int temac_of_remove(struct platform_device *op)
>  	temac_mdio_teardown(lp);
>  	unregister_netdev(ndev);
>  	sysfs_remove_group(&lp->dev->kobj, &temac_attr_group);
> -	if (lp->phy_node)
> -		of_node_put(lp->phy_node);
> +	of_node_put(lp->phy_node);
>  	lp->phy_node = NULL;
>  	iounmap(lp->regs);
>  	if (lp->sdma_regs)

Reviewed-by: Michal Simek <michal.simek@xilinx.com>

Thanks,
Michal



