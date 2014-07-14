Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbaGNShB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:37:01 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:33720 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbaGNSgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:36:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAL1qeaGCLw0LSE_Oy_VteAyWLHS9D4y-U8+6Mu+cGKEUp3T3GQ@mail.gmail.com>
References: <1404954350-26343-1-git-send-email-abrestic@chromium.org>
	<1404954350-26343-5-git-send-email-abrestic@chromium.org>
	<CAODwPW9FORb2jnxFi6US6CUJvJzKyUkT8cuSzkPues41hJe+Jw@mail.gmail.com>
	<CAL1qeaGCLw0LSE_Oy_VteAyWLHS9D4y-U8+6Mu+cGKEUp3T3GQ@mail.gmail.com>
Date: Mon, 14 Jul 2014 11:36:51 -0700
X-Google-Sender-Auth: rv8af33A_VGk86Mo9InhIvfnaBA
Message-ID: <CAODwPW_=aoCB3K_cFvEKvztNjo=qHXCwmY4mwXMXRaJ+gzSogw@mail.gmail.com>
Subject: Re: [PATCH 4/4] xhci: Allow xHCI drivers to be built as separate modules
From: Julius Werner <jwerner@chromium.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Nope - since CONFIG_USB_XHCI_MVEBU can be 'y' or 'm' we need the ifneq
> here (which matches against both) to ensure xhci-mvebu.o is built is
> part of xhci-plat-hcd.o.

Oh... does it make sense to have it tristate at all, then? Looks like
was never really buildable as an independent module (and still won't
be after this patch), so I bet that was just a mistake when the
Kconfig for it was first written that should be fixed. (Ideally,
xhci-plat.c should probably go away in favor of dwc3/host.c and
xhci-mvebu.c implementing the wrapper to xhci_init_driver() directly,
but that is a longer-term goal.)
