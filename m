Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3BBMtn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 07:49:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33741 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270Ab3BBMtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 07:49:41 -0500
Date: Sat, 2 Feb 2013 12:49:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Matt Porter <mporter@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>, Vinod Koul <vinod.koul@intel.com>,
        Rob Landley <rob@landley.net>, Chris Ball <cjb@laptop.org>,
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
Message-ID: <20130202124906.GB2637@n2100.arm.linux.org.uk>
References: <1359742975-10421-1-git-send-email-mporter@ti.com> <1359742975-10421-2-git-send-email-mporter@ti.com> <20130201184107.GM22517@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130201184107.GM22517@atomide.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 10:41:08AM -0800, Tony Lindgren wrote:
> * Matt Porter <mporter@ti.com> [130201 10:25]:
> > Move mach-davinci/dma.c to common/edma.c so it can be used
> > by OMAP (specifically AM33xx) as well.
> 
> I think this should rather go to drivers/dma/?

Yes, it should, but just like OMAP, there's a conversion effort that needs
to be gone through.  It has one point - and only one point - which allows
its continued existence under arch/arm, and that is it already exists
there.

If it was new code, the answer would be a definite NACK, but it isn't.
It's pre-existing code which is already in mainline.  It's merely being
moved.

Another plus point for it is that there does seem to be a DMA engine
driver for it, so hopefully we'll see it killed off in arch/arm soon.
