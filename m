Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbaGNSur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:50:47 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:38276 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbaGNSul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:50:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAODwPW_=aoCB3K_cFvEKvztNjo=qHXCwmY4mwXMXRaJ+gzSogw@mail.gmail.com>
References: <1404954350-26343-1-git-send-email-abrestic@chromium.org>
	<1404954350-26343-5-git-send-email-abrestic@chromium.org>
	<CAODwPW9FORb2jnxFi6US6CUJvJzKyUkT8cuSzkPues41hJe+Jw@mail.gmail.com>
	<CAL1qeaGCLw0LSE_Oy_VteAyWLHS9D4y-U8+6Mu+cGKEUp3T3GQ@mail.gmail.com>
	<CAODwPW_=aoCB3K_cFvEKvztNjo=qHXCwmY4mwXMXRaJ+gzSogw@mail.gmail.com>
Date: Mon, 14 Jul 2014 11:50:40 -0700
X-Google-Sender-Auth: DUppMxR9odmJuAZ8l74-dsHhHiM
Message-ID: <CAL1qeaFRuw9wn+uAMEJk9bkMKnSivsG02zMda1+iK0kknBNr=g@mail.gmail.com>
Subject: Re: [PATCH 4/4] xhci: Allow xHCI drivers to be built as separate modules
From: Andrew Bresticker <abrestic@chromium.org>
To: Julius Werner <jwerner@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        gregory.clement@free-electrons.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Gregory

On Mon, Jul 14, 2014 at 11:36 AM, Julius Werner <jwerner@chromium.org> wrote:
>> Nope - since CONFIG_USB_XHCI_MVEBU can be 'y' or 'm' we need the ifneq
>> here (which matches against both) to ensure xhci-mvebu.o is built is
>> part of xhci-plat-hcd.o.
>
> Oh... does it make sense to have it tristate at all, then? Looks like
> was never really buildable as an independent module (and still won't
> be after this patch), so I bet that was just a mistake when the
> Kconfig for it was first written that should be fixed.

Making it a bool wouldn't really be accurate either since it could
still be built as part of the xhci-plat-hcd loadable module.  Gregory,
do you have a preference?  I could also re-spin making xhci-mvebu and
independently-loadable module.

> (Ideally, xhci-plat.c should probably go away in favor of dwc3/host.c
> and xhci-mvebu.c implementing the wrapper to xhci_init_driver()
> directly, but that is a longer-term goal.)

Well I don't think xhci-plat can ever go away (it's possible that
there are XHCI platform devices that need no extra platform-specific
setup), but yes, I agree that dwc3 and xhci-mvebu should be converted
over to use xhci_init_driver().
