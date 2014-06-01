Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaFASX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 14:23:29 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:26252
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750965AbaFASX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 14:23:27 -0400
X-WSS-ID: 0N6I5QX-08-LHO-02
X-M-MSG: 
Message-ID: <538B6F92.7010009@amd.com>
Date: Sun, 1 Jun 2014 13:23:14 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: <tj@kernel.org>
CC: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ata: Check and set 64-bit DMA mask for platform AHCI
 driver
References: <1400866510-3130-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1400866510-3130-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(24454002)(479174003)(51704005)(377454003)(199002)(189002)(36756003)(21056001)(77982001)(76482001)(86362001)(79102001)(68736004)(33656002)(19580395003)(81342001)(44976005)(102836001)(83506001)(101416001)(83322001)(19580405001)(64126003)(81542001)(92726001)(92566001)(23756003)(64706001)(59896001)(46102001)(47776003)(20776003)(80022001)(65956001)(83072002)(85852003)(50466002)(84676001)(87936001)(77096999)(87266999)(50986999)(54356999)(76176999)(97736001)(99396002)(31966008)(4396001)(74502001)(74662001)(61793002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB201;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02296943FF
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

I am following up on this patch.

Thank you,

Suravee

On 05/23/2014 12:35 PM, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> The current platform AHCI drier does not set the dma_mask correctly
> for 64-bit DMA capable AHCI controller.  This patch checks the AHCI
> capability bit and set the dma_mask and coherent_dma_mask accordingly.
>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> ---
>   drivers/ata/libahci_platform.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
> index 7cb3a85..85049ef 100644
> --- a/drivers/ata/libahci_platform.c
> +++ b/drivers/ata/libahci_platform.c
> @@ -368,6 +368,15 @@ int ahci_platform_init_host(struct platform_device *pdev,
>   	ahci_init_controller(host);
>   	ahci_print_info(host, "platform");
>
> +	if (hpriv->cap & HOST_CAP_64) {
> +		if (!dev->dma_mask)
> +			dev->dma_mask = &dev->coherent_dma_mask;
> +
> +		rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
> +		if (rc)
> +			return rc;
> +	}
> +
>   	return ata_host_activate(host, irq, ahci_interrupt, IRQF_SHARED,
>   				 &ahci_platform_sht);
>   }
>
