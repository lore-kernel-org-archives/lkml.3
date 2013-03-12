Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab3CLLSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:18:16 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33576 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab3CLLSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:18:14 -0400
Message-ID: <513F0EC8.60709@cogentembedded.com>
Date: Tue, 12 Mar 2013 15:17:28 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org, juhosg@openwrt.org,
        blogic@openwrt.org, kaloz@openwrt.org, xsecute@googlemail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pci: convert to devm_ioremap_resource()
References: <1363073281-9939-1-git-send-email-silviupopescu1990@gmail.com>
In-Reply-To: <1363073281-9939-1-git-send-email-silviupopescu1990@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12-03-2013 11:28, Silviu-Mihai Popescu wrote:

> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.

> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.

    There were no error messages as far as I could see, so this passage seems 
superfluous...

> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> ---
>   arch/mips/pci/pci-ar71xx.c |    6 +++---
>   arch/mips/pci/pci-ar724x.c |   18 +++++++++---------
>   2 files changed, 12 insertions(+), 12 deletions(-)

> diff --git a/arch/mips/pci/pci-ar71xx.c b/arch/mips/pci/pci-ar71xx.c
> index 412ec02..18517dd 100644
> --- a/arch/mips/pci/pci-ar71xx.c
> +++ b/arch/mips/pci/pci-ar71xx.c
> @@ -366,9 +366,9 @@ static int ar71xx_pci_probe(struct platform_device *pdev)
>   	if (!res)
>   		return -EINVAL;
>
> -	apc->cfg_base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!apc->cfg_base)
> -		return -ENOMEM;
> +	apc->cfg_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(apc->cfg_base))
> +		return PTR_ERR(apc->cfg_base);
>
>   	apc->irq = platform_get_irq(pdev, 0);
>   	if (apc->irq < 0)
> diff --git a/arch/mips/pci/pci-ar724x.c b/arch/mips/pci/pci-ar724x.c
> index 8a0700d..65ec032 100644
> --- a/arch/mips/pci/pci-ar724x.c
> +++ b/arch/mips/pci/pci-ar724x.c
> @@ -365,25 +365,25 @@ static int ar724x_pci_probe(struct platform_device *pdev)
>   	if (!res)
>   		return -EINVAL;
>
> -	apc->ctrl_base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (apc->ctrl_base == NULL)
> -		return -EBUSY;
> +	apc->ctrl_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(apc->ctrl_base))
> +		return PTR_ERR(apc->ctrl_base);
>
>   	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cfg_base");
>   	if (!res)
>   		return -EINVAL;
>
> -	apc->devcfg_base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!apc->devcfg_base)
> -		return -EBUSY;
> +	apc->devcfg_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(apc->devcfg_base))
> +		return PTR_ERR(apc->devcfg_base);
>
>   	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "crp_base");
>   	if (!res)
>   		return -EINVAL;
>
> -	apc->crp_base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (apc->crp_base == NULL)
> -		return -EBUSY;
> +	apc->crp_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(apc->crp_base))
> +		return PTR_ERR(apc->crp_base);
>
>   	apc->irq = platform_get_irq(pdev, 0);
>   	if (apc->irq < 0)

WBR, Sergei


