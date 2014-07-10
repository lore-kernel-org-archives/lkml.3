Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaGJSXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:23:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42000 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751345AbaGJSXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:23:13 -0400
Date: Thu, 10 Jul 2014 14:23:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Griffin <peter.griffin@linaro.org>
cc: linux-arm-kernel@lists.infradead.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <maxime.coquelin@st.com>, <patrice.chotard@st.com>,
        <gregkh@linuxfoundation.org>, <srinivas.kandagatla@gmail.com>,
        USB list <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lee.jones@linaro.org>
Subject: Re: [PATCH 1/3] usb: host: st-hcd: Add USB HCD support for STi SoCs
In-Reply-To: <1405005486-26355-2-git-send-email-peter.griffin@linaro.org>
Message-ID: <Pine.LNX.4.44L0.1407101154070.1492-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014, Peter Griffin wrote:

> This driver adds support for the USB HCD present in STi
> SoC's from STMicroelectronics. It has been tested on the
> stih416-b2020 board.

This driver file, along with the Kconfig changes, belongs in the
arch/platform-specific source directory.  Not in drivers/usb/host/.  
It is, after all, a platform driver that registers two platform
devices.

> +++ b/drivers/usb/host/Kconfig
> @@ -753,6 +753,23 @@ config USB_HCD_SSB
>  
>  	  If unsure, say N.
>  
> +config USB_HCD_ST
> +	tristate "STMicroelectronics STi family HCD support"

Why does this need to be tristate?  Why not always build it into the 
kernel?  Or at least make it boolean rather than tristate.

> +	depends on ARCH_STI
> +	select USB_OHCI_HCD_PLATFORM if USB_OHCI_HCD
> +	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
> +	select MFD_SYSCON
> +	select GENERIC_PHY
> +	help
> +	  Enable support for the EHCI and OCHI host controller on ST

s/OCHI/OHCI/

> + 	  consumer electronics SoCs.
> +
> + 	  It converts the ST driver into two platform device drivers

It converts the ST driver?  That doesn't sound right at all.  You could 
eliminate this paragraph completely and nobody would miss it.

> + 	  for EHCI and OHCI and provides bus configuration, clock and power
> + 	  management for the combined hardware block.

Alan Stern

