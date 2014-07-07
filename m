Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022AbaGGFm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 01:42:27 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35938 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbaGGFm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 01:42:26 -0400
X-Sasl-enc: MTylESLX1sSCzhbuk1K9i5d2c0yGqD7HZrAcmoICv8dp 1404711744
Date: Sun, 6 Jul 2014 22:42:08 -0700
From: Greg KH <greg@kroah.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Himangi Saraogi <himangi774@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thunderbolt: Correct the size argument to devm_kzalloc
Message-ID: <20140707054208.GA19965@kroah.com>
References: <20140706161342.GA6267@himangi-Dell>
 <20140706235818.GA18457@kroah.com>
 <alpine.DEB.2.02.1407070629100.2014@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407070629100.2014@localhost6.localdomain6>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 06:32:04AM +0200, Julia Lawall wrote:
> 
> 
> On Sun, 6 Jul 2014, Greg KH wrote:
> 
> > On Sun, Jul 06, 2014 at 09:43:42PM +0530, Himangi Saraogi wrote:
> > > nhi->rx_rings does not have type as struct tb_ring *, as it is a
> > > double pointer so the elements of the array should have pointer type,
> > > not structure type.
> > > 
> > > The Coccinelle semantic patch that makes this change is as follows:
> > > 
> > > // <smpl>
> > > @disable sizeof_type_expr@
> > > type T;
> > > T **x;
> > > @@
> > > 
> > >   x =
> > >   <+...sizeof(
> > > - T
> > > + *x
> > >   )...+>
> > > // </smpl>
> > > 
> > > Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> > > Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> > > ---
> > >  drivers/thunderbolt/nhi.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > Any reason you didn't cc: the developers in charge of this code so they
> > see it and can pick it up?  Otherwise it's just going to float around on
> > the mailing list, listless and sad.
> 
> They don't seem to be in the MAINTAINERS file.

Ah, good point.  Andreas, care to send me a patch adding yourself to the
MAINTAINERS file for drivers/thunderbolt/* so that you will get patches
like this?

thanks,

greg k-h
