Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3EVOVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:21:20 -0400
Received: from netrider.rowland.org ([192.131.102.5]:53961 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755235Ab3EVOVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:21:19 -0400
Date: Wed, 22 May 2013 10:21:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Wolfram Sang <wsa@the-dreams.de>
cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/3] drivers/usb/host: remove leftover release_mem_region
In-Reply-To: <1369228886-3527-2-git-send-email-wsa@the-dreams.de>
Message-ID: <Pine.LNX.4.44L0.1305221021010.22289-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013, Wolfram Sang wrote:

> When converting this driver to devm_ioremap_resource, the removal of this now
> unneeded function has been forgotten.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/usb/host/ohci-nxp.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
> index f303cb0..f1db7eb 100644
> --- a/drivers/usb/host/ohci-nxp.c
> +++ b/drivers/usb/host/ohci-nxp.c
> @@ -351,7 +351,6 @@ static int usb_hcd_nxp_remove(struct platform_device *pdev)
>  
>  	usb_remove_hcd(hcd);
>  	nxp_stop_hc();
> -	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
>  	usb_put_hcd(hcd);
>  	clk_disable(usb_pll_clk);
>  	clk_put(usb_pll_clk);

Acked-by: Alan Stern <stern@rowland.harvard.edu>

