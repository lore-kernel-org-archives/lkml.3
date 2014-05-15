Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbaEOVQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:16:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42586 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752681AbaEOVQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:16:02 -0400
Date: Thu, 15 May 2014 17:16:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Bresticker <abrestic@chromium.org>
cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH 06/10] usb: xhci: Add Tegra XHCI host-controller
 driver
In-Reply-To: <CAL1qeaHm7U2NVDeVZS-Tiz5ntkk4c13RR_1ws9MTYGGoGCOB5A@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1405151709100.887-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Andrew Bresticker wrote:

> > This does not feel appropriate at all: Rather than creating a child device,
> > you should have a specific driver that hooks into functions exported
> > by the xhci core. See Documentation/driver-model/design-patterns.txt
> 
> This is how DWC3, currently the only in-tree non-PCI XHCI host driver,
> is structured - see drivers/usb/dwc3/host.c.  The recently proposed
> Armada XHCI driver [1] just adds clock support and a hook in
> xhci-plat's probe() to do the platform-specific initialization.
> Tegra's XHCI driver initialization is quite a bit more complicated,
> mainly due to the need for external firmware and specific ordering
> (e.g. firmware messages should only be enabled after the HCD is
> created).  I could do away with the xhci-plat sub-device and just
> create a Tegra hc_driver, but it seems silly to have three XHCI
> platform drivers structured in three different ways.  USB folks, do
> you have an opinion on how this should be done?

Felipe and I have differing opinions.  I prefer not to create an extra 
device level, and he does (that's why the non-PCI EHCI drivers don't do 
it and the dwc3 driver does).  I consider Felipe's approach to be an 
example of the "Midlayer Mistake" anti-pattern from the LWN 
article mentioned earlier in this thread -- I don't know what he thinks 
about my approach.

Anyway, unless I'm totally mistaken, you wouldn't end up with three
platform drivers structured in three different ways.  Either way, your
new driver would be structured like one of the existing two.

Alan Stern

