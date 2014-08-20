Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaHTPEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:04:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56554 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbaHTPEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:04:37 -0400
Message-ID: <53F4B8CE.50300@ti.com>
Date: Wed, 20 Aug 2014 20:33:42 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kgene.kim@samsung.com>, <maxime.ripard@free-electrons.com>,
        <linux-samsung-soc@vger.kernel.org>
CC: <patches@linaro.org>, <lee.jones@linaro.org>
Subject: Re: [PATCH 0/9] phy: various misc cleanups to phy drivers
References: <1408106416-19044-1-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1408106416-19044-1-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 15 August 2014 06:10 PM, Peter Griffin wrote:
> Hi,
> 
> This series some a few misc cleanups to the PHY drivers: -
> 
> 1) Use module_platform_driver to register spear PHY drivers. This gets rid
> of a lof of boiler plate code.
> 
> 2) Remove .owner field from drivers using module_platform_driver, as this gets
> overridden anyway in __platform_driver_register.
> 
> 3) Remove OOM site specific failure messages. These are unecessary and make
> the kernel bigger.
> 
> 4) Add missing kzalloc error check, which could avoid NULL ptr dereference.

Thanks for doing this clean-up.
But I can queue this only for 3.18 (since these are cleanups) after -rc4 is tagged.

Thanks
Kishon

> 
> regards,
> 
> Peter.
> 
> Peter Griffin (9):
>   phy: phy-omap-control: Remove unncessary site specific OOM messages
>   phy: phy-mvebu-sata: Add missing error check for devm_kzalloc
>   phy: phy-omap-usb2: Remove unncessary site specific OOM messages
>   phy: phy-ti-pipe3: Remove unncessary site specific OOM messages
>   phy: phy-spear1310-miphy: Remove unncessary site specific OOM messages
>   phy: phy-spear1340-miphy: Remove unncessary site specific OOM messages
>   phy: remove .owner field for drivers using module_platform_driver
>   phy: phy-spear1310-miphy: Use module_platform_driver to register
>     driver.
>   phy: phy-spear1340-miphy: Use module_platform_driver to register
>     driver.
> 
>  drivers/phy/phy-bcm-kona-usb2.c     |  1 -
>  drivers/phy/phy-berlin-sata.c       |  1 -
>  drivers/phy/phy-exynos-dp-video.c   |  1 -
>  drivers/phy/phy-exynos-mipi-video.c |  1 -
>  drivers/phy/phy-exynos5-usbdrd.c    |  1 -
>  drivers/phy/phy-exynos5250-sata.c   |  1 -
>  drivers/phy/phy-hix5hd2-sata.c      |  1 -
>  drivers/phy/phy-miphy365x.c         |  1 -
>  drivers/phy/phy-mvebu-sata.c        |  3 ++-
>  drivers/phy/phy-omap-control.c      |  5 +----
>  drivers/phy/phy-omap-usb2.c         |  9 ++-------
>  drivers/phy/phy-qcom-apq8064-sata.c |  1 -
>  drivers/phy/phy-qcom-ipq806x-sata.c |  1 -
>  drivers/phy/phy-samsung-usb2.c      |  1 -
>  drivers/phy/phy-spear1310-miphy.c   | 17 ++---------------
>  drivers/phy/phy-spear1340-miphy.c   | 17 ++---------------
>  drivers/phy/phy-sun4i-usb.c         |  1 -
>  drivers/phy/phy-ti-pipe3.c          |  6 ++----
>  drivers/phy/phy-twl4030-usb.c       |  1 -
>  drivers/phy/phy-xgene.c             |  1 -
>  20 files changed, 11 insertions(+), 60 deletions(-)
> 
