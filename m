Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750918AbaGGEcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 00:32:25 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:43473
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705AbaGGEcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 00:32:22 -0400
X-IronPort-AV: E=Sophos;i="5.01,616,1400018400"; 
   d="scan'208";a="70345570"
Date: Mon, 7 Jul 2014 06:32:04 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Greg KH <greg@kroah.com>
cc: Himangi Saraogi <himangi774@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thunderbolt: Correct the size argument to devm_kzalloc
In-Reply-To: <20140706235818.GA18457@kroah.com>
Message-ID: <alpine.DEB.2.02.1407070629100.2014@localhost6.localdomain6>
References: <20140706161342.GA6267@himangi-Dell> <20140706235818.GA18457@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Jul 2014, Greg KH wrote:

> On Sun, Jul 06, 2014 at 09:43:42PM +0530, Himangi Saraogi wrote:
> > nhi->rx_rings does not have type as struct tb_ring *, as it is a
> > double pointer so the elements of the array should have pointer type,
> > not structure type.
> > 
> > The Coccinelle semantic patch that makes this change is as follows:
> > 
> > // <smpl>
> > @disable sizeof_type_expr@
> > type T;
> > T **x;
> > @@
> > 
> >   x =
> >   <+...sizeof(
> > - T
> > + *x
> >   )...+>
> > // </smpl>
> > 
> > Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> > Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> > ---
> >  drivers/thunderbolt/nhi.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Any reason you didn't cc: the developers in charge of this code so they
> see it and can pick it up?  Otherwise it's just going to float around on
> the mailing list, listless and sad.

They don't seem to be in the MAINTAINERS file.

Himangi, you would see some people if you drop the --nogit-fallback 
argument from get_maintainers.  Maybe that is too strict.

julia
