Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbaGaHpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:45:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33167 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752748AbaGaHpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:45:05 -0400
Date: Thu, 31 Jul 2014 09:44:40 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
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
Message-ID: <20140731074440.GY3952@lukather>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140730160607.GM8181@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sKosZo66cxuwvnFI"
Content-Disposition: inline
In-Reply-To: <20140730160607.GM8181@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sKosZo66cxuwvnFI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

On Wed, Jul 30, 2014 at 09:36:07PM +0530, Vinod Koul wrote:
> On Wed, Jul 30, 2014 at 06:03:13PM +0200, Maxime Ripard wrote:
> > The dmaengine is neither trivial nor properly documented at the moment,=
 which
> > means a lot of trial and error development, which is not that good for =
such a
> > central piece of the system.
> >=20
> > Attempt at making such a documentation.
>=20
> Did you miss Documentation/dmaengine.txt, lots of this is already covered
> there. But yes i would be really glad to know what isnt, so that we can f=
ix
> that.

I didn't miss it. But I feel like it describes quite nicely the slave
API, but doesn't help at all whenever you're writing a DMAengine driver.

The first lines of the existing document makes it quite clear too.

There's still a bit of duplication, but I don't feel it's such a big
deal.

What I'd like to do with the documentation I just sent is basically
have a clear idea whenever you step into dmaengine what you can/cannot
do, and have a reference document explaining what's expected by the
framework, and hopefully have unified drivers that follow this
pattern.

Because, for the moment, we're pretty much left in the dark with
different drivers doing the same thing in completetely different ways,
with basically no way to tell if it's either the framework that
requires such behaviour, or if the author was just feeling creative.

There's numerous examples for this at the moment:
  - The GFP flags, with different drivers using either GFP_ATOMIC,
    GFP_NOWAIT or GFP_KERNEL in the same functions
  - Having to set device_slave_caps or not?
  - Some drivers use dma_run_depedencies, some other don't
  - That might just be my experience, but judging from previous
    commits, DMA_PRIVATE is completely obscure, and we just set it
    because it was making it work, without knowing what it was
    supposed to do.
  - etc.

And basically, we have no way to tell at the moment which one is
right and which one needs fixing.

The corollary being that it cripples the whole community ability to
maintain the framework and make it evolve.

> > +  * device_slave_caps
> > +    - Isn't that redundant with the cap_mask already?
> > +    - Only a few drivers seem to implement it
> For audio to know what your channel can do rather than hardcoding it

Ah, yes, I see it now. It's not related to the caps mask at all.

Just out of curiosity, wouldn't it be better to move this to the
framework, and have these informations provided through the struct
dma_device? Or would it have some non-trivial side-effects?

> > +  * dma cookies?
> cookie is dma transaction representation which is monotonically increment=
ing
> number.

Ok, and it identifies a unique dma_async_tx_descriptor, right?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--sKosZo66cxuwvnFI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT2fPoAAoJEBx+YmzsjxAgtgYP/junXyTQX/m9BPROi9sM+AMD
2C8t4vVi3BAb53cqxCLQxUdc0zDZrz/Wi76cc2TgbU813XRSAWo3wFCGboFJAK/I
7nYAG8FsXXQe00sr2MOaI17mRXpQPTqH7T05V56v/6o9YRr9Vut9nctaJHjRXso8
cqzUwq+6dgdkMXBTKSXEQKiAdkC+1E0LR7zM28FWmJ7R+2bm2flSw3O95yNk0bML
tvI3aU9izZ5m8zw7CDxMOLi4NvMJYaQ5mxvFhj141Tef+4QtsKldWdXi5zYXs28M
aghiS+20ZA0tRMQMTmszYyiiqmoOnPGtSYIOshqufjxDAOC9fIiwm8wDwjedb0Ko
wdgVIUsgEn1g2sYs6bc5Z7ktBka58RNlUlTeJMia3jzfSAfvttPNEy05n0ltQLXp
ENINZuPCqyHlFq+wQQb+nrIUaHTDeDaULIirPhenLQNoyxYFHni2T8byA3jEqFR9
WX+uJUEgM26yeDCy+OW0O4Kmn6+aVpeEQEbc6r5bFSZKoYj1O666tqLPiaCMHBRU
K8W2GIxQyVMmX1pd//sAMDA2/4tawH4FadhKGpWkzeY7hvNzEp3kv7bmAK3AsQJ2
7UakY9a8DmmSf69mIrfba81zJm89VzmMy9Vu+Ld5E1f3GatF6WIsq2fQ8WgMCEvd
NQGM/MFh0bLiNX+aTq14
=3VSo
-----END PGP SIGNATURE-----

--sKosZo66cxuwvnFI--
