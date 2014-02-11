Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaBKV3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:29:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbaBKV3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:29:39 -0500
Date: Tue, 11 Feb 2014 13:30:54 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: Felipe Balbi <balbi@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "open list:USB PHY LAYER" <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 01/28] Remove CPU_MMP3
Message-ID: <20140211213054.GA2555@kroah.com>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
 <1391971686-9517-2-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1391971686-9517-2-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 07:47:39PM +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Acked-by: Paul Bolle <pebolle@tiscali.nl>
> 
> ---
>  drivers/usb/phy/Kconfig      | 1 -
>  drivers/video/mmp/Kconfig    | 2 +-
>  drivers/video/mmp/hw/Kconfig | 2 +-
>  3 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index 7d1451d..b9b1c52 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -61,7 +61,6 @@ config KEYSTONE_USB_PHY
>  
>  config MV_U3D_PHY
>  	bool "Marvell USB 3.0 PHY controller Driver"
> -	depends on CPU_MMP3
>  	select USB_PHY
>  	help
>  	  Enable this to support Marvell USB 3.0 phy controller for Marvell

Do this and the driver breaks the build so it needs to depend on
something:

drivers/usb/phy/phy-mv-u3d-usb.c: In function ‘mv_u3d_phy_read’:
drivers/usb/phy/phy-mv-u3d-usb.c:42:2: error: implicit declaration of function ‘writel_relaxed’ [-Werror=implicit-function-declaration]

Sorry, I can't take this as-is.

greg k-h
