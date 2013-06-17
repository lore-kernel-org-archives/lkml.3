Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab3FQMRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:17:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59768 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727Ab3FQMRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:17:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Joel A Fernandes <joelagnel@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
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
Subject: Re: [PATCH v10 5/8] dmaengine: edma: Add TI EDMA device tree binding
Date: Mon, 17 Jun 2013 13:12:32 +0200
Message-ID: <3940138.jZFEtfGGLz@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1371263570-9323-5-git-send-email-joelagnel@ti.com>
References: <1371263570-9323-1-git-send-email-joelagnel@ti.com> <1371263570-9323-5-git-send-email-joelagnel@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:aaz6rM/U9Oo+5xUmLJr5eDFi8h7gcRkAWpr0ng4dyGA
 rdl6a8w42c6diy1yu/l8PH6wWeXMp79UVBzpiEgGzL+ISUAUPY
 CX6e/awH4VQxUvttaJv00y+SMhO2pGVQeGaFgbp9duTrQ1VZho
 gqZP3C/h06O9QPLtrmxfZ+kBEMEUWJO8rFYjudb329GBlPf11T
 cruwsa/2sEolJU3pGN44AuUYpzD5hYH5X1hEAAeMVO+D7RGIph
 VHabJmYTdlNnqfN1q4Hrbp1f7mnS87zf98sNd9HmaBkKssKK6J
 qewiIXvKFkk8VDlomDT6Coh0fJYpznTql3IVv1MvM6MrYWBQvQ
 vb/3v7CJcbabWcOgmp44=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 June 2013 21:32:47 Joel A Fernandes wrote:
> 
> diff --git a/Documentation/devicetree/bindings/dma/ti-edma.txt b/Documentation/devicetree/bindings/dma/ti-edma.txt
> new file mode 100644
> index 0000000..ada0018
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/ti-edma.txt
> @@ -0,0 +1,26 @@
> +TI EDMA
> +
> +Required properties:
> +- compatible : "ti,edma3"
> +- ti,hwmods: Name of the hwmods associated to the EDMA
> +- ti,edma-regions: Number of regions
> +- ti,edma-slots: Number of slots
> +
> +Optional properties:
> +- ti,edma-xbar-event-map: Crossbar event to channel map

You need to list #dma-cells as required here, and which values are accepted by
the driver (I suppose only <1>). You should also explain the format of the
dma-specifier for a slave here for each possible value of #dma-cells.

For each of the standard properties (reg, interrupts, dma-channels), list
whether they are optional or required. Since the example has three interrupts,
you should probably list how many interrupts need to be specified (minimum
and maximum if the number is variable) and in what order to expect them.

	Arnd
