Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaJFQii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:38:38 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:52281 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbaJFQih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:38:37 -0400
Message-ID: <1412613514.8561.3.camel@x220>
Subject: Re: [PATCH] usb: Remove references to non-existent PLAT_S5P symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, jg1.han@samsung.com,
        linux-samsung-soc@vger.kernel.org
Date: Mon, 06 Oct 2014 18:38:34 +0200
In-Reply-To: <1412610430-8647-1-git-send-email-s.nawrocki@samsung.com>
References: <1412610430-8647-1-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2014 16:38:34.0711 (UTC) FILETIME=[F8BC9E70:01CFE183]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-06 at 17:47 +0200, Sylwester Nawrocki wrote:
> The PLAT_S5P Kconfig symbol was removed in commit d78c16ccde96
> ("ARM: SAMSUNG: Remove remaining legacy code"). There are still
> some references left, fix that by replacing them with ARCH_S5PV210.
> 
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

As with the "[media]" patch: should
     Fixes: d78c16ccde96 ("ARM: SAMSUNG: Remove remaining legacy code")

be added so this will end up in stable for v3.17?

>  drivers/usb/host/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 82800a7..6f1d48e 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -220,7 +220,7 @@ config USB_EHCI_SH
>  
>  config USB_EHCI_EXYNOS
>         tristate "EHCI support for Samsung S5P/EXYNOS SoC Series"
> -       depends on PLAT_S5P || ARCH_EXYNOS
> +       depends on ARCH_S5PV210 || ARCH_EXYNOS
>         help
>  	Enable support for the Samsung Exynos SOC's on-chip EHCI controller.
>  
> @@ -527,7 +527,7 @@ config USB_OHCI_SH
>  
>  config USB_OHCI_EXYNOS
>  	tristate "OHCI support for Samsung S5P/EXYNOS SoC Series"
> -	depends on PLAT_S5P || ARCH_EXYNOS
> +	depends on ARCH_S5PV210 || ARCH_EXYNOS
>  	help
>  	 Enable support for the Samsung Exynos SOC's on-chip OHCI controller.
>  

Thanks again!


Paul Bolle

