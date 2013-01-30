Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3A3Lgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:36:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58890 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab3A3Lgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:36:41 -0500
Date: Wed, 30 Jan 2013 11:35:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: walter harms <wharms@bfs.de>, Joe Perches <joe@perches.com>,
        Mike Rapoport <mike@compulab.co.il>, Valdis.Kletnieks@vt.edu,
        cocci@systeme.lip6.fr, Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: coccinelle and bitmask arithmetic
Message-ID: <20130130113533.GI23505@n2100.arm.linux.org.uk>
References: <20130127194039.GA18787@elgon.mountain> <1359317078.14406.12.camel@joe-AO722> <20130127201947.GO16282@mwanda> <9561.1359474916@turing-police.cc.vt.edu> <1359475998.4196.26.camel@joe-AO722> <alpine.DEB.2.02.1301291847070.3339@hadrien> <1359482637.15135.7.camel@joe-AO722> <5108D808.6010405@bfs.de> <20130130111420.GG23505@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1301301220290.1990@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1301301220290.1990@hadrien>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 12:21:21PM +0100, Julia Lawall wrote:
> 
> 
> On Wed, 30 Jan 2013, Russell King - ARM Linux wrote:
> 
> > On Wed, Jan 30, 2013 at 09:21:28AM +0100, walter harms wrote:
> > > Great hit Joe :)
> > >
> > > Sometimes i am really surprised what code can be found
> > > in the kernal and it is still working.
> > > Having no clue of the code i suspect somebody tries to
> > > check is mask outside the range it should read
> > > PHYS_OFFSET |( SZ_64M - 1)
> > > maybe someone should tell them that
> > > 1+1=10 while 1|1=1
> > > It does not seem to matter here (or ... ?)
> >
> > This PCI host is only used on one platform (ARMCORE).
> >
> > For this, PHYS_OFFSET will be a value with only the top few bits of a
> > 32-bit word set (such as 0xc0000000) - it's certainly not going to have
> > any bits set below bit 26 on the platform this driver gets used on.
> > "SZ_64M - 1" is the size of the window that RAM appears.
> >
> > So, _either_ logical OR or addition works.
> >
> > If we _did_ end up with a PHYS_OFFSET with bits less than bit 26 set
> > here, we'd have bigger problems - because the base of RAM in PCI space
> > will not correspond with PHYS_OFFSET and all the DMA mapping stuff breaks.
> 
> The "problem" is that the computation is done inconsistently within the
> same file.  Sometimes with + and sometimes with |.

And I say that is not a problem; if it _does_ become a problem, there are
bigger problems that would also need solving, which given a multi-subarch
kernel become a lot lot harder.

Sure, we can just change them to all be a bitwise OR (sorry, not logical)
but that's really only half the story.
