Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaI0J25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 05:28:57 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44729 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751755AbaI0J24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 05:28:56 -0400
Date: Sat, 27 Sep 2014 10:28:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        lars@metafoo.de, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>
Subject: Re: [PATCH 7/9] dmaengine: Move slave caps to dma_device
Message-ID: <20140927092846.GA5182@n2100.arm.linux.org.uk>
References: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com> <1411808085-27792-8-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411808085-27792-8-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 10:54:43AM +0200, Maxime Ripard wrote:
> The previous code was relying on the fact that the slave_caps were to be
> defined on a per channel basis.
> 
> However, this proved to be a bit overkill, since every driver filling these so
> far were hardcoding it, disregarding which channel was actually given.
> 
> Add these capabilities to the dma_device structure, so that drivers can just
> provide them at probe time, and be done with it.

This is also buggy for the same reason as patch 6.

The only way to do this is to either have a flag day, fixing all drivers
at once (which isn't going to happen) or leave the caps code as-is, and
provide a library function which drivers can hook into the caps callback
which retrieves the information from dma_device.

That way, DMA engine drivers which are using the new method can just
install the new function, and those which haven't been updated with
capabilities can carry on as they are, and are detectable to drivers.

What would be acceptable is to have the DMA engine registration function
spot the lack of DMA caps function and print a warning at boot to
encourage people to add it.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
