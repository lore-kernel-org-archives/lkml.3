Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaGJSej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:34:39 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:45235 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaGJSeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:34:37 -0400
MIME-Version: 1.0
In-Reply-To: <1404954350-26343-5-git-send-email-abrestic@chromium.org>
References: <1404954350-26343-1-git-send-email-abrestic@chromium.org>
	<1404954350-26343-5-git-send-email-abrestic@chromium.org>
Date: Thu, 10 Jul 2014 11:34:36 -0700
X-Google-Sender-Auth: EnqeD3uK_CPisjo0Iz4l2glPWrE
Message-ID: <CAODwPW9FORb2jnxFi6US6CUJvJzKyUkT8cuSzkPues41hJe+Jw@mail.gmail.com>
Subject: Re: [PATCH 4/4] xhci: Allow xHCI drivers to be built as separate modules
From: Julius Werner <jwerner@chromium.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Julius Werner <jwerner@chromium.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
> index af89a90..bafba71 100644
> --- a/drivers/usb/host/Makefile
> +++ b/drivers/usb/host/Makefile
> @@ -15,19 +15,19 @@ fhci-$(CONFIG_FHCI_DEBUG) += fhci-dbg.o
>  xhci-hcd-y := xhci.o xhci-mem.o
>  xhci-hcd-y += xhci-ring.o xhci-hub.o xhci-dbg.o
>  xhci-hcd-y += xhci-trace.o
> -xhci-hcd-$(CONFIG_PCI) += xhci-pci.o
>
> -ifneq ($(CONFIG_USB_XHCI_PLATFORM), )
> -       xhci-hcd-y              += xhci-plat.o
> +xhci-plat-hcd-y := xhci-plat.o
>  ifneq ($(CONFIG_USB_XHCI_MVEBU), )
> -       xhci-hcd-y              += xhci-mvebu.o
> -endif

nit: Can do this even simpler now, just
"xhci-plat-hcd-$(CONFIG_USB_XHCI_MVEBU) += xhci-mvebu.o" without the
ifneq.

> +       xhci-plat-hcd-y         += xhci-mvebu.o
>  endif
>
>  obj-$(CONFIG_USB_WHCI_HCD)     += whci/
>
>  obj-$(CONFIG_PCI)              += pci-quirks.o
>
> +obj-$(CONFIG_USB_XHCI_PCI)     += xhci-pci.o
> +obj-$(CONFIG_USB_XHCI_PLATFORM) += xhci-plat-hcd.o
> +
>  obj-$(CONFIG_USB_EHCI_HCD)     += ehci-hcd.o
>  obj-$(CONFIG_USB_EHCI_PCI)     += ehci-pci.o
>  obj-$(CONFIG_USB_EHCI_HCD_PLATFORM)    += ehci-platform.o

Great patch series, thank you!
