Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab3FXVHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 17:07:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50581 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab3FXVHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 17:07:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Joel A Fernandes <agnel.joel@gmail.com>
Subject: Re: [PATCH v12 05/11] edma: config: Enable config options for EDMA
Date: Mon, 24 Jun 2013 23:07:35 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sekhar Nori <nsekhar@ti.com>, Joel A Fernandes <joelagnel@ti.com>,
        Tony Lindgren <tony@atomide.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com> <201306242228.23297.arnd@arndb.de> <CAD=GYpYwswOYGHRzZ6SeKD+sEfi-7s3HuqKr7G0OXQWFCA_EtQ@mail.gmail.com>
In-Reply-To: <CAD=GYpYwswOYGHRzZ6SeKD+sEfi-7s3HuqKr7G0OXQWFCA_EtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306242307.35840.arnd@arndb.de>
X-Provags-ID: V02:K0:5ReKlA9Vl6Z5wLLyxxS4hcXqfFe7uoLCM23HgYQTKDi
 YKldwH6rRnw5XnTfGEw7a4SnuRFNobckj9/ZwWnyYvWEpFRijJ
 Naylzz2ZzXnmyy/VEWTSo+9h8Px+H7schnsokuFp2BmtLUsweg
 Hgv9C+Ud0fUv1I8iQmU4LMuxosBwz5Ui8JoZH3Cg1jJGMuPtco
 9RemIZQsJVNnGJ/DYUGG6VTIOHYsGPp9tPjD2Y9wpRq3j58cmN
 FYO1bmubTic2pg+Gcis2KdZHujDdDBfuUbSPltzcp6MzxEBGf4
 hAAPOxbyr7QBHLkcge8R68KSfdKU9xAqgBc884ZHSyp2DzI96T
 5eEI/6HjftYQpLNib2kA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 June 2013, Joel A Fernandes wrote:
> >> Yes sure, right now they are defined  as follows in include/linux/edma.h:
> >>
> >> #if defined(CONFIG_TI_EDMA) || defined(CONFIG_TI_EDMA_MODULE)
> >> bool edma_filter_fn(struct dma_chan *, void *);
> >> #else
> >> static inline bool edma_filter_fn(struct dma_chan *chan, void *param)
> >> {
> >> return false;
> >> }
> >> #endif
> >
> > It's best to just define the filter function in the platform
> > code and pass a pointer to it through platform data. The way you do
> > it above makes the slave drivers inherently nonportable.
> 
> But with DT-only platforms, can you really do that?

The nice thing about this is that with a DT-only platform, the
filter function will automatically go away: you have no
platform_data, which means that if you are using
dma_request_slave_channel_compat, you just pass NULL as the
filter and the filter-data, same as just calling
dma_request_slave_channel.

	Arnd
