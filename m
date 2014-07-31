Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065AbaGaMFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:05:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:64814 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaGaMFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:05:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="366180416"
Date: Thu, 31 Jul 2014 17:26:28 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com, ludovic.desroches@atmel.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the
 dma controller API
Message-ID: <20140731115628.GQ8181@intel.com>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140730160607.GM8181@intel.com>
 <20140731074440.GY3952@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V4b9U9vrdWczvw78"
Content-Disposition: inline
In-Reply-To: <20140731074440.GY3952@lukather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V4b9U9vrdWczvw78
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 09:44:40AM +0200, Maxime Ripard wrote:
> Hi Vinod,
>=20
> On Wed, Jul 30, 2014 at 09:36:07PM +0530, Vinod Koul wrote:
> > On Wed, Jul 30, 2014 at 06:03:13PM +0200, Maxime Ripard wrote:
> > > The dmaengine is neither trivial nor properly documented at the momen=
t, which
> > > means a lot of trial and error development, which is not that good fo=
r such a
> > > central piece of the system.
> > >=20
> > > Attempt at making such a documentation.
> >=20
> > Did you miss Documentation/dmaengine.txt, lots of this is already cover=
ed
> > there. But yes i would be really glad to know what isnt, so that we can=
 fix
> > that.
>=20
> I didn't miss it. But I feel like it describes quite nicely the slave
> API, but doesn't help at all whenever you're writing a DMAengine driver.
>=20
> The first lines of the existing document makes it quite clear too.
>=20
> There's still a bit of duplication, but I don't feel it's such a big
> deal.
And that made me think that you might have missed it.

I am okay for idea to have this document but it needs to co-exist one. No
point in duplicating as it can create ambiguity in future.
>=20
> What I'd like to do with the documentation I just sent is basically
> have a clear idea whenever you step into dmaengine what you can/cannot
> do, and have a reference document explaining what's expected by the
> framework, and hopefully have unified drivers that follow this
> pattern.
Sure, can you pls modify this to avoid duplication. I would be happy to
apply that :)

>=20
> Because, for the moment, we're pretty much left in the dark with
> different drivers doing the same thing in completetely different ways,
> with basically no way to tell if it's either the framework that
> requires such behaviour, or if the author was just feeling creative.
>=20
> There's numerous examples for this at the moment:
>   - The GFP flags, with different drivers using either GFP_ATOMIC,
>     GFP_NOWAIT or GFP_KERNEL in the same functions
>   - Having to set device_slave_caps or not?
>   - Some drivers use dma_run_depedencies, some other don't
>   - That might just be my experience, but judging from previous
>     commits, DMA_PRIVATE is completely obscure, and we just set it
>     because it was making it work, without knowing what it was
>     supposed to do.
>   - etc.

Thanks for highlighting we should definitely add these in Documentation

>=20
> And basically, we have no way to tell at the moment which one is
> right and which one needs fixing.
>=20
> The corollary being that it cripples the whole community ability to
> maintain the framework and make it evolve.
>=20
> > > +  * device_slave_caps
> > > +    - Isn't that redundant with the cap_mask already?
> > > +    - Only a few drivers seem to implement it
> > For audio to know what your channel can do rather than hardcoding it
>=20
> Ah, yes, I see it now. It's not related to the caps mask at all.
>=20
> Just out of curiosity, wouldn't it be better to move this to the
> framework, and have these informations provided through the struct
> dma_device? Or would it have some non-trivial side-effects?
Well the problem is ability to have this queried uniformly from all drivers
across subsystems. If we can do this that would be nice.
>=20
> > > +  * dma cookies?
> > cookie is dma transaction representation which is monotonically increme=
nting
> > number.
>=20
> Ok, and it identifies a unique dma_async_tx_descriptor, right?
Yup and this basically represents transactions you have submitted. Thats why
cookie is allocated at tx_submit.

Thanks

--=20
~Vinod


--=20

--V4b9U9vrdWczvw78
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJT2i7rAAoJEHwUBw8lI4NHWzIP/1/pNcJ7pmeQxb4eC8pJMT8o
CsO9/vcAEtL2xYiI/SAOFBSlh+OeKlKhHSO3vuxqgPejovoy/hb4IZKNA8QW25+N
0TmbsvUGM0LYLGsMt7UPnujHhB7/or3gZNBN+yN/7XEcpFDR5iCDZyfqigTwIvYe
CPNcK2cK1aSw/ORiZExAqkEvyYuC87D6VAe673skVu3ycbQnheA/GZd9SYoydnzb
74F/sDUwsInP5KazYHzx7qPGYwPZxMKQ03OzwCHNEG10hwckUJ3eTOOrhHKvcojd
kc1nxTHQz+yrAxY9MQAh7fQroYYyDzm39n67sRRmpHCyTaxIzQiLcQogKD9X1dTE
0AGNm5jJGkTqU5Av2rNQRWdnIlBqTec+T+5XaErAfuHLoPH9FLBKROsdTyzqc1CJ
oEbHHtVCDeVDt7PNefPpJOTdBo9Ttrhn41fTKKZieGV9WyQTV76w/IjIJfO7Yxy5
0/sNKUG77xhJj0XJ2DZWsJFQB397AiotH3JdQKdFR6tt84q90nQN35gXL+9fdSYg
HZz5cJgsBjjYA1+bE8n5UTYf4FrjNGN7GJ+3hY1MEx6uESoWM28wtKy54T6888Vf
O+0Kwd9EVy2hDa2lQkIicD6eNT6GfwYKB4YoHnFxdwh8HaXbn6IBcGFvZZgz9fPc
nPs6JWqjeMdgUVV9SD42
=odbr
-----END PGP SIGNATURE-----

--V4b9U9vrdWczvw78--
