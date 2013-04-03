Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762769Ab3DCR15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:27:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:39149 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939Ab3DCR1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:27:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,402,1363158000"; 
   d="scan'208";a="280304339"
Date: Wed, 3 Apr 2013 10:27:51 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, stern@rowland.harvard.edu,
        rob.herring@calxeda.com, kgene.kim@samsung.com, kishon@ti.com,
        dianders@chromium.org, t.figa@samsung.com, p.paneri@samsung.com
Subject: Re: [PATCH v3 00/11] usb: dwc3/xhci/phy: Enable runtime power
 management
Message-ID: <20130403172751.GC10089@xanatos>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Question: Do you still need this patch for 3.10?

http://marc.info/?l=linux-usb&m=136057666911621&w=2

Does this patchset build on top of that?

I'm really behind on my patches for 3.10, sorry.

Sarah Sharp

On Mon, Apr 01, 2013 at 07:23:59PM +0530, Vivek Gautam wrote:
> This patch-series enables runtime power management on xhci-plat,
> dwc3-core, dwc3-exynos as well as on Samsung's USB 2.0 type and
> USB 3.0 type PHYs.
> 
> Based on 'next' branch of Felipe Balbi's USB tree.
> 
> Changes from v2:
>  - Using separate functions for USB PHY runtime power management, instead of
>    using macros.
>  - Adding 'pm_runtime_set_suspended()' api call in dwc3 core layer before
>    enabling runtime pm. (Ideally, we should be explicitly make device
>    'suspended' or 'active' before enabling runtime pm on it).
>  - Checking return code for 'put_sync' and 'get_sync' of USB-PHYs when
>    waking up or suspending them from dwc3 core's runtime_pm callbacks.
>  - Removed buggy pm_runtime_put() calls from driver's (xhci, dwc3 and PHY)
>    remove functions.
>  - Adding a patch to enable runtime power management of Samsung's USB 2.0 PHY
>    (usb: phy: samsung: Enable runtime power management on usb2phy)
> 
> Changes from v1:
>  - Adding required PHY APIs to handle runtime power management
>    instead of directly twiddling with phy->dev.
>  - Handling runtime power management of usb PHYs in dwc3 core
>    driver instead of in any glue layer.
>  - Splitting the patch:
>    [PATCH 4/4] usb: phy: samsung: Enable runtime power management on samsung-usb
>    into required number to bifurcate functionality.
> 
> Vivek Gautam (11):
>   usb: phy: Add APIs for runtime power management
>   USB: dwc3: Adjust runtime pm to allow autosuspend
>   usb: dwc3: Enable runtime pm only after PHYs are initialized
>   usb: dwc3: Add runtime power management callbacks
>   usb: dwc3: exynos: Enable runtime power management
>   usb: xhci: Enable runtime pm in xhci-plat
>   usb: phy: samsung: Enable runtime power management on usb2phy
>   usb: phy: samsung: Enable runtime power management on usb3phy
>   usb: phy: samsung: Add support for external reference clock
>   usb: phy: samsung: Add support for PHY ref_clk gpio
>   usb: phy: samsung: Add support for PHY refclk switching
> 
>  drivers/usb/dwc3/core.c            |   59 ++++++++++++++--
>  drivers/usb/dwc3/dwc3-exynos.c     |   12 +++
>  drivers/usb/host/xhci-plat.c       |    6 ++
>  drivers/usb/phy/phy-samsung-usb.c  |   26 +++++++
>  drivers/usb/phy/phy-samsung-usb.h  |    1 +
>  drivers/usb/phy/phy-samsung-usb2.c |    5 ++
>  drivers/usb/phy/phy-samsung-usb3.c |  119 +++++++++++++++++++++++++++++--
>  include/linux/usb/phy.h            |  141 ++++++++++++++++++++++++++++++++++++
>  8 files changed, 358 insertions(+), 11 deletions(-)
> 
> -- 
> 1.7.6.5
> 
