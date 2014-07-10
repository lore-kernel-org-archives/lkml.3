Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaGJKmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:42:47 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:52888 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaGJKmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:42:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v1 6/9] usb: xhci: Add NVIDIA Tegra XHCI host-controller driver
Date: Thu, 10 Jul 2014 12:40:56 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Julius Werner <jwerner@chromium.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
References: <Pine.LNX.4.44L0.1407091001150.873-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1407091001150.873-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201407101240.56828.arnd@arndb.de>
X-Provags-ID: V02:K0:1UCpJ9E6QzSnrEtPdsmwThsG5Tgu1TSXh7WY3KN4wSR
 SjlbEBX4fnDnpsUhFbmS0vKNEw7hSmz68NoLjFGbp3SjXkIjIO
 1GVDU7sacZqRlXh12tUt3E1vtu7eFp90zSAK++ROgPyjXdBPGq
 D7WbIzph2uzcozNBHcGX1cofhweQEv1Y4KqpzphtwuCwDae2sY
 uOR6UuANNAZ3H5RE8U6KlXYSR0aM+FsoRp8yI3jb8WNZqxzmFi
 aciKXCOm6IkQ79iZaTnH6stapuFU+vK+guMoe2I6LocO6x0/iM
 b5h231HuM/YcE/+yUitl+pJt85Ftz2X8LH5uYZ1Tca4w2olkVh
 TZl6uVABAerKJySTQsVQd+Z+Uxmv8a+lHyQQy2uNA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2014, Alan Stern wrote:
> On Tue, 8 Jul 2014, Andrew Bresticker wrote:
> 
> > > I think at the very least you should add a function
> > > "xhci_default_driver(struct hc_driver *driver)" to xhci-plat.c (or
> > > even better to xhci.c and use it for PCI as well) that initializes all
> > > function pointers to the default (internal) symbols, and can then be
> > > overridden afterwards.
> > 
> > Currently all XHCI host drivers (PCI, platform, MVEBU) will be built
> > into the xhci-hcd module.  I could append the Tegra driver to that
> > module or introduce a xhci_init_driver() like EHCI does as Julius
> > suggests.  USB folks, do you have a preference?
> 
> As the EHCI maintainer, I naturally approve of Julius's suggestion.  

I'm not a USB maintainer, but I also agree that's the best way forward,
since it's similar to what all other similar drivers in the kernel do.

	Arnd
