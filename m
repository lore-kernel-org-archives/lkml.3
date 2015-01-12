Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbbALOij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:38:39 -0500
Received: from mail-by2on0131.outbound.protection.outlook.com ([207.46.100.131]:13910
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752111AbbALOii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:38:38 -0500
X-Greylist: delayed 951 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2015 09:38:37 EST
Message-ID: <54B3D899.5060204@freescale.com>
Date: Mon, 12 Jan 2015 16:22:17 +0200
From: Claudiu Manoil <claudiu.manoil@freescale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
CC: <davem@davemloft.net>, <peter.senna@gmail.com>,
        <shemminger@linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gianfar: correct the bad expression while writing bit-pattern
References: <1421048596-22639-1-git-send-email-sanjeev_sharma@mentor.com>
In-Reply-To: <1421048596-22639-1-git-send-email-sanjeev_sharma@mentor.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=claudiu.manoil@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(164054003)(479174004)(24454002)(189002)(51704005)(377454003)(87936001)(65956001)(77156002)(62966003)(36756003)(120886001)(23746002)(104016003)(105606002)(97736003)(110136001)(106466001)(46102003)(83506001)(6806004)(85426001)(19580395003)(64126003)(33656002)(64706001)(76176999)(50986999)(87266999)(54356999)(47776003)(80316001)(86362001)(19580405001)(65816999)(59896002)(92566002)(50466002)(65806001)(2950100001)(68736005)(77096005);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0628;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN1PR0301MB0628;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0628;
X-Forefront-PRVS: 0454444834
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0628;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2015 14:22:43.5366
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0628
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0754;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/12/2015 9:43 AM, Sanjeev Sharma wrote:
> This patch correct the bad expression while writing the
> bit-pattern from software's buffer to hardware registers.
>
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>   drivers/net/ethernet/freescale/gianfar_ethtool.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
> index 3e1a9c1..1ccca72 100644
> --- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
> +++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
> @@ -1586,7 +1586,7 @@ static int gfar_write_filer_table(struct gfar_private *priv,
>   		return -EBUSY;
>
>   	/* Fill regular entries */
> -	for (; i < MAX_FILER_IDX - 1 && (tab->fe[i].ctrl | tab->fe[i].ctrl);
> +	for (; i < MAX_FILER_IDX - 1 && ( i < tab->fe[i].ctrl);
>   	     i++)

Why do you think 'i' can be compared with the 'ctrl' field?
Is the control field an index (provide proof if yes)?  I doubt it...

Thanks,
Claudiu

