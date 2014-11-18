Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaKRRBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:01:37 -0500
Received: from mail-bn1bon0071.outbound.protection.outlook.com ([157.56.111.71]:63451
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753660AbaKRRBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:01:36 -0500
Date: Tue, 18 Nov 2014 17:47:02 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Michal Simek <michal.simek@xilinx.com>,
        =?windows-1252?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
CC: <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] net: can: comparison of unsigned variable
References: <1416318427-28676-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1416318427-28676-2-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1416318427-28676-2-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21114.000
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <67e24b2a43564b55960a31c62e5d44ca@BY2FFO11FD055.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(164054003)(377454003)(51704005)(479174003)(24454002)(199003)(87936001)(108616004)(99396003)(74316001)(21056001)(19580395003)(46102003)(83506001)(62966003)(44976005)(86362001)(92566001)(6806004)(106466001)(23746002)(107046002)(54356999)(31966008)(50986999)(76176999)(120916001)(65806001)(64126003)(64706001)(50466002)(102836001)(77156002)(4396001)(19580405001)(104016003)(65956001)(95666004)(20776003)(47776003)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB017;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB017;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB017;
X-Forefront-PRVS: 039975700A
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB017;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 02:47 PM, Sudip Mukherjee wrote:
> err was of the type u32. it was being compared with < 0, and being
> an unsigned variable the comparison would have been always false.
> 
> moreover, err was getting the return value from set_reset_mode()
> and xcan_set_bittiming(), and both are returning int.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>  drivers/net/can/xilinx_can.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
> index 72fe96f..67c2dd4 100644
> --- a/drivers/net/can/xilinx_can.c
> +++ b/drivers/net/can/xilinx_can.c
> @@ -300,7 +300,8 @@ static int xcan_set_bittiming(struct net_device *ndev)
>  static int xcan_chip_start(struct net_device *ndev)
>  {
>  	struct xcan_priv *priv = netdev_priv(ndev);
> -	u32 err, reg_msr, reg_sr_mask;
> +	u32 reg_msr, reg_sr_mask;
> +	int err;
>  	unsigned long timeout;
>  
>  	/* Check if it is in reset mode */
> 

Reviewed-by: Michal Simek <michal.simek@xilinx.com>

Thanks,
Michal

