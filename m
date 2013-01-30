Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab3A3LV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:21:26 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:9939 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754622Ab3A3LVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:21:23 -0500
X-IronPort-AV: E=Sophos;i="4.84,567,1355094000"; 
   d="scan'208";a="629919"
Date: Wed, 30 Jan 2013 12:21:21 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: walter harms <wharms@bfs.de>, Joe Perches <joe@perches.com>,
        Mike Rapoport <mike@compulab.co.il>, Valdis.Kletnieks@vt.edu,
        cocci@systeme.lip6.fr, Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: coccinelle and bitmask arithmetic
In-Reply-To: <20130130111420.GG23505@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1301301220290.1990@hadrien>
References: <20130127194039.GA18787@elgon.mountain> <1359317078.14406.12.camel@joe-AO722> <20130127201947.GO16282@mwanda> <9561.1359474916@turing-police.cc.vt.edu> <1359475998.4196.26.camel@joe-AO722> <alpine.DEB.2.02.1301291847070.3339@hadrien>
 <1359482637.15135.7.camel@joe-AO722> <5108D808.6010405@bfs.de> <20130130111420.GG23505@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jan 2013, Russell King - ARM Linux wrote:

> On Wed, Jan 30, 2013 at 09:21:28AM +0100, walter harms wrote:
> > Great hit Joe :)
> >
> > Sometimes i am really surprised what code can be found
> > in the kernal and it is still working.
> > Having no clue of the code i suspect somebody tries to
> > check is mask outside the range it should read
> > PHYS_OFFSET |( SZ_64M - 1)
> > maybe someone should tell them that
> > 1+1=10 while 1|1=1
> > It does not seem to matter here (or ... ?)
>
> This PCI host is only used on one platform (ARMCORE).
>
> For this, PHYS_OFFSET will be a value with only the top few bits of a
> 32-bit word set (such as 0xc0000000) - it's certainly not going to have
> any bits set below bit 26 on the platform this driver gets used on.
> "SZ_64M - 1" is the size of the window that RAM appears.
>
> So, _either_ logical OR or addition works.
>
> If we _did_ end up with a PHYS_OFFSET with bits less than bit 26 set
> here, we'd have bigger problems - because the base of RAM in PCI space
> will not correspond with PHYS_OFFSET and all the DMA mapping stuff breaks.

The "problem" is that the computation is done inconsistently within the
same file.  Sometimes with + and sometimes with |.

julia
