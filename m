Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbbAEL4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:56:45 -0500
Received: from mail-bn1bon0057.outbound.protection.outlook.com ([157.56.111.57]:3286
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753130AbbAEL4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:56:44 -0500
Date: Mon, 5 Jan 2015 12:56:27 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] microblaze: intc: Don't override error codes
References: <1419013266-20568-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1419013266-20568-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21224.006
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <c2b51565316e46c18c9d0f6b8faee05b@BY2FFO11FD016.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(189002)(164054003)(377454003)(24454002)(199003)(479174004)(20776003)(46102003)(19580395003)(65956001)(6806004)(64706001)(108616004)(65806001)(575784001)(19580405001)(4396001)(86362001)(50986999)(106466001)(104016003)(47776003)(62966003)(31966008)(21056001)(450100001)(2950100001)(92726002)(77096005)(23746002)(50466002)(77156002)(120916001)(87936001)(99396003)(92566001)(83506001)(54356999)(107046002)(76176999)(74316001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB064;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB064;
X-Forefront-PRVS: 0447DB1C71
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2015 11:56:41.2725
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[62.221.5.235]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2FFO11HUB064
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2014 07:21 PM, Soren Brinkmann wrote:
> Just pass on error codes instead of overriding them.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/microblaze/kernel/intc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
> index 15c7c12ea0e7..01ae73088578 100644
> --- a/arch/microblaze/kernel/intc.c
> +++ b/arch/microblaze/kernel/intc.c
> @@ -148,13 +148,13 @@ static int __init xilinx_intc_of_init(struct device_node *intc,
>  	ret = of_property_read_u32(intc, "xlnx,num-intr-inputs", &nr_irq);
>  	if (ret < 0) {
>  		pr_err("%s: unable to read xlnx,num-intr-inputs\n", __func__);
> -		return -EINVAL;
> +		return ret;
>  	}
>  
>  	ret = of_property_read_u32(intc, "xlnx,kind-of-intr", &intr_mask);
>  	if (ret < 0) {
>  		pr_err("%s: unable to read xlnx,kind-of-intr\n", __func__);
> -		return -EINVAL;
> +		return ret;
>  	}
>  
>  	if (intr_mask > (u32)((1ULL << nr_irq) - 1))
> 

Applied all.

Thanks,
Michal
