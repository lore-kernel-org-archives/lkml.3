Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3CKNPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:15:47 -0400
Received: from 19.mo4.mail-out.ovh.net ([87.98.179.66]:40914 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751690Ab3CKNPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:15:45 -0400
Date: Mon, 11 Mar 2013 14:11:26 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        nicolas.ferre@atmel.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH v6 12/16] spi/spi-atmel: add pinctrl support for atmel
 spi
Message-ID: <20130311131126.GB2001@game.jcrosoft.org>
References: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
 <1362627243-9351-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362627243-9351-1-git-send-email-wenyou.yang@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 15635934957511814021
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrfeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrfeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:34 Thu 07 Mar     , Wenyou Yang wrote:
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Cc: spi-devel-general@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/spi/spi-atmel.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> index 1e212d1..6b166f4 100644
> --- a/drivers/spi/spi-atmel.c
> +++ b/drivers/spi/spi-atmel.c
> @@ -23,6 +23,7 @@
>  #include <linux/platform_data/atmel.h>
>  #include <linux/platform_data/dma-atmel.h>
>  #include <linux/of.h>
> +#include <linux/pinctrl/consumer.h>
>  
>  #include <linux/io.h>
>  #include <linux/gpio.h>
> @@ -1493,11 +1494,18 @@ static int atmel_spi_probe(struct platform_device *pdev)
>  	int			ret;
>  	struct spi_master	*master;
>  	struct atmel_spi	*as;
> +	struct pinctrl		*pinctrl;
>  
>  	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!regs)
>  		return -ENXIO;
>  
> +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> +	if (IS_ERR(pinctrl)) {
> +		dev_err(&pdev->dev, "Failed to request pinctrl\n");
> +		return PTR_ERR(pinctrl);
> +	}

drop this, this is handled at bus level

Best Regards,
J.
> +
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0)
>  		return irq;
> -- 
> 1.7.9.5
> 
