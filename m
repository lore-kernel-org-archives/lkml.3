Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab3KLNXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 08:23:12 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:30051 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab3KLNXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 08:23:08 -0500
X-IronPort-AV: E=Sophos;i="4.93,684,1378857600"; 
   d="scan'208";a="70996559"
Date: Tue, 12 Nov 2013 13:21:44 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] of: set dma_mask to point to coherent_dma_mask
In-Reply-To: <20131112101955.GF16735@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1311121315460.26077@kaball.uk.xensource.com>
References: <1383109522-6879-1-git-send-email-robherring2@gmail.com> <20131102180724.D8FC5C40F02@trevor.secretlab.ca> <alpine.DEB.2.02.1311061642270.26077@kaball.uk.xensource.com> <alpine.DEB.2.02.1311111658100.26077@kaball.uk.xensource.com>
 <20131112101955.GF16735@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Nov 2013, Russell King - ARM Linux wrote:
> On Mon, Nov 11, 2013 at 04:59:14PM +0000, Stefano Stabellini wrote:
> > On Wed, 6 Nov 2013, Stefano Stabellini wrote:
> > > On Sat, 2 Nov 2013, Grant Likely wrote:
> > > > On Wed, 30 Oct 2013 00:05:22 -0500, Rob Herring <robherring2@gmail.com> wrote:
> > > > > From: Rob Herring <rob.herring@calxeda.com>
> > > > > 
> > > > > Platform devices created by DT code don't initialize dma_mask pointer to
> > > > > anything. Set it to coherent_dma_mask by default if the architecture
> > > > > code has not set it.
> > > > > 
> > > > > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > > > 
> > > > I believe this is okay. I haven't done any testing to back up that
> > > > opinion though.
> > > 
> > > Tested-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > BTW I hope you are planning on sending this upstream soon, because
> > without it I can very easily corrupt my root fs by simply booting the system.
> 
> What's the mechanism for that corruption?  Having the DMA mask not set
> should not cause DMA corruption - that hints at something else being
> wrong, and that needs to be investigated.

Russell, you are right.
I went through the swiotlb-xen code and I realized that I missed a
map_page call on one of the (usually unused) fallback paths.
Thanks!!
