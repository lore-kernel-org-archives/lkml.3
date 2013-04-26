Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab3DZJor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:44:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39176 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682Ab3DZJoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:44:46 -0400
Date: Fri, 26 Apr 2013 10:44:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Vinod Koul <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        magnus.p.persson@stericsson.com,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Andreas Westin <andreas.westin@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 6/9] crypto: ux500/cryp - Set DMA configuration though
	dma_slave_config()
Message-ID: <20130426094430.GH14496@n2100.arm.linux.org.uk>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org> <CACRpkdaBf++gy3sghC-t33uio2+eHp1MrQ2FM0XXBazZTtm3kA@mail.gmail.com> <20130426081646.GD24632@intel.com> <1457204.tIrKjcEogd@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1457204.tIrKjcEogd@wuerfel>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 11:39:20AM +0200, Arnd Bergmann wrote:
> On Friday 26 April 2013 13:46:46 Vinod Koul wrote:
> > 
> > The mapping & unmapping of dma buffer (memcpy and memory buffer in this txn) is
> > required to be performed by the client driver. The dmanegine or dmaengine driver
> > will not do that for you...
> 
> I've been wondering about this part: since we need to pass the 'struct device' of
> the dma engine (rather than the slave) into dma_map_single, what is the official
> way to do that? Should the slave driver just rely on dma_chan->device->dev to
> work correctly for the purpose of dma-mapping.h interfaces?

Yes.
