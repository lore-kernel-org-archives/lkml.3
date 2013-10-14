Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3JNJ4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:56:13 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.145]:8844 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057Ab3JNJ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:56:11 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-3.tower-180.messagelabs.com!1381744568!24248727!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 14 Oct 2013 11:56:08 +0200
Date: Mon, 14 Oct 2013 11:56:02 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: <dougthompson@xmission.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EDAC: remove deprecated IRQF_DISABLED
Message-ID: <20131014095602.GA14274@jtlinux>
References: <1381641477-7373-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1381641477-7373-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 14 Oct 2013 09:56:07.0678 (UTC) FILETIME=[9A8309E0:01CEC8C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 07:17:57AM +0200, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
>
> It's a NOOP since 2.6.35 and it will be removed one day.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  drivers/edac/mpc85xx_edac.c | 7 +++----
>  drivers/edac/mv64x60_edac.c | 8 ++++----
>  drivers/edac/ppc4xx_edac.c  | 4 ++--
>  3 files changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
> index 3eb32f6..7785807 100644
> --- a/drivers/edac/mpc85xx_edac.c
> +++ b/drivers/edac/mpc85xx_edac.c
> @@ -297,7 +297,7 @@ int mpc85xx_pci_err_probe(struct platform_device *op)
>  	if (edac_op_state == EDAC_OPSTATE_INT) {
>  		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
>  		res = devm_request_irq(&op->dev, pdata->irq,
> -				       mpc85xx_pci_isr, IRQF_DISABLED,
> +				       mpc85xx_pci_isr, 0,
>  				       "[EDAC] PCI err", pci);
>  		if (res < 0) {
>  			printk(KERN_ERR
> @@ -579,7 +579,7 @@ static int mpc85xx_l2_err_probe(struct platform_device *op)
>  	if (edac_op_state == EDAC_OPSTATE_INT) {
>  		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
>  		res = devm_request_irq(&op->dev, pdata->irq,
> -				       mpc85xx_l2_isr, IRQF_DISABLED,
> +				       mpc85xx_l2_isr, 0,
>  				       "[EDAC] L2 err", edac_dev);
>  		if (res < 0) {
>  			printk(KERN_ERR
> @@ -1078,8 +1078,7 @@ static int mpc85xx_mc_err_probe(struct platform_device *op)
>  		/* register interrupts */
>  		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
>  		res = devm_request_irq(&op->dev, pdata->irq,
> -				       mpc85xx_mc_isr,
> -					IRQF_DISABLED | IRQF_SHARED,
> +				       mpc85xx_mc_isr, IRQF_SHARED,
>  				       "[EDAC] MC err", mci);
>  		if (res < 0) {
>  			printk(KERN_ERR "%s: Unable to request irq %d for "

Hi Michael,

mpc85xx_edac has them already removed in the version that is going into 3.13.

Sorry for the inconvenience. I'll set up a public tree at my github repo, so
everyone can see the current mpc85xx_edac state.

Byte,
Johannes
