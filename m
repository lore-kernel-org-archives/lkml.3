Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab3JHGjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 02:39:13 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.152]:8084 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813Ab3JHGjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 02:39:12 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-13.tower-180.messagelabs.com!1381214349!30300808!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Tue, 08 Oct 2013 08:39:09 +0200
Date: Tue, 8 Oct 2013 08:39:02 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Doug Thompson <dougthompson@xmission.com>, Borislav Petkov <bp@suse.de>,
        Baruch Siach <baruch@tkos.co.il>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mpc85xx_edac: Remove unused function
Message-ID: <20131008063901.GA32409@jtlinux>
References: <1381158835-10804-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1381158835-10804-1-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 08 Oct 2013 06:39:08.0650 (UTC) FILETIME=[1757FCA0:01CEC3F1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 05:13:55PM +0200, Thierry Reding wrote:
> Commit 905e75c (powerpc/fsl-pci: Unify pci/pcie initialization code)
> removed the struct platform_driver that held the last reference to the
> mpc85xx_pci_err_remove() function. Remove the function since it is
> effectively dead code.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/edac/mpc85xx_edac.c | 23 -----------------------
>  1 file changed, 23 deletions(-)
>
> diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
> index 3eb32f6..b1e7106 100644
> --- a/drivers/edac/mpc85xx_edac.c
> +++ b/drivers/edac/mpc85xx_edac.c
> @@ -326,29 +326,6 @@ err:
>  	return res;
>  }
>  EXPORT_SYMBOL(mpc85xx_pci_err_probe);
> -
> -static int mpc85xx_pci_err_remove(struct platform_device *op)
> -{
> -	struct edac_pci_ctl_info *pci = dev_get_drvdata(&op->dev);
> -	struct mpc85xx_pci_pdata *pdata = pci->pvt_info;
> -
> -	edac_dbg(0, "\n");
> -
> -	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_CAP_DR,
> -		 orig_pci_err_cap_dr);
> -
> -	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_EN, orig_pci_err_en);
> -
> -	edac_pci_del_device(pci->dev);
> -
> -	if (edac_op_state == EDAC_OPSTATE_INT)
> -		irq_dispose_mapping(pdata->irq);
> -
> -	edac_pci_free_ctl_info(pci);
> -
> -	return 0;
> -}
> -
>  #endif				/* CONFIG_PCI */
>
>  /**************************** L2 Err device ***************************/
> --
> 1.8.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Thierry,

Sorry, but I already have this patch in
http://lkml.indiana.edu/hypermail/linux/kernel/1309.2/03410.html

But anyways, thanks
Johannes
