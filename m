Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab3DOKUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:20:18 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:36898 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934682Ab3DOKUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:20:15 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 0/6] Generic PHY Framework
To: Kishon Vijay Abraham I <kishon@ti.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, arnd@arndb.de, akpm@linux-foundation.org,
        rob@landley.net
Cc: davem@davemloft.net, cesarb@cesarb.net, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, rob.herring@calxeda.com, b-cousson@ti.com,
        linux@arm.linux.org.uk, eballetbo@gmail.com, javier@dowhile0.org,
        kishon@ti.com, mchehab@redhat.com, santosh.shilimkar@ti.com,
        broonie@opensource.wolfsonmicro.com, swarren@nvidia.com,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1363770725-13717-1-git-send-email-kishon@ti.com>
References: <1363770725-13717-1-git-send-email-kishon@ti.com>
Date: Mon, 15 Apr 2013 11:20:09 +0100
Message-Id: <20130415102009.D358E3E0AA8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Mar 2013 14:41:59 +0530, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Added a generic PHY framework that provides a set of APIs for the PHY drivers
> to create/destroy a PHY and APIs for the PHY users to obtain a reference to
> the PHY with or without using phandle. To obtain a reference to the PHY
> without using phandle, the platform specfic intialization code (say from board
> file) should have already called phy_bind with the binding information. The
> binding information consists of phy's device name, phy user device name and an
> index. The index is used when the same phy user binds to mulitple phys.
> 
> This framework will be of use only to devices that uses external PHY (PHY
> functionality is not embedded within the controller).
> 
> The intention of creating this framework is to bring the phy drivers spread
> all over the Linux kernel to drivers/phy to increase code re-use and to
> increase code maintainability.
> 
> Comments to make PHY as bus wasn't done because PHY devices can be part of
> other bus and making a same device attached to multiple bus leads to bad
> design.
> 
> Making omap-usb2 and twl4030 to use this framework is provided as a sample.
> 
> This patch series is developed on 3.9-rc3. Once the patch series gets finalised
> I'll resend omap-usb2 and twl4030 part based on Felipe's tree.
> 

[...]

>  drivers/Kconfig                                    |    2 +
>  drivers/Makefile                                   |    2 +
>  drivers/phy/Kconfig                                |   13 +
>  drivers/phy/Makefile                               |    5 +
>  drivers/phy/phy-core.c                             |  574 ++++++++++++++++++++

This looks to be very specific for USB PHYs. Are you intending it to be
used for other types of PHYs, like Ethernet PHYs? If not, then this
infrastruction should be named something like usb-phy so that it isn't
confused with other layers, and it really should live under drivers/usb.

g.

