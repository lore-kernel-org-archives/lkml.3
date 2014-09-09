Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbaIIOmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:42:24 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:48627 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753230AbaIIOmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:42:23 -0400
Date: Tue, 9 Sep 2014 15:41:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>, Vinod Koul <vinod.koul@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Peter Griffin <peter.griffin@linaro.org>, Balaji T K <balajitk@ti.com>,
        Nishanth Menon <nm@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/3] omap-dma: Allow compile-testing omap1_camera driver
Message-ID: <20140909144157.GF12361@n2100.arm.linux.org.uk>
References: <20140909124306.2d5a0d76@canb.auug.org.au> <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 11:38:17AM -0300, Mauro Carvalho Chehab wrote:
> We want to be able to COMPILE_TEST the omap1_camera driver.
> It compiles fine, but it fails linkediting:
> 
> ERROR: "omap_stop_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> ERROR: "omap_start_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> ERROR: "omap_dma_link_lch" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> ERROR: "omap_set_dma_dest_burst_mode" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> ERROR: "omap_set_dma_src_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> ERROR: "omap_request_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> ERROR: "omap_set_dma_transfer_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> ERROR: "omap_set_dma_dest_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> ERROR: "omap_free_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> 
> So, add some stub functions to avoid it.

The real answer to this is to find someone who still uses it, and convert
it to the DMA engine API.  If there's no users, the driver might as well
be killed off.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
