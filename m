Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab3KKRAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:00:54 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:9898 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab3KKRAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:00:38 -0500
X-IronPort-AV: E=Sophos;i="4.93,679,1378857600"; 
   d="scan'208";a="70664771"
Date: Mon, 11 Nov 2013 16:59:14 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] of: set dma_mask to point to coherent_dma_mask
In-Reply-To: <alpine.DEB.2.02.1311061642270.26077@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1311111658100.26077@kaball.uk.xensource.com>
References: <1383109522-6879-1-git-send-email-robherring2@gmail.com> <20131102180724.D8FC5C40F02@trevor.secretlab.ca> <alpine.DEB.2.02.1311061642270.26077@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013, Stefano Stabellini wrote:
> On Sat, 2 Nov 2013, Grant Likely wrote:
> > On Wed, 30 Oct 2013 00:05:22 -0500, Rob Herring <robherring2@gmail.com> wrote:
> > > From: Rob Herring <rob.herring@calxeda.com>
> > > 
> > > Platform devices created by DT code don't initialize dma_mask pointer to
> > > anything. Set it to coherent_dma_mask by default if the architecture
> > > code has not set it.
> > > 
> > > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > 
> > I believe this is okay. I haven't done any testing to back up that
> > opinion though.
> 
> Tested-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

BTW I hope you are planning on sending this upstream soon, because
without it I can very easily corrupt my root fs by simply booting the system.


> > > I think this is at least part of what is needed to fix dma_mask issue
> > > raised by Stefano [1]. Things should work AFAICT with just this, but
> > > I suppose the xgmac driver needs to set the mask as well (not relying
> > > on the default), but some pointing the dma_mask to a valid value is
> > > needed first.
> > > 
> > > Rob
> > > 
> > > [1] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg528236.html
> > > 
> > >  drivers/of/platform.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> > > index f6dcde2..fce088e 100644
> > > --- a/drivers/of/platform.c
> > > +++ b/drivers/of/platform.c
> > > @@ -215,6 +215,8 @@ static struct platform_device *of_platform_device_create_pdata(
> > >  	dev->archdata.dma_mask = 0xffffffffUL;
> > >  #endif
> > >  	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> > > +	if (!dev->dev.dma_mask)
> > > +		dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
> > >  	dev->dev.bus = &platform_bus_type;
> > >  	dev->dev.platform_data = platform_data;
> > >  
> 
