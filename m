Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbaJAIzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:55:33 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49653 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751165AbaJAIzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:55:32 -0400
Date: Wed, 1 Oct 2014 09:55:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        lars@metafoo.de, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>
Subject: Re: [PATCH 7/9] dmaengine: Move slave caps to dma_device
Message-ID: <20141001085518.GN5182@n2100.arm.linux.org.uk>
References: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com> <1411808085-27792-8-git-send-email-maxime.ripard@free-electrons.com> <20140927092846.GA5182@n2100.arm.linux.org.uk> <20141001082705.GF6884@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001082705.GF6884@lukather>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:27:05AM +0200, Maxime Ripard wrote:
> On Sat, Sep 27, 2014 at 10:28:47AM +0100, Russell King - ARM Linux wrote:
> > The only way to do this is to either have a flag day, fixing all drivers
> > at once (which isn't going to happen) or leave the caps code as-is, and
> > provide a library function which drivers can hook into the caps callback
> > which retrieves the information from dma_device.
> > 
> > That way, DMA engine drivers which are using the new method can just
> > install the new function, and those which haven't been updated with
> > capabilities can carry on as they are, and are detectable to drivers.
> 
> Which is pretty much the current behaviour, isn't it?

Yes, because the ASoC code has obviously already thought about this and
solved the lack-of-caps-function problem in a way that permits existing
solutions to continue working.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
