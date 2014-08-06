Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaHFTEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:04:20 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46480 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbaHFTER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:04:17 -0400
Date: Wed, 6 Aug 2014 12:04:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: David Wood <david@dtwood.co.uk>
Cc: Nick Krause <xerofoiffy@gmail.com>, Mark Brown <broonie@kernel.org>,
        "open list:SPI SUBSYSTEM" <linux-spi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH] spi: Fix warning about redefinition
Message-ID: <20140806190412.GA5605@roeck-us.net>
References: <CAO+Sx3nGKN1jh0VB9NjcFCqV7ZmWWjJge0nohdUGta9BF60EWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO+Sx3nGKN1jh0VB9NjcFCqV7ZmWWjJge0nohdUGta9BF60EWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 08:53:41PM +0200, David Wood wrote:
> On Wed, 6 Aug 2014 11:33:28 -0700, Guenter Roeck wrote:
> > On Wed, Aug 06, 2014 at 07:19:54PM +0200, Richard Weinberger wrote:
> > > On Wed, Aug 6, 2014 at 6:55 PM, Nick Krause <xerofoiffy@gmail.com> wrote:
> > > > Fix the following warnings about redefining READ and write
> > > >
> > > > drivers/spi/spi-omap-100k.c:73:0: warning: "WRITE" redefined [enabled by default]
> > > > include/linux/fs.h:193:0: note: this is the location of the previous definition
> > > > drivers/spi/spi-omap-100k.c:74:0: warning: "READ" redefined [enabled by default]
> > > > include/linux/fs.h:192:0: note: this is the location of the previous definition
> > > >
> > > > Signed-off-by: Nick Krause <xerofoiffy@gmail.com>
> > > > ---
> > > >  drivers/spi/spi-omap-100k.c | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > >
> > > > diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
> > > > index 5e91858..eb8ae4e 100644
> > > > --- a/drivers/spi/spi-omap-100k.c
> > > > +++ b/drivers/spi/spi-omap-100k.c
> > > > @@ -70,6 +70,12 @@
> > > >  #define SPI_STATUS_WE                   (1UL << 1)
> > > >  #define SPI_STATUS_RD                   (1UL << 0)
> > > >
> > > > +#ifdef WRITE
> > > > +#undef WRITE
> > > > +#endif
> > > > +#ifdef READ
> > > > +#undef READ
> > > > +#endif
> > > >  #define WRITE 0
> > > >  #define READ  1
> > >
> > > Are these symbols even in use?
> > >
> >
> > It is always fun watching those patches flow by :-)
> > With the following patch:
> > diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
> > index 5e91858..f72ddfc 100644
> > --- a/drivers/spi/spi-omap-100k.c
> > +++ b/drivers/spi/spi-omap-100k.c
> > @@ -70,8 +70,8 @@
> >  #define SPI_STATUS_WE                   (1UL << 1)
> >  #define SPI_STATUS_RD                   (1UL << 0)
> > -#define WRITE 0
> > -#define READ  1
> > +#undef WRITE
> > +#undef READ
> > [ just to make sure that no existing defines are used instead of the new ones ]
> > When compiling the resulting code with W=1, I get:
> > drivers/spi/spi-omap-100k.c: In function 'spi100k_read_data':
> > drivers/spi/spi-omap-100k.c:148:6: warning: variable 'dataH' set but not used
> > [-Wunused-but-set-variable]
> > So, one might conclude that the defines are not used.
> > Guenter
> 
> There's also no need to have the undefines, as the READ is defined as

That was purely to ensure that there is no hidden use through a macro
defined elsewhere, not a suggestion for a real patch.

Guenter
