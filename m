Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaJWMCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:02:43 -0400
Received: from mail-bn1bon0065.outbound.protection.outlook.com ([157.56.111.65]:43008
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754781AbaJWMCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:02:42 -0400
Date: Thu, 23 Oct 2014 13:47:45 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mike Looijmans <mike.looijmans@topic.nl>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <michal.simek@xilinx.com>, <chris@printf.net>, <ulf.hansson@linaro.org>
Subject: Re: [PATCH 2/2] mmc/host/sdhci-of-arasan.c: Skip EPROBE_DEFER error
 messages
References: <1414063861-5491-1-git-send-email-mike.looijmans@topic.nl>
 <1414063861-5491-2-git-send-email-mike.looijmans@topic.nl>
In-Reply-To: <1414063861-5491-2-git-send-email-mike.looijmans@topic.nl>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21042.001
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <40072ff932074ee189999faf5dc0a434@BL2FFO11FD037.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(164054003)(189002)(479174003)(377454003)(51704005)(76104003)(199003)(31966008)(87936001)(64706001)(76482002)(54356999)(4396001)(92566001)(108616004)(99396003)(23746002)(230783001)(85306004)(83506001)(46102003)(65956001)(64126003)(80022003)(120916001)(74316001)(50466002)(104016003)(106466001)(6806004)(20776003)(44976005)(95666004)(21056001)(85852003)(102836001)(19580405001)(50986999)(2201001)(76176999)(47776003)(86362001)(107046002)(19580395003)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB011;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB011;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0373D94D15
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On 10/23/2014 01:31 PM, Mike Looijmans wrote:
> When the error code is -EPROBE_DEFER, this will already be reported
> so don't emit an error message in that case.
> 
> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
> ---
>  drivers/mmc/host/sdhci-of-arasan.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
> index 7ac6718..d5812a0 100644
> --- a/drivers/mmc/host/sdhci-of-arasan.c
> +++ b/drivers/mmc/host/sdhci-of-arasan.c
> @@ -161,7 +161,8 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
>  	host = sdhci_pltfm_init(pdev, &sdhci_arasan_pdata, 0);
>  	if (IS_ERR(host)) {
>  		ret = PTR_ERR(host);
> -		dev_err(&pdev->dev, "platform init failed (%d)\n", ret);
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(&pdev->dev, "platform init failed (%d)\n", ret);
>  		goto clk_disable_all;
>  	}
>  
> @@ -172,7 +173,8 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
>  
>  	ret = sdhci_add_host(host);
>  	if (ret) {
> -		dev_err(&pdev->dev, "platform register failed (%d)\n", ret);
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(&pdev->dev, "platform register failed (%d)\n", ret);
>  		goto err_pltfm_free;
>  	}


I checked other drivers and they are not reporting these bugs. I have briefly looked
at sdhci_add_host and sdhci_platfm_init and they are pretty good error description
+ core itself should report if driver probe failed.
That's why I think that it is just reasonable to remove these both dev_err completely.

What do you think?

Thanks,
Michal
