Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab3CSSZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:25:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49046 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab3CSSZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:25:19 -0400
Date: Tue, 19 Mar 2013 18:25:14 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Matt Porter <mporter@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Tomas Novotny <tomas@novotny.cz>, "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [ 41/75] ARM: davinci: edma: fix dmaengine induced null pointer
 dereference on da830
Message-ID: <20130319182514.GA3041@hercules>
References: <20130318210510.203500214@linuxfoundation.org>
 <20130318210513.183706082@linuxfoundation.org>
 <f20a6d0dd7604c0fa6ed95604a8dfb35@DLEE70.ent.ti.com>
 <20130319172714.GD18335@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130319172714.GD18335@beef>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 01:27:14PM -0400, Matt Porter wrote:
> On Tue, Mar 19, 2013 at 04:25:35PM +0000, Luis Henriques wrote:
> > On Mon, Mar 18, 2013 at 02:07:04PM -0700, Greg Kroah-Hartman wrote:
> > > 3.8-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Matt Porter <mporter@ti.com>
> > > 
> > > commit 069552777a121eb39da29de4bc0383483dbe1f7e upstream.
> > > 
> > > This adds additional error checking to the private edma api implementation
> > > to catch the case where the edma_alloc_slot() has an invalid controller
> > > parameter. The edma dmaengine wrapper driver relies on this condition
> > > being handled in order to avoid setting up a second edma dmaengine
> > > instance on DA830.
> > > 
> > > Verfied using a DA850 with the second EDMA controller platform instance
> > > removed to simulate a DA830 which only has a single EDMA controller.
> > > 
> > > Reported-by: Tomas Novotny <tomas@novotny.cz>
> > > Signed-off-by: Matt Porter <mporter@ti.com>
> > > Tested-by: Tomas Novotny <tomas@novotny.cz>
> > > Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > 
> > > ---
> > >  arch/arm/mach-davinci/dma.c |    3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > --- a/arch/arm/mach-davinci/dma.c
> > > +++ b/arch/arm/mach-davinci/dma.c
> > > @@ -743,6 +743,9 @@ EXPORT_SYMBOL(edma_free_channel);
> > >   */
> > >  int edma_alloc_slot(unsigned ctlr, int slot)
> > >  {
> > > +	if (!edma_cc[ctlr])
> > > +		return -EINVAL;
> > > +
> > >  	if (slot >= 0)
> > >  		slot = EDMA_CHAN_SLOT(slot);
> > 
> > I couldn't figure out the reason why this is tagged for v3.7.x+ only.
> > Shouldn't this be applied to 3.2, 3.4 and 3.5 as well?
> 
> The bug being fixed is triggered by the edma dmaengine driver (and only
> on one board) that was introduced in 3.7. Prior to that it is just a
> theoretical bug.

Great, thanks for the clarification.

Cheers,
--
Luis
