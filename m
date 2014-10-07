Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbaJGQuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:50:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35621 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754541AbaJGQuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:50:04 -0400
Date: Tue, 7 Oct 2014 18:48:30 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH v2 2/2] Documentation: dmaengine: Add a documentation for
 the dma controller API
Message-ID: <20141007164830.GC17925@lukather>
References: <1411746035-15882-1-git-send-email-maxime.ripard@free-electrons.com>
 <1411746035-15882-2-git-send-email-maxime.ripard@free-electrons.com>
 <5425AAAE.3020305@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
Content-Disposition: inline
In-Reply-To: <5425AAAE.3020305@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dkEUBIird37B8yKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

Thanks for your review,

On Fri, Sep 26, 2014 at 11:04:30AM -0700, Randy Dunlap wrote:
> On 09/26/14 08:40, Maxime Ripard wrote:
> > The dmaengine is neither trivial nor properly documented at the moment,=
 which
> > means a lot of trial and error development, which is not that good for =
such a
> > central piece of the system.
> >=20
> > Attempt at making such a documentation.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  Documentation/dmaengine/provider.txt | 358 +++++++++++++++++++++++++++=
++++++++
> >  1 file changed, 358 insertions(+)
> >  create mode 100644 Documentation/dmaengine/provider.txt
> >=20
> > diff --git a/Documentation/dmaengine/provider.txt b/Documentation/dmaen=
gine/provider.txt
> > new file mode 100644
> > index 000000000000..ba407e706cde
> > --- /dev/null
> > +++ b/Documentation/dmaengine/provider.txt
> > @@ -0,0 +1,358 @@
> > +DMAengine controller documentation
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Hardware Introduction
> > ++++++++++++++++++++++
> > +
> > +Most of the Slave DMA controllers have the same general principles of
> > +operations.
> > +
> > +They have a given number of channels to use for the DMA transfers, and
> > +a given number of requests lines.
> > +
> > +Requests and channels are pretty much orthogonal. Channels can be used
> > +to serve several to any requests. To simplify, channels are the
>=20
>                     to many ?

Not really, it was meant to say that, depending on the hardware,
channels can be handling only a few requests, or all of the requests
that might be connected to the dma controller.

[...]
=20
> > +need to initialize a few fields in there:
> > +
> > +  * chancnt:	should be the number of channels your driver is exposing
> > +		to the system.
> > +		This doesn't have to be the number of physical
> > +		channels: some DMA controllers also expose virtual
> > +		channels to the system to overcome the case where you
> > +		have more consumers than physical channels available.
> > +
> > +  * channels:	should be initialized as a list using the
> > +		INIT_LIST_HEAD macro for example
>=20
> 	But what does 'channels' contain?

A list of initialised struct dma_chan. The exact meaning of
"initialised" is kind of blurry, because it's somewhat
driver-specific, because this structure will be the one that will be
passed to your callback, so you need to put in there whatever
information you need to process the future callbacks.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--dkEUBIird37B8yKS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNBleAAoJEBx+YmzsjxAgVo8P/1BH63z/2M4pPep7J0URrGcW
Gbpy1WAeuMqNa3aJoPM27BqpTsOq4Z3R0bkDu0MoX/Ga4H48Yv6feuiOzEwwT0JB
ayQ1NYskoA+RXo3/xsEUqZPtUC4J0s/tERkm7GToEg7PgJ9IqvzhFGFiJ2vuslQA
T+akKoFbdJyWBqbIzrxbaLSrtbmU0tAZix2bxSaCMbExLJm2lDyM71KdPc6N6ZCC
ZUMPnHNldVwvan3cg6PR/8NNc7Y37EaRJaB1tblHH9saSRgeJQrujbtp19dHQ610
x0IM5WBLxyRnyVxkHdim6J5XK16MhTt9bGpBoznGz31NvpmLDXGf7A8OcG40rhLY
Ua+EecrzZ06KbQLEMUIoSRXW3jip05xKWcG0ifUgx6Xp/9aP3266IEIRlJGixQ09
uUVb3eVC1h7kS5TJDNatywN26vJdxyMDSFD/92AeXkykEZBG4cxksoip7lcj5kqC
N/PWEjPUvYiRY+VVy6DMxuLsHPGee2PYhjNm3gqgBQMEY2lkNnl/T2FmM00Q7P2y
V8OX/Ab+Qd2C9LGHe1+oWVttxXk2cr84NJNOufsW1VYC9GFSibfcqUcqynC11z2M
mjAur+kKSMDYgiMWpoj9x3mzDk4LRs+Z77c14n4appkCM3lecYM/JF1/jccckcl4
pMgeE2mP9/+MKIxOFM4q
=wpRj
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--
