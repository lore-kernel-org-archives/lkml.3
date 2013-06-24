Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab3FXVKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 17:10:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48398 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065Ab3FXVKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 17:10:51 -0400
From: "Fernandes, Joel A" <joelagnel@ti.com>
To: Arnd Bergmann <arnd@arndb.de>, Joel A Fernandes <agnel.joel@gmail.com>
CC: "Nori, Sekhar" <nsekhar@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Matt Porter" <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Rob Herring" <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        "Devicetree Discuss" <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Subject: RE: [PATCH v12 05/11] edma: config: Enable config options for EDMA
Thread-Topic: [PATCH v12 05/11] edma: config: Enable config options for EDMA
Thread-Index: AQHObfoZdlSH5JEXIkOVso7HMXcpAplASIaAgAA8ZgCAAAIzAIAABZOAgAADZwCAAEV1AIAAAQQAgAA09ICAAAWtAIAATfYAgARLc4CAAAEQgIAACeSA//+sj6A=
Date: Mon, 24 Jun 2013 21:09:58 +0000
Message-ID: <083BC63EECB6FD41B8E81CF7FD87CC0F2E4EE5A1@DLEE08.ent.ti.com>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
 <201306242228.23297.arnd@arndb.de>
 <CAD=GYpYwswOYGHRzZ6SeKD+sEfi-7s3HuqKr7G0OXQWFCA_EtQ@mail.gmail.com>
 <201306242307.35840.arnd@arndb.de>
In-Reply-To: <201306242307.35840.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Monday, June 24, 2013 4:08 PM
> To: Joel A Fernandes
> Cc: Nori, Sekhar; Fernandes, Joel A; Tony Lindgren; Matt Porter; Grant Likely;
> Rob Herring; Vinod Koul; Mark Brown; Cousson, Benoit; Russell King; Rob
> Landley; Andrew Morton; Jason Kridner; Koen Kooi; Devicetree Discuss; Linux
> OMAP List; Linux ARM Kernel List; Linux DaVinci Kernel List; Linux Kernel
> Mailing List; Linux Documentation List; Linux MMC List; Linux SPI Devel List
> Subject: Re: [PATCH v12 05/11] edma: config: Enable config options for EDMA
> 
> On Monday 24 June 2013, Joel A Fernandes wrote:
> > >> Yes sure, right now they are defined  as follows in include/linux/edma.h:
> > >>
> > >> #if defined(CONFIG_TI_EDMA) || defined(CONFIG_TI_EDMA_MODULE)
> bool
> > >> edma_filter_fn(struct dma_chan *, void *); #else static inline bool
> > >> edma_filter_fn(struct dma_chan *chan, void *param) { return false;
> > >> } #endif
> > >
> > > It's best to just define the filter function in the platform code
> > > and pass a pointer to it through platform data. The way you do it
> > > above makes the slave drivers inherently nonportable.
> >
> > But with DT-only platforms, can you really do that?
> 
> The nice thing about this is that with a DT-only platform, the filter function will
> automatically go away: you have no platform_data, which means that if you
> are using dma_request_slave_channel_compat, you just pass NULL as the filter
> and the filter-data, same as just calling dma_request_slave_channel.
> 
 
[Joel] Ah yes! Thanks for that. Right, edma_filter_fn is not passed explicitly for DT case.

Thanks,
Joel
