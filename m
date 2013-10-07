Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab3JGPes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:34:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46685 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab3JGPen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:34:43 -0400
Date: Mon, 7 Oct 2013 17:34:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Doug Thompson <dougthompson@xmission.com>, Borislav Petkov <bp@suse.de>,
        Baruch Siach <baruch@tkos.co.il>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: Re: [PATCH] mpc85xx_edac: Remove unused function
Message-ID: <20131007153441.GA12771@pd.tnic>
References: <1381158835-10804-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381158835-10804-1-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm guessing this one is for Johannes. CCed...

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
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
