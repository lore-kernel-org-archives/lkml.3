Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab3BSDKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 22:10:00 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:34647 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab3BSDJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 22:09:59 -0500
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Feb 2013 22:09:59 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFAKjpIlFbdWOb/2dsb2JhbABEwC2BBRZzgh8BAQUyAUUBEAsYCRQCDwkDAgECAUUGDQEFAgKHfAMTsUqPf4xQgl4Hg0ADliyJWIcAgnoOgWgj
X-IPAS-Result: AgEFAKjpIlFbdWOb/2dsb2JhbABEwC2BBRZzgh8BAQUyAUUBEAsYCRQCDwkDAgECAUUGDQEFAgKHfAMTsUqPf4xQgl4Hg0ADliyJWIcAgnoOgWgj
Message-ID: <5122EAF6.9040302@igalia.com>
Date: Tue, 19 Feb 2013 04:01:10 +0100
From: =?ISO-8859-1?Q?Javier_Mu=F1oz?= <jmunhoz@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: Teddy Wang <teddy.wang@siliconmotion.com.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Devendra Naga <devendra.aaru@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/sm7xxfb: Convert to SIMPLE_DEV_PM_OPS
References: <1361229168-18137-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1361229168-18137-1-git-send-email-peterhuewe@gmx.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!

Acked-by: Javier Muñoz <jmunhoz@igalia.com>

On 02/19/2013 12:12 AM, Peter Huewe wrote:
> Instead of assigning the pm_ops fields individually we can simply use
> SIMPLE_DEV_PM_OPS.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/staging/sm7xxfb/sm7xxfb.c |   10 +---------
>  1 files changed, 1 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
> index 0764bbb..8add64b 100644
> --- a/drivers/staging/sm7xxfb/sm7xxfb.c
> +++ b/drivers/staging/sm7xxfb/sm7xxfb.c
> @@ -1006,15 +1006,7 @@ static int smtcfb_pci_resume(struct device *device)
>  	return 0;
>  }
>  
> -static const struct dev_pm_ops sm7xx_pm_ops = {
> -	.suspend = smtcfb_pci_suspend,
> -	.resume = smtcfb_pci_resume,
> -	.freeze = smtcfb_pci_suspend,
> -	.thaw = smtcfb_pci_resume,
> -	.poweroff = smtcfb_pci_suspend,
> -	.restore = smtcfb_pci_resume,
> -};
> -
> +static SIMPLE_DEV_PM_OPS(sm7xx_pm_ops, smtcfb_pci_suspend, smtcfb_pci_resume);
>  #define SM7XX_PM_OPS (&sm7xx_pm_ops)
>  
>  #else  /* !CONFIG_PM */

