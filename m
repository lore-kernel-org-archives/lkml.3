Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbaLAUOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:14:50 -0500
Received: from mail-bl2on0073.outbound.protection.outlook.com ([65.55.169.73]:9728
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932242AbaLAUOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:14:48 -0500
Message-ID: <547CCC27.4050404@opensource.altera.com>
Date: Mon, 1 Dec 2014 14:14:31 -0600
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <davem@davemloft.net>, <peppe.cavallaro@st.com>
CC: <dinh.linux@gmail.com>, <maxime.ripard@free-electrons.com>,
        <olof@lixom.net>, <vbridger@opensource.altera.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] stmmac: platform: fix stmmac probe failure
References: <1417464054-8777-1-git-send-email-dinguyen@opensource.altera.com>
In-Reply-To: <1417464054-8777-1-git-send-email-dinguyen@opensource.altera.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.103.66.154]
X-ClientProxiedBy: BN1PR12CA0032.namprd12.prod.outlook.com (25.160.77.42) To
 BY1PR0301MB1192.namprd03.prod.outlook.com (25.160.195.150)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1192;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1192;
X-Forefront-PRVS: 0412A98A59
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(979002)(6009001)(377454003)(24454002)(479174003)(199003)(51704005)(189002)(46102003)(15202345003)(92566001)(15188555004)(92726001)(106356001)(105586002)(107046002)(95666004)(19300405004)(64126003)(31966008)(99396003)(102836001)(4396001)(120916001)(23756003)(97736003)(101416001)(87976001)(21056001)(19580405001)(80316001)(59896002)(575784001)(86362001)(33656002)(65816999)(76176999)(50986999)(87266999)(54356999)(15975445006)(83506001)(40100003)(19580395003)(122386002)(47776003)(20776003)(64706001)(42186005)(50466002)(68736005)(65956001)(66066001)(65806001)(77096004)(62966003)(77156002)(562404015)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1192;H:Dinhs-MacBook-Pro.local;FPR:;SPF:None;MLV:ovrnspm;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1192;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB0840;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for the noise, but it looks like Arnd has already send a patch
for this.

http://www.spinics.net/lists/netdev/msg306603.html

Dinh

On 12/1/14, 2:00 PM, dinguyen@opensource.altera.com wrote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> The commit 571dcfde23712b ("stmmac: platform: fix default values of the filter
> bins setting") broke support for stmmac probe for all CONFIG_OF platforms.
> 
> [    0.743567] Unable to handle kernel NULL pointer dereference at virtual address 00000048
> [    0.751679] pgd = c0004000
> [    0.754384] [00000048] *pgd=00000000
> [    0.757983] Internal error: Oops: 805 [#1] SMP ARM
> [    0.762774] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc7 #1
> [    0.769034] task: ee86c000 ti: ee870000 task.ti: ee870000
> [    0.774429] PC is at stmmac_pltfr_probe+0x40/0x5d0
> [    0.779217] LR is at devm_ioremap_nocache+0x54/0x74
> ...
> [    0.951644] [<c0287938>] (stmmac_pltfr_probe) from [<c0234c4c>] (platform_drv_probe+0x44/0xa4)
> [    0.960250] [<c0234c4c>] (platform_drv_probe) from [<c023390c>] (driver_probe_device+0x10c/0x240)
> [    0.969113] [<c023390c>] (driver_probe_device) from [<c0233b10>] (__driver_attach+0x8c/0x90)
> [    0.977544] [<c0233b10>] (__driver_attach) from [<c02320fc>] (bus_for_each_dev+0x6c/0xa0)
> 
> The reason is that in stmmac_pltfr_probe(), the plat_dat on a CONFIG_OF
> platform is NULL until devm_kzalloc() is called to allocate plat_dat.
> 
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> index 5b0da39..62c9e75 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> @@ -265,12 +265,6 @@ static int stmmac_pltfr_probe(struct platform_device *pdev)
>  
>  	plat_dat = dev_get_platdata(&pdev->dev);
>  
> -	/* Set default value for multicast hash bins */
> -	plat_dat->multicast_filter_bins = HASH_TABLE_SIZE;
> -
> -	/* Set default value for unicast filter entries */
> -	plat_dat->unicast_filter_entries = 1;
> -
>  	if (pdev->dev.of_node) {
>  		if (!plat_dat)
>  			plat_dat = devm_kzalloc(&pdev->dev,
> @@ -288,6 +282,12 @@ static int stmmac_pltfr_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	/* Set default value for multicast hash bins */
> +	plat_dat->multicast_filter_bins = HASH_TABLE_SIZE;
> +
> +	/* Set default value for unicast filter entries */
> +	plat_dat->unicast_filter_entries = 1;
> +
>  	/* Custom setup (if needed) */
>  	if (plat_dat->setup) {
>  		plat_dat->bsp_priv = plat_dat->setup(pdev);
> 
