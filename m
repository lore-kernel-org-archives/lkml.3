Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab3LZNFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 08:05:16 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:50404 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3LZNFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 08:05:14 -0500
Date: Thu, 26 Dec 2013 15:05:04 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: balbi@ti.com, linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        santosh.shilimkar@ti.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] phy: kconfig: add depends on "USB_PHY" to OMAP_USB2
 and TWL4030_USB
Message-ID: <20131226130504.GA19462@blackmetal.musicnaut.iki.fi>
References: <1386079732-19657-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386079732-19657-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 03, 2013 at 07:38:52PM +0530, Kishon Vijay Abraham I wrote:
> Fixes
> warning: (OMAP_USB2 && TWL4030_USB) selects USB_PHY which has unmet
> direct dependencies (USB_SUPPORT)
> that shows up while disabling USB_SUPPORT from menuconfig.
[...]
>  config TWL4030_USB
>  	tristate "TWL4030 USB Transceiver Driver"
>  	depends on TWL4030_CORE && REGULATOR_TWL4030 && USB_MUSB_OMAP2PLUS
> +	depends on USB_PHY
>  	select GENERIC_PHY
> -	select USB_PHY
>  	help
>  	  Enable this to support the USB OTG transceiver on TWL4030
>  	  family chips (including the TWL5030 and TPS659x0 devices).

This introduced a minor problem in 3.13-rc5: User is no longer able to
select TWL4030_USB with menuconfig, since there is no menu entry for
enabling USB_PHY. The only way to enable TWL4030_USB is to enable some
other option first that happens to select USB_PHY...

A.
