Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab3KOSUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 13:20:35 -0500
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:42524 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751566Ab3KOSUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 13:20:24 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2110:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6691:7652:8603:10004:10400:10848:11026:1
X-HE-Tag: ant36_5a76f52e54700
X-Filterd-Recvd-Size: 2237
Message-ID: <1384539624.18739.27.camel@joe-AO722>
Subject: Re: [PATCHv5] dmaengine: Add support for BCM2835
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
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
Date: Fri, 15 Nov 2013 10:20:24 -0800
In-Reply-To: <20131115174337.GP16735@n2100.arm.linux.org.uk>
References: <52864BBC.7000506@koalo.de>
	 <1384535016.18739.23.camel@joe-AO722>
	 <20131115174337.GP16735@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-15 at 17:43 +0000, Russell King - ARM Linux wrote:
> On Fri, Nov 15, 2013 at 09:03:36AM -0800, Joe Perches wrote:
> > On Fri, 2013-11-15 at 17:28 +0100, Florian Meier wrote:
> > > +static size_t bcm2835_dma_desc_size_pos(struct bcm2835_desc *d, dma_addr_t addr)
> > > +{
> > > +	unsigned i;
> > > +	size_t size;
> > 
> > Please set size to 0 here and not in the for loop
> > > +
> > > +	for (size = i = 0; i < d->frames; i++) {
> 
> I disagree with that comment; I think the above is not only cleaner, but
> also more obvious that _this_ loop is calculating _this_ size.

I think that using
	size_t size = 0;
is not only _much_ more commonly used
throughout the kernel but makes it
clearer that the initialization of the
return value is done before the loop.

Reasonable minds can differ and there
is no style guide that prefers one over
the other.

No matter really to me.
As I said, it's trivial.

cheers, Joe

