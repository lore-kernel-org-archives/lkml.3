Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3AKLlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 06:41:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60748 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3AKLlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 06:41:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matt Porter <mporter@ti.com>
Subject: Re: [PATCH v4 00/14] DMA Engine support for AM33XX
Date: Fri, 11 Jan 2013 11:40:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
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
References: <1357883330-5364-1-git-send-email-mporter@ti.com>
In-Reply-To: <1357883330-5364-1-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301111140.41584.arnd@arndb.de>
X-Provags-ID: V02:K0:dZMzsOrWf+WRaBCeAwp/6oZAgNDgjFwPnDsDy3AB+f4
 d+FaI/UCc48jw52HZ3lexpYG3CUkkiVbeSetrVWBaDFQ+7CVDB
 W/dWl8TnNwKfRyyj4L8iuU8IJc8w1puGzlUTBxuLrg40eKfS3m
 8tw8F1fNrcVb8qzZGVVZEVTk0dgsdthVEUvU8sQQ2mlYOwI3gf
 i8Sgi6TIGKQaZCgbAx11k6ruDVksvbDSWhnXccnV2aJsCMo6oL
 XAjvYHhj10E3AFfqR2D26HevC+G17cKsxHWlO8Lvoy3ywCvmzr
 eBrFqBlz9RQv7fvrtFWuMwg0QiPzELrnNhDj9swB5h6fEryrvg
 5RQMeJiIY26Hfa+w1eec=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2013, Matt Porter wrote:
> The approach taken is similar to how OMAP DMA is being converted to
> DMA Engine support. With the functional EDMA private API already
> existing in mach-davinci/dma.c, we first move that to an ARM common
> area so it can be shared. Adding DT and runtime PM support to the
> private EDMA API implementation allows it to run on AM33xx. AM33xx
> only boots using DT so we leverage Jon's generic DT DMA helpers to
> register EDMA DMAC with the of_dma framework and then add support
> for calling the dma_request_slave_channel() API to both the mmc
> and spi drivers.

I think this looks very good. What I wonder is whether we should
make the non-DT parts of the dmaengine driver compile-time
conditional on CONFIG_ATAGS though, so the slave drivers don't
have a link-time dependency on the dmaengine driver's 
omap_dma_filter_fn symbol when building without ATAGS support.

	Arnd
