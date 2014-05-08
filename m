Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaEHOWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:22:41 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53675 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbaEHOWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:22:39 -0400
Message-ID: <1399558909.8165.8.camel@iivanov-dev>
Subject: Re: [PATCH 5/8] usb: phy: msm: reset controller is mandatory now
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Thu, 08 May 2014 17:21:49 +0300
In-Reply-To: <1399557141-1346645-6-git-send-email-arnd@arndb.de>
References: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
	 <1399557141-1346645-6-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Arnd, 

On Thu, 2014-05-08 at 15:52 +0200, Arnd Bergmann wrote:
> Commit a27345434134 "usb: phy: msm: Use reset framework for LINK
> and PHY resets" introduced a mandatory call to reset_control_get
> into the msm usb phy driver, which means we have to add a Kconfig
> dependency on the API to avoid this build error:
> 
> phy/phy-msm-usb.c: In function 'msm_otg_read_dt':
> phy/phy-msm-usb.c:1461:2: error: implicit declaration of function 'devm_reset_control_get' [-Werror=implicit-function-declaration]
>   motg->link_rst = devm_reset_control_get(&pdev->dev, "link");
>   ^
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> ---
>  drivers/usb/host/Kconfig | 2 +-
>  drivers/usb/phy/Kconfig  | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 3d9e540..890fc8c 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -168,7 +168,7 @@ config USB_EHCI_HCD_AT91
>  
>  config USB_EHCI_MSM
>  	tristate "Support for Qualcomm QSD/MSM on-chip EHCI USB controller"
> -	depends on ARCH_MSM
> +	depends on ARCH_MSM && RESET_CONTROLLER

This driver did not use reset controller API.

>  	select USB_EHCI_ROOT_HUB_TT
>  	select USB_MSM_OTG
>  	---help---
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index 359a6c1..65bec8f 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -165,6 +165,7 @@ config USB_ISP1301
>  config USB_MSM_OTG
>  	tristate "Qualcomm on-chip USB OTG controller support"
>  	depends on (USB || USB_GADGET) && (ARCH_MSM || ARCH_QCOM)
> +	depends on RESET_CONTROLLER

This is fine. 

Thank you.
Ivan

