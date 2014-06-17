Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111AbaFQO0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:26:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38604 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932935AbaFQO0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:26:11 -0400
Date: Tue, 17 Jun 2014 10:26:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: EHCI: tegra: Fix use-after-free in .remove()
In-Reply-To: <1403014660-15509-1-git-send-email-ttynkkynen@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1406171025530.1187-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, Tuomas Tynkkynen wrote:

> The tegra_ehci_hcd structure is located in the private space allocated
> by the core USB code so it must not be accessed after the HCD is
> freed.
> 
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> ---
>  drivers/usb/host/ehci-tegra.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index 6fdcb8a..5590567 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
> @@ -479,10 +479,11 @@ static int tegra_ehci_remove(struct platform_device *pdev)
>  
>  	usb_phy_shutdown(hcd->phy);
>  	usb_remove_hcd(hcd);
> -	usb_put_hcd(hcd);
>  
>  	clk_disable_unprepare(tegra->clk);
>  
> +	usb_put_hcd(hcd);
> +
>  	return 0;
>  }

Acked-by: Alan Stern <stern@rowland.harvard.edu>

