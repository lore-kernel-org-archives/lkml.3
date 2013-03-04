Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab3CDWMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:12:32 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:53822 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab3CDWM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:12:29 -0500
Date: Mon, 4 Mar 2013 17:12:51 -0500
From: Matt Porter <mporter@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Nori, Sekhar" <nsekhar@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to
 arm/common
Message-ID: <20130304221251.GG6209@beef>
References: <1359742975-10421-1-git-send-email-mporter@ti.com>
 <1359742975-10421-2-git-send-email-mporter@ti.com>
 <511673E1.7000908@ti.com>
 <e92425fefcc04bb4ab739ec8d4e82672@DLEE74.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e92425fefcc04bb4ab739ec8d4e82672@DLEE74.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2013 at 08:08:50PM +0000, Russell King wrote:
> On Sat, Feb 09, 2013 at 09:35:53PM +0530, Sekhar Nori wrote:
> > On 2/1/2013 11:52 PM, Matt Porter wrote:
> > > +	ret = of_address_to_resource(node, 1, &res);
> > 
> > of_address_to_resource() needs <linux/of_address.h>
> > 
> > > +	if (IS_ERR_VALUE(ret))
> > 
> > This needs <linux/err.h>
> 
> More importantly, is this the correct way to check for errors from
> of_address_to_resource() ?  Grepping the source shows that either less
> than 0 or non-zero are the commonly used conditions here.

Yes, it's not correct. Fixed to check for non-zero/zero in the two cases
where of_address_to_resource() is used.

-Matt
