Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaBXQrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:47:12 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:53098 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaBXQrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:47:10 -0500
MIME-Version: 1.0
In-Reply-To: <1393259343-825-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1393259343-825-1-git-send-email-mathias.nyman@linux.intel.com>
Date: Mon, 24 Feb 2014 08:47:09 -0800
Message-ID: <CAPcyv4gkdC=fM5-qURK5R=_BmTBACchtFxvYE_WHtZqqMukFJA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] xhci: Prevent runtime pm from autosuspending
 during initialization
From: Dan Williams <dan.j.williams@intel.com>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: USB list <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        david.a.cohen@linux.intel.com,
        Jianqiang Tang <jianqiang.tang@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 8:29 AM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:
> xHCI driver has its own pci probe function that will call usb_hcd_pci_probe
> to register its usb-2 bus, and then continue to manually register the
> usb-3 bus. usb_hcd_pci_probe does a pm_runtime_put_noidle at the end and
> might thus trigger a runtime suspend before the usb-3 bus is ready.
>
> Prevent the runtime suspend by increasing the usage count in the
> beginning of xhci_pci_probe, and decrease it once the usb-3 bus is
> ready.
>
> xhci-platform driver is not using usb_hcd_pci_probe to set up
> busses and should not need to have it's usage count increased during probe.
>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>
