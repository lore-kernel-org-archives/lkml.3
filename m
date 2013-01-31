Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab3AaU6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 15:58:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59086 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3AaU6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 15:58:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matt Porter <mporter@ti.com>
Subject: Re: [PATCH v6 03/10] ARM: edma: add AM33XX support to the private EDMA API
Date: Thu, 31 Jan 2013 20:58:39 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
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
References: <1359529229-22207-1-git-send-email-mporter@ti.com> <201301300932.58732.arnd@arndb.de> <20130131183255.GI2244@beef>
In-Reply-To: <20130131183255.GI2244@beef>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301312058.39948.arnd@arndb.de>
X-Provags-ID: V02:K0:3knhGsYIg5Qz5cyuAGkcNqrAhQFCLEHR0QR5OlyZem6
 XSVD5Zsor6ytht7ZIrO7lDigtredYDC91G/fJLOF7DiLKbzse2
 c7jtPVK6lCsHIAHB++kMt5FhTL5pEvtPcs9iy53aUBkL6FXfyb
 +j/tzrgJWce1qvzSPWWgx1NgO8vn+i/BblpZVfKYsaA0enqbew
 K1p/HVZvfIITmBulcKNQfyzBHWNUFIylA5CkNNCN/z83n3j/Tl
 gbWsO6kBSs8gpc5iRBHpMx0F8UgdGyNgcfzrjSQCl/D9NU9ynU
 pOn6jv/1MAm/V1pGKCzWIWN5paZEBqyYfYlPEXGWlfjBIDPQs9
 qYZ2jrApVPQ8zcfRH8g8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2013, Matt Porter wrote:
> On Wed, Jan 30, 2013 at 09:32:58AM +0000, Arnd Bergmann wrote:
> > On Wednesday 30 January 2013, Matt Porter wrote:
> > > +               dma_cap_set(DMA_SLAVE, edma_filter_info.dma_cap);
> > > +               of_dma_controller_register(dev->of_node,
> > > +                                          of_dma_simple_xlate,
> > > +                                          &edma_filter_info);
> > > +       }
> > 
> > How do you actually deal with the problem mentioned by Padma, that
> > the filter function does not know which edma instance it is looking
> > at? If you assume that there can only be a single edma instance in
> > the system, that is probably a limitation that should be documented
> > somewhere, and ideally the probe() function should check for that.
> 
> I make an assumption of one edma instance in the system in the case of
> DT being populated. This is always true right now as the only SoC with
> two EDMA controllers in existence is Davinci DA850. Until recently,
> Davinci had no DT support. Given the steady work being done today on DT
> support for DA850, it'll probably be something needed in 3.10.
> 
> I will add a comment and check in probe() to capture this assumption
> and then plan to update separately to support DA850 booting from DT.

Ok, sounds good. Hopefully by then we will already have a nicer
way to write an xlate function that does not rely on a filter
function.

	Arnd
