Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab3AUGpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 01:45:14 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:47814 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab3AUGpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 01:45:12 -0500
MIME-Version: 1.0
In-Reply-To: <1358168377-22919-1-git-send-email-gautam.vivek@samsung.com>
References: <1358168377-22919-1-git-send-email-gautam.vivek@samsung.com>
Date: Mon, 21 Jan 2013 12:15:10 +0530
Message-ID: <CAFp+6iHbvwTBUSZO2EvCaeCT=g=UzubLGrmPHjKUgi9Ef7enzQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Adding USB 3.0 DRD-phy support for exynos5250
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, kgene.kim@samsung.com, p.paneri@samsung.com,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        sylvester.nawrocki@gmail.com, av.tikhomirov@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Doug Anderson <dianders@chromium.org>, kishon <kishon@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,


On Mon, Jan 14, 2013 at 6:29 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Changes from v2:
>  - Renaming 'samsung-usbphy.c' driver to 'samsung-usb2.c' indicating
>    usb 2.0 phy controller's driver for Samsung's SoCs.
>  - Moving the register definitions and strcuture definitions to
>    common header file 'samsung-usbphy.h' to be used across
>    usb 2.0 and usb 3.0 phy.
>  - Keeping common exported function definitions in samsung-usbphy.c
>    which can be used across usb 2.0 and usb 3.0 phy.
>  - Writting separate driver file for Samsung's USB 3.0 phy controller.
>    and making it dependent on USB_DWC3.
>

Is the re-organization being done here fine as per requirements for
separate drivers for usb 2.0 type PHY and usb 3.0 type PHY ?

> Rebased on top of usb-next followed by following patches/patch-threads:
>         -- [PATCH v9 1/2] usb: phy: samsung: Introducing usb phy driver for hsotg
>         -- [PATCH] usb: phy: samsung: Add support to set pmu isolation (version 6)
>         -- [PATCH v6 0/4] Adding usb2.0 host-phy support for exynos5250
>
> Changes form v1:
>  - Moved architecture related patch out of this patch-set.
>  - Replaced unnecessary multi-line macro definitions by
>    single line definitions.
>  - Creating new data structure for USB 3.0 phy type and embedding
>    it in 'samsung_usbphy' structure.
>  - Adding a flag in 'samsung_usbphy' structure to check if device
>    has usb 3.0 type phy or not.
>  - Restructuring probe sequence for USB 3.0 phy, such that we are
>    initializing only when device has usb3.0 type phy.
>
> Vivek Gautam (2):
>   usb: phy: samsung: Common out the generic stuff
>   usb: phy: samsung: Add PHY support for USB 3.0 controller
>
>  drivers/usb/phy/Kconfig          |    8 +
>  drivers/usb/phy/Makefile         |    3 +-
>  drivers/usb/phy/samsung-usb2.c   |  511 +++++++++++++++++++++++++++
>  drivers/usb/phy/samsung-usb3.c   |  349 +++++++++++++++++++
>  drivers/usb/phy/samsung-usbphy.c |  713 +-------------------------------------
>  drivers/usb/phy/samsung-usbphy.h |  328 +++++++++++++++++
>  6 files changed, 1205 insertions(+), 707 deletions(-)
>  create mode 100644 drivers/usb/phy/samsung-usb2.c
>  create mode 100644 drivers/usb/phy/samsung-usb3.c
>  create mode 100644 drivers/usb/phy/samsung-usbphy.h
>



-- 
Thanks & Regards
Vivek
