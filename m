Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbaGPI7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:59:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33029 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933679AbaGPI72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:59:28 -0400
Date: Wed, 16 Jul 2014 10:59:24 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com,
        balbi@ti.com, p.zabel@pengutronix.de,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v3 08/12] Documentation: bindings: add doc for the USB2
 ChipIdea USB driver
Message-ID: <20140716085924.GA28151@kwain>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com>
 <1405499166-6726-9-git-send-email-antoine.tenart@free-electrons.com>
 <23972141.94aiK9jz66@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <23972141.94aiK9jz66@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wed, Jul 16, 2014 at 10:39:36AM +0200, Arnd Bergmann wrote:
> On Wednesday 16 July 2014 10:26:02 Antoine Ténart wrote:
> > +
> > +Required properties:
> > +- compatible: should be "chipidea,usb2"
> > +- reg: base address and length of the registers
> > +- interrupts: interrupt for the USB controller
> > +
> > +Optional properties:
> > +- clocks: reference to the USB clock
> > +- usb-phy: reference to the USB PHY
> 
> I think the phy reference should use the standard phy binding, using
> "phys" property to refer to a node that has a "#phy-cells" property.
> 
> It seems the code gets this right, but just the documentation is wrong.

I moved this PHY driver from usb/phy/ to phy/ and forgot to update this
property. I'll fix it.

> 
> > +- vbus-supply: reference to the VBUS regulator
> > +- dma-mask: DMA bit mask
> 
> No. Do not use "dma-mask" as a property, that is a pure Linux specific
> concept. The DT way to express this is to use the 'dma-ranges' property
> in the device's parent to describe any bus-related restrictions, and
> for the driver to ask for a mask that matches what the hardware is
> capable of (which may be smaller or larger than what the bus supports).

Ok. I'll answer in the CI driver's thread.

Thanks!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
