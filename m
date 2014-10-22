Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaJVQZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:25:05 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54394 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbaJVQY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:24:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18DfBv4COEF4Gh2goiBxZDMvyKbugeUyhk=
X-DKIM: OpenDKIM Filter v2.0.1 titan 9D5A1605772
Date: Wed, 22 Oct 2014 12:24:49 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Eric Rost <eric.rost@mybabylon.net>
Cc: gregkh@linuxfoundation.org, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: skein: Loadable Module Support
Message-ID: <20141022162449.GZ17447@titan.lakedaemon.net>
References: <20141021144427.GA31929@localhost>
 <20141022151028.GY17447@titan.lakedaemon.net>
 <1413993266.11638.1.camel@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413993266.11638.1.camel@mybabylon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 10:54:26AM -0500, Eric Rost wrote:
> On Wed, 2014-10-22 at 11:10 -0400, Jason Cooper wrote:
> > At some point, Eric Rost wrote:
...
> > > diff --git a/drivers/staging/skein/Makefile b/drivers/staging/skein/Makefile
> > > index a14aadd..1be01fe 100644
> > > --- a/drivers/staging/skein/Makefile
> > > +++ b/drivers/staging/skein/Makefile
> > > @@ -5,5 +5,11 @@ obj-$(CONFIG_CRYPTO_SKEIN) +=   skein.o \
> > >  				skein_api.o \
> > >  				skein_block.o
> > >  
> > > +obj-$(CONFIG_CRYPTO_SKEIN_256) += skein256_generic.o
> > > +
> > > +obj-$(CONFIG_CRYPTO_SKEIN_512) += skein512_generic.o
> > > +
> > > +obj-$(CONFIG_CRYPTO_SKEIN_1024) += skein1024_generic.o
> > > +
> > 
> > This isn't really doing what we want.  You'll have loadable modules, but
> > the actual code will still be built into the kernel.
> > 
> > >  obj-$(CONFIG_CRYPTO_THREEFISH) += threefish_block.o \
> > >  				  threefish_api.o
> > > diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
> > > index 8cc8358..2138e22 100644
> > > --- a/drivers/staging/skein/skein.c
> > > +++ b/drivers/staging/skein/skein.c
> > > @@ -11,6 +11,7 @@
> > >  #define  SKEIN_PORT_CODE /* instantiate any code in skein_port.h */
> > >  
> > >  #include <linux/string.h>       /* get the memcpy/memset functions */
> > > +#include <linux/export.h>
> > >  #include "skein.h" /* get the Skein API definitions   */
> > >  #include "skein_iv.h"    /* get precomputed IVs */
> > >  #include "skein_block.h"
> > > @@ -73,6 +74,7 @@ int skein_256_init(struct skein_256_ctx *ctx, size_t hash_bit_len)
> > >  
> > >  	return SKEIN_SUCCESS;
> > >  }
> > > +EXPORT_SYMBOL(skein_256_init);
> > 
> > Once the above is corrected, these shouldn't be necessary.
> > 
> Will give it a whirl, I was having problems with undefined symbols at
> linking even when I was building it as one module, but it may have been
> something else

Try just changing CRYPTO_SKEIN to a tri-state, and adding your
skein_generic.o to the obj-$(CONFIG_CRYPTO_SKEIN) list.

You'll probably have to collapse CRYPTO_THREEFISH into CRYPTO_SKEIN for
now.  Let's get the crypto API registration proper first, them we can
focus on the loadable module bit.

thx,

Jason.
