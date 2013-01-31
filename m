Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3AaScZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:32:25 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:52794 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3AaScX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:32:23 -0500
Date: Thu, 31 Jan 2013 13:32:55 -0500
From: Matt Porter <mporter@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>, Padma Venkat <padma.kvr@gmail.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 03/10] ARM: edma: add AM33XX support to the private
 EDMA API
Message-ID: <20130131183255.GI2244@beef>
References: <1359529229-22207-1-git-send-email-mporter@ti.com>
 <1359529229-22207-4-git-send-email-mporter@ti.com>
 <201301300932.58732.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301300932.58732.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 09:32:58AM +0000, Arnd Bergmann wrote:
> On Wednesday 30 January 2013, Matt Porter wrote:
> > +               dma_cap_set(DMA_SLAVE, edma_filter_info.dma_cap);
> > +               of_dma_controller_register(dev->of_node,
> > +                                          of_dma_simple_xlate,
> > +                                          &edma_filter_info);
> > +       }
> 
> How do you actually deal with the problem mentioned by Padma, that
> the filter function does not know which edma instance it is looking
> at? If you assume that there can only be a single edma instance in
> the system, that is probably a limitation that should be documented
> somewhere, and ideally the probe() function should check for that.

I make an assumption of one edma instance in the system in the case of
DT being populated. This is always true right now as the only SoC with
two EDMA controllers in existence is Davinci DA850. Until recently,
Davinci had no DT support. Given the steady work being done today on DT
support for DA850, it'll probably be something needed in 3.10.

I will add a comment and check in probe() to capture this assumption
and then plan to update separately to support DA850 booting from DT.

-Matt
