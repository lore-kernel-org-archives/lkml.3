Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3AQPPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:15:24 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:32829 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756745Ab3AQPPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:15:22 -0500
Date: Thu, 17 Jan 2013 10:15:21 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Venu Byravarasu <vbyravarasu@nvidia.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] usb: Add APIs to access host registers from Tegra
 PHY
In-Reply-To: <1358411292-12288-1-git-send-email-vbyravarasu@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1301171012500.1339-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013, Venu Byravarasu wrote:

> As Tegra PHY driver need to access one of the Host registers,
> added few APIs to ehci tegra driver.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
> delta from v1:
> Taken care of RWC bits, while accessing PORTSC register.
> 
>  drivers/usb/host/ehci-tegra.c     |   70 ++++++++++++++++++++++++++++++++++++-
>  drivers/usb/phy/tegra_usb_phy.c   |   51 +++++++--------------------
>  include/linux/usb/tegra_usb_phy.h |    6 +++
>  3 files changed, 88 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index 55a9cde..6bbf66a 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
> @@ -2,7 +2,7 @@
>   * EHCI-compliant USB host controller driver for NVIDIA Tegra SoCs
>   *
>   * Copyright (C) 2010 Google, Inc.
> - * Copyright (C) 2009 NVIDIA Corporation
> + * Copyright (C) 2009 - 2013 NVIDIA Corporation
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of the GNU General Public License as published by the
> @@ -33,6 +33,16 @@
>  #define TEGRA_USB2_BASE			0xC5004000
>  #define TEGRA_USB3_BASE			0xC5008000
>  
> +/* PORTSC registers */
> +#define USB_PORTSC1			0x184
> +#define USB_PORTSC1_PTS(x)	(((x) & 0x3) << 30)
> +#define USB_PORTSC1_PHCD	(1 << 23)
> +#define USB_PORTSC1_WKOC	(1 << 22)
> +#define USB_PORTSC1_WKDS	(1 << 21)
> +#define USB_PORTSC1_WKCN	(1 << 20)
> +#define USB_PORTSC1_PEC		(1 << 3)
> +#define USB_PORTSC1_CSC		(1 << 1)

Why redefine these values when they are already defined in 
include/linux/usb/ehci_defs.h?

> @@ -605,6 +615,53 @@ static const struct dev_pm_ops tegra_ehci_pm_ops = {
>  
>  #endif
>  
> +/* Bits of PORTSC1, which will get cleared by writing 1 into them */
> +#define TEGRA_PORTSC_RWC_BITS (USB_PORTSC1_CSC | USB_PORTSC1_PEC)

Likewise for this.  Not to mention that you forgot to include the 
overcurrent-change bit.

Alan Stern

