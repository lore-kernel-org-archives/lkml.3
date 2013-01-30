Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab3A3SZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 13:25:09 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59288 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab3A3SZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 13:25:06 -0500
Date: Wed, 30 Jan 2013 18:23:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, walter harms <wharms@bfs.de>,
        Mike Rapoport <mike@compulab.co.il>, Valdis.Kletnieks@vt.edu,
        cocci@systeme.lip6.fr, Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: coccinelle and bitmask arithmetic
Message-ID: <20130130182342.GS23505@n2100.arm.linux.org.uk>
References: <20130127201947.GO16282@mwanda> <9561.1359474916@turing-police.cc.vt.edu> <1359475998.4196.26.camel@joe-AO722> <alpine.DEB.2.02.1301291847070.3339@hadrien> <1359482637.15135.7.camel@joe-AO722> <5108D808.6010405@bfs.de> <20130130111420.GG23505@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1301301220290.1990@hadrien> <20130130113533.GI23505@n2100.arm.linux.org.uk> <1359564809.32305.23.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359564809.32305.23.camel@joe-AO722>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 08:53:29AM -0800, Joe Perches wrote:
> On Wed, 2013-01-30 at 11:35 +0000, Russell King - ARM Linux wrote:
> > On Wed, Jan 30, 2013 at 12:21:21PM +0100, Julia Lawall wrote:
> > > On Wed, 30 Jan 2013, Russell King - ARM Linux wrote:
> > > > So, _either_ logical OR or addition works.
> > > >
> > > > If we _did_ end up with a PHYS_OFFSET with bits less than bit 26 set
> > > > here, we'd have bigger problems - because the base of RAM in PCI space
> > > > will not correspond with PHYS_OFFSET and all the DMA mapping stuff breaks.
> > > 
> > > The "problem" is that the computation is done inconsistently within the
> > > same file.  Sometimes with + and sometimes with |.
> > 
> > And I say that is not a problem; if it _does_ become a problem, there are
> > bigger problems that would also need solving, which given a multi-subarch
> > kernel become a lot lot harder.
> > 
> > Sure, we can just change them to all be a bitwise OR (sorry, not logical)
> > but that's really only half the story.
> 
> As far as I can tell, there'd be a lot of +'s to
> change in arch/arm and only 2 uses of | in it8152.c
> 
> $ git grep -P "\(?\s*SZ_\d+[A-Z]\s*-\s*1\s*\)?\s*\|" arch/arm
> arch/arm/common/it8152.c:                       *dev->dma_mask = (SZ_64M - 1) | PHYS_OFFSET;
> arch/arm/common/it8152.c:               dev->coherent_dma_mask = (SZ_64M - 1) | PHYS_OFFSET;
> 
> $ git grep -P "\+\s*\(?\s*SZ_\d+[A-Z]\b\s*-\s*1\s*\)?" arch/arm | wc -l
> 460
> 
> I think consistently using + would make it simpler
> for some possible future conversion.

Respectfully, I really don't care about this at the present time.  There's
bigger fish (and kernel developers) that need frying - such as fixing the
ARM kernel so it actually boots on the platforms that it used to before
all this DT crap and DMA crap came along and sodded things up.

The issue you refer to above is petty in comparison; the above works
fine, which is more than can be said about the platform I've just tried to
boot.  Sorry.
