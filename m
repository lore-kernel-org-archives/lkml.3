Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaIKKqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:46:04 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:51045 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754134AbaIKKqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:46:01 -0400
Date: Thu, 11 Sep 2014 11:45:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>, Vinod Koul <vinod.koul@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Peter Griffin <peter.griffin@linaro.org>, Balaji T K <balajitk@ti.com>,
        Nishanth Menon <nm@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/3] omap-dma: Allow compile-testing omap1_camera driver
Message-ID: <20140911104518.GA12379@n2100.arm.linux.org.uk>
References: <20140909124306.2d5a0d76@canb.auug.org.au> <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com> <20140909144157.GF12361@n2100.arm.linux.org.uk> <20140909123654.37d60f38.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909123654.37d60f38.m.chehab@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 12:36:54PM -0300, Mauro Carvalho Chehab wrote:
> Hmm... it seems that there are still several drivers still relying on
> the functions declared at: omap-dma.h:
> 
> $ grep extern include/linux/omap-dma.h |perl -ne 'print "$1\n" if (m/extern\s\S+\s(.*)\(/)' >funcs && git grep -f funcs -l
> arch/arm/mach-omap1/pm.c
> arch/arm/mach-omap2/pm24xx.c
> arch/arm/plat-omap/dma.c
> drivers/dma/omap-dma.c
> drivers/media/platform/omap/omap_vout_vrfb.c
> drivers/media/platform/omap3isp/isphist.c
> drivers/media/platform/soc_camera/omap1_camera.c
> drivers/mtd/onenand/omap2.c
> drivers/usb/gadget/udc/omap_udc.c
> drivers/usb/musb/tusb6010_omap.c
> drivers/video/fbdev/omap/omapfb_main.c
> include/linux/omap-dma.h
> 
> Perhaps we can remove the header and mark all the above as BROKEN.

Not quite.  You'll notice that drivers/dma/omap-dma.c appears in that
list.  That is because right now, the new code has to co-operate with
the old legacy code to ensure that both do not try and operate on the
same hardware channel simultaneously.

Right now, when anyone tries to use any of the drivers using the legacy
APIs, they will get a warning printed in their kernel message log.  This
is part of my attempt to try and find out:

(a) whether anyone is using these drivers
(b) whether we can delete these drivers

That warning has not been in the kernel long enough to be certain of
anything - it was merged during the last merge window (despite me
having it ready to go since the previous merge window, it would not
have been correct to introduce a new warning during the -rc period.)

What I recommend is that you just don't mark the OMAP drivers for
compile testing right now, especially as their future is rather
uncertain.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
