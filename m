Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbaCTRNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:13:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45153 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672AbaCTRNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:13:37 -0400
Message-ID: <532B2183.2080309@ti.com>
Date: Thu, 20 Mar 2014 13:12:35 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <computersforpeace@gmail.com>
CC: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, <dwmw2@infradead.org>,
        <galak@codeaurora.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH 2/3] mtd: davinci-nand: add dts property for NAND_NO_SUBPAGE_WRITE
 option
References: <1395335184-4745-1-git-send-email-ivan.khoronzhuk@ti.com> <1395335184-4745-3-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1395335184-4745-3-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris,

On Thursday 20 March 2014 01:06 PM, Ivan Khoronzhuk wrote:
> From: Murali Karicheri <m-karicheri2@ti.com>
> 
> After testing NAND flash with ubifs for k2hk-emv board were committed
> that flash doesn't support subpage writing, so we can fix it by
> adding a property to disable subpage write.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
Can you please pick this up for 3.15 fixes ? Ofcourse assuming DT folks
are ok with the patch.

I can then take patch 1/3 and 3/3 in my 3.15 fixes queue.

>  Documentation/devicetree/bindings/mtd/davinci-nand.txt | 2 ++
>  drivers/mtd/nand/davinci_nand.c                        | 3 +++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mtd/davinci-nand.txt b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
> index cfb18ab..50af930 100644
> --- a/Documentation/devicetree/bindings/mtd/davinci-nand.txt
> +++ b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
> @@ -53,6 +53,8 @@ Recommended properties :
>  				identifier is saved in OOB area. If not present
>  				false.
>  
> +- ti,davinci-nosubpage-write:	disable subpage write for the device
> +
>  Deprecated properties:
>  
>  - ti,davinci-ecc-mode:		operation mode of the NAND ecc mode. ECC mode
> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
> index 4615d79..3ba058d 100644
> --- a/drivers/mtd/nand/davinci_nand.c
> +++ b/drivers/mtd/nand/davinci_nand.c
> @@ -581,6 +581,9 @@ static struct davinci_nand_pdata
>  		    of_property_read_bool(pdev->dev.of_node,
>  			"ti,davinci-nand-use-bbt"))
>  			pdata->bbt_options = NAND_BBT_USE_FLASH;
> +		if (of_property_read_bool(pdev->dev.of_node,
> +			"ti,davinci-no-subpage-write"))
> +			pdata->options |= NAND_NO_SUBPAGE_WRITE;
>  	}
>  
>  	return dev_get_platdata(&pdev->dev);
> 

