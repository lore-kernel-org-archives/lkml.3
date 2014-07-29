Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaG2HC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 03:02:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52365 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbaG2HCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 03:02:55 -0400
Message-ID: <53D74718.9010502@ti.com>
Date: Tue, 29 Jul 2014 10:02:48 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Michael Welling <mwelling@emacinc.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <stern@rowland.harvard.edu>, <balbi@ti.com>
Subject: Re: [PATCH] drivers:mfd:omap-usb-host.c: Fix improper mask use.
References: <1406588464-19104-1-git-send-email-mwelling@emacinc.com>
In-Reply-To: <1406588464-19104-1-git-send-email-mwelling@emacinc.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 07/29/2014 02:01 AM, Michael Welling wrote:
> single-ulpi-bypass is a flag used for older OMAP3 silicon.
> 
> The flag when set, can excite code that improperly uses the
> OMAP_UHH_HOSTCONFIG_UPLI_BYPASS define to clear the corresponding bit.
> Instead it clears all of the other bits disabling all of the ports in
> the process.
> 
> Signed-off-by: Michael Welling <mwelling@emacinc.com>
> ---
>  drivers/mfd/omap-usb-host.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index b48d80c..33a9234 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -445,7 +445,7 @@ static unsigned omap_usbhs_rev1_hostconfig(struct usbhs_hcd_omap *omap,
>  
>  		for (i = 0; i < omap->nports; i++) {
>  			if (is_ehci_phy_mode(pdata->port_mode[i])) {
> -				reg &= OMAP_UHH_HOSTCONFIG_ULPI_BYPASS;
> +				reg &= ~OMAP_UHH_HOSTCONFIG_ULPI_BYPASS;
>  				break;
>  			}
>  		}
> 

Acked-by: Roger Quadros <rogerq@ti.com>

Good catch!

It seems the regression was introduced by commit c4df00aed9e2 in v3.9.
Could you please cc this patch to stable@vger.kernel.org

cheers,
-roger
