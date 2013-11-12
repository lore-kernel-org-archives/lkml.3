Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab3KLKWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:22:24 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42642 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3KLKWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:22:22 -0500
Date: Tue, 12 Nov 2013 10:19:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] of: set dma_mask to point to coherent_dma_mask
Message-ID: <20131112101955.GF16735@n2100.arm.linux.org.uk>
References: <1383109522-6879-1-git-send-email-robherring2@gmail.com> <20131102180724.D8FC5C40F02@trevor.secretlab.ca> <alpine.DEB.2.02.1311061642270.26077@kaball.uk.xensource.com> <alpine.DEB.2.02.1311111658100.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311111658100.26077@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 04:59:14PM +0000, Stefano Stabellini wrote:
> On Wed, 6 Nov 2013, Stefano Stabellini wrote:
> > On Sat, 2 Nov 2013, Grant Likely wrote:
> > > On Wed, 30 Oct 2013 00:05:22 -0500, Rob Herring <robherring2@gmail.com> wrote:
> > > > From: Rob Herring <rob.herring@calxeda.com>
> > > > 
> > > > Platform devices created by DT code don't initialize dma_mask pointer to
> > > > anything. Set it to coherent_dma_mask by default if the architecture
> > > > code has not set it.
> > > > 
> > > > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > > 
> > > I believe this is okay. I haven't done any testing to back up that
> > > opinion though.
> > 
> > Tested-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> BTW I hope you are planning on sending this upstream soon, because
> without it I can very easily corrupt my root fs by simply booting the system.

What's the mechanism for that corruption?  Having the DMA mask not set
should not cause DMA corruption - that hints at something else being
wrong, and that needs to be investigated.
