Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaBCHLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 02:11:19 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.113]:13855 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257AbaBCHLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 02:11:18 -0500
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Feb 2014 02:11:17 EST
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-10.tower-193.messagelabs.com!1391411052!5191035!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 03 Feb 2014 08:04:13 +0100
Date: Mon, 3 Feb 2014 08:04:06 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: <bp@suse.de>, <m.chehab@samsung.com>
CC: <linux-edac@vger.kernel.org>, <johannes.thumshirn@men.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac/85xx: Remove deprecated IRQF_DISABLED
Message-ID: <20140203070404.GA32443@jtlinux>
References: <1390293747-11185-1-git-send-email-johannes.thumshirn@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1390293747-11185-1-git-send-email-johannes.thumshirn@men.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 09:42:27AM +0100, Johannes Thumshirn wrote:
> Remove IRQF_DISABLED as it is a NOOP.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> ---
>  drivers/edac/mpc85xx_edac.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
> index 8f918217..f4aec2e 100644
> --- a/drivers/edac/mpc85xx_edac.c
> +++ b/drivers/edac/mpc85xx_edac.c
> @@ -357,7 +357,7 @@ int mpc85xx_pci_err_probe(struct platform_device *op)
>  		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
>  		res = devm_request_irq(&op->dev, pdata->irq,
>  				       mpc85xx_pci_isr,
> -				       IRQF_DISABLED | IRQF_SHARED,
> +				       IRQF_SHARED,
>  				       "[EDAC] PCI err", pci);
>  		if (res < 0) {
>  			printk(KERN_ERR
> @@ -633,7 +633,7 @@ static int mpc85xx_l2_err_probe(struct platform_device *op)
>  	if (edac_op_state == EDAC_OPSTATE_INT) {
>  		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
>  		res = devm_request_irq(&op->dev, pdata->irq,
> -				       mpc85xx_l2_isr, IRQF_DISABLED,
> +				       mpc85xx_l2_isr, 0,
>  				       "[EDAC] L2 err", edac_dev);
>  		if (res < 0) {
>  			printk(KERN_ERR
> @@ -1133,7 +1133,7 @@ static int mpc85xx_mc_err_probe(struct platform_device *op)
>  		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
>  		res = devm_request_irq(&op->dev, pdata->irq,
>  				       mpc85xx_mc_isr,
> -					IRQF_DISABLED | IRQF_SHARED,
> +				       IRQF_SHARED,
>  				       "[EDAC] MC err", mci);
>  		if (res < 0) {
>  			printk(KERN_ERR "%s: Unable to request irq %d for "
> --
> 1.8.5.2
>

Boris, Mauro:

Ping?

Johannes
