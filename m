Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3KORon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 12:44:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42925 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab3KORoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 12:44:22 -0500
Date: Fri, 15 Nov 2013 17:43:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Florian Meier <florian.meier@koalo.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        devicetree <devicetree@vger.kernel.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv5] dmaengine: Add support for BCM2835
Message-ID: <20131115174337.GP16735@n2100.arm.linux.org.uk>
References: <52864BBC.7000506@koalo.de> <1384535016.18739.23.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384535016.18739.23.camel@joe-AO722>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 09:03:36AM -0800, Joe Perches wrote:
> On Fri, 2013-11-15 at 17:28 +0100, Florian Meier wrote:
> > +static size_t bcm2835_dma_desc_size_pos(struct bcm2835_desc *d, dma_addr_t addr)
> > +{
> > +	unsigned i;
> > +	size_t size;
> 
> Please set size to 0 here and not in the for loop
> > +
> > +	for (size = i = 0; i < d->frames; i++) {

I disagree with that comment; I think the above is not only cleaner, but
also more obvious that _this_ loop is calculating _this_ size.
