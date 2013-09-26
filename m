Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab3IZSv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:51:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252Ab3IZSvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:52 -0400
Date: Thu, 26 Sep 2013 11:51:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: kyungmin.park@samsung.com, balbi@ti.com, jg1.han@samsung.com,
        s.nawrocki@samsung.com, kgene.kim@samsung.com,
        stern@rowland.harvard.edu, broonie@kernel.org, tomasz.figa@gmail.com,
        arnd@arndb.de, grant.likely@linaro.org, tony@atomide.com,
        swarren@nvidia.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com,
        linux@arm.linux.org.uk
Subject: Re: [PATCH v11 2/8] usb: phy: omap-usb2: use the new generic PHY
 framework
Message-ID: <20130926185151.GA8689@kroah.com>
References: <1377063973-22044-1-git-send-email-kishon@ti.com>
 <1377063973-22044-3-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377063973-22044-3-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 11:16:07AM +0530, Kishon Vijay Abraham I wrote:
> Used the generic PHY framework API to create the PHY. Now the power off and
> power on are done in omap_usb_power_off and omap_usb_power_on respectively.
> The omap-usb2 driver is also moved to driver/phy.
> 
> However using the old USB PHY library cannot be completely removed
> because OTG is intertwined with PHY and moving to the new framework
> will break OTG. Once we have a separate OTG state machine, we
> can get rid of the USB PHY library.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/phy/Kconfig                   |   12 +++++++++
>  drivers/phy/Makefile                  |    1 +
>  drivers/{usb => }/phy/phy-omap-usb2.c |   45 ++++++++++++++++++++++++++++++---
>  drivers/usb/phy/Kconfig               |   10 --------
>  drivers/usb/phy/Makefile              |    1 -
>  5 files changed, 54 insertions(+), 15 deletions(-)
>  rename drivers/{usb => }/phy/phy-omap-usb2.c (88%)

I tried to apply this to my USB branch, but it fails.

Kishon, you were going to refresh this patch series, right?  Please do,
because as-is, I can't take it.

thanks,

greg k-h
