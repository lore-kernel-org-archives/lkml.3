Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3DOM0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 08:26:42 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42450 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab3DOM0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 08:26:40 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 0/6] Generic PHY Framework
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-usb@vger.kernel.org, mchehab@redhat.com, linux-doc@vger.kernel.org,
        tony@atomide.com, linux@arm.linux.org.uk, javier@dowhile0.org,
        cesarb@cesarb.net, arnd@arndb.de, eballetbo@gmail.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        swarren@nvidia.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, b-cousson@ti.com,
        gregkh@linuxfoundation.org, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, balbi@ti.com, santosh.shilimkar@ti.com,
        rob@landley.net, akpm@linux-foundation.org, davem@davemloft.net
In-Reply-To: <516BD835.8060007@ti.com>
References: <1363770725-13717-1-git-send-email-kishon@ti.com> <20130415102009.D358E3E0AA8@localhost> <516BD835.8060007@ti.com>
Date: Mon, 15 Apr 2013 13:26:34 +0100
Message-Id: <20130415122634.3A08A3E0AA8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013 16:06:37 +0530, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
> 
> On Monday 15 April 2013 03:50 PM, Grant Likely wrote:
> > On Wed, 20 Mar 2013 14:41:59 +0530, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> >> Added a generic PHY framework that provides a set of APIs for the PHY drivers
> >> to create/destroy a PHY and APIs for the PHY users to obtain a reference to
> >> the PHY with or without using phandle. To obtain a reference to the PHY
> >> without using phandle, the platform specfic intialization code (say from board
> >> file) should have already called phy_bind with the binding information. The
> >> binding information consists of phy's device name, phy user device name and an
> >> index. The index is used when the same phy user binds to mulitple phys.
> >>
> >> This framework will be of use only to devices that uses external PHY (PHY
> >> functionality is not embedded within the controller).
> >>
> >> The intention of creating this framework is to bring the phy drivers spread
> >> all over the Linux kernel to drivers/phy to increase code re-use and to
> >> increase code maintainability.
> >>
> >> Comments to make PHY as bus wasn't done because PHY devices can be part of
> >> other bus and making a same device attached to multiple bus leads to bad
> >> design.
> >>
> >> Making omap-usb2 and twl4030 to use this framework is provided as a sample.
> >>
> >> This patch series is developed on 3.9-rc3. Once the patch series gets finalised
> >> I'll resend omap-usb2 and twl4030 part based on Felipe's tree.
> >>
> >
> > [...]
> >
> >>   drivers/Kconfig                                    |    2 +
> >>   drivers/Makefile                                   |    2 +
> >>   drivers/phy/Kconfig                                |   13 +
> >>   drivers/phy/Makefile                               |    5 +
> >>   drivers/phy/phy-core.c                             |  574 ++++++++++++++++++++
> >
> > This looks to be very specific for USB PHYs. Are you intending it to be
> > used for other types of PHYs, like Ethernet PHYs? If not, then this
> 
> Not really. This can be used by USB, SATA and Sylwester was planning to 
> use it for video PHY's.

So what are the common bits that are shared between those phys? Merely
matching phys to controllers? Besides that, each of those devices have
very different behaviour. You wouldn't be able to attach any interface
logic to the generic struct phy. I don't think it makes a whole lot of
sense to lump them all into the same type of registration.

g.
