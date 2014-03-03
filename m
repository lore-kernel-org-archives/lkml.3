Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaCCSwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:52:45 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:34463 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbaCCSwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:52:42 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18+i6bEtzCKM38POtx4FtPS
Date: Mon, 3 Mar 2014 10:52:36 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: kishon@ti.com, balbi@ti.com, george.cherian@ti.com, balajitk@ti.com,
        hdegoede@redhat.com, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 06/12] phy: omap: Select OMAP_OCP2SCP bus driver
Message-ID: <20140303185235.GC25804@atomide.com>
References: <1393859254-10937-1-git-send-email-rogerq@ti.com>
 <1393859254-10937-7-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393859254-10937-7-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140303 07:11]:
> The OMAP_USB2 and OMAP_PIP3 phy devices will not be
> detected if the OMAP_OCP2SCP driver is not present.
> So select it.

Selecting drivers like this will easily lead into missing
dependencies. Especially it's bad for tristate driver
options that people may want to have as loadable modules.

How about instead depends on OMAP_OCP2SCP?

Regards,

Tony

 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/phy/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 2f02ec8..afdab3e 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -44,6 +44,7 @@ config OMAP_USB2
>  	depends on USB_PHY
>  	select GENERIC_PHY
>  	select OMAP_CONTROL_PHY
> +	select OMAP_OCP2SCP
>  	help
>  	  Enable this to support the transceiver that is part of SOC. This
>  	  driver takes care of all the PHY functionality apart from comparator.
> @@ -55,6 +56,7 @@ config TI_PIPE3
>  	depends on ARCH_OMAP2PLUS || COMPILE_TEST
>  	select GENERIC_PHY
>  	select OMAP_CONTROL_PHY
> +	select OMAP_OCP2SCP
>  	help
>  	  Enable this to support the PIPE3 PHY that is part of TI SOCs. This
>  	  driver takes care of all the PHY functionality apart from comparator.
> -- 
> 1.8.3.2
> 
