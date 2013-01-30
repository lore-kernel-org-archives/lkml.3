Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3A3JYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:24:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50823 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3A3JY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:24:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matt Porter <mporter@ti.com>
Subject: Re: [PATCH v6 09/10] spi: omap2-mcspi: add generic DMA request support to the DT binding
Date: Wed, 30 Jan 2013 09:24:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
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
        Dan Williams <djbw@fb.com>, Rob Herring <rob.herring@calxeda.com>
References: <1359529229-22207-1-git-send-email-mporter@ti.com> <1359529229-22207-10-git-send-email-mporter@ti.com>
In-Reply-To: <1359529229-22207-10-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301300924.00508.arnd@arndb.de>
X-Provags-ID: V02:K0:+o570P4CIb4GwX0VkZGbP+QH3niP0GesoOb9gz/BXty
 ih46GOI6MEQS0vdV59MlNK8yb9WvKG23+bGtFoN1nSv1Rgpfl2
 XzE2vzu0lKZhFDYP9e4nQZ/iYeIzADXq7YAK/zsjTxtRClAaDE
 kVfLJW9ddLpE6hc4toKstzCWRfGBYiidGmMKXW86H0QhiAeSlA
 Bk0sXhVH7gsxx4LktcZiGT3dimb6wOl2ltsqNJtMyBYBLU4+Lt
 bcXNZG8rQGAG9RiFDcOGnYOr/HMf4YJD9JV0UnDe+emay5gLDj
 KilGy9F8Jh3hJP/7MD0Nm8K0VOjlgv11Uy61XvwYXKqhBpCEod
 s7H4cUFUNmMauIy3B0W8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2013, Matt Porter wrote:
> +Optional properties:
> +- dmas: List of DMA controller phandle and DMA request ordered
> +       pairs. One tx and one rx pair is required for each chip
> +       select.

The binding looks ok, but the wording is slightly incorrect here:
strictly speaking, it's not a pair of controller phandle and request
line number, but a DMA descriptor as specified in bindings/dma/dma.txt
with a format specific to the dma engine being used. That can
require more than just a single integer request number.

	Arnd
