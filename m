Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaKJPNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:13:18 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56623 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaKJPNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:13:16 -0500
Date: Mon, 10 Nov 2014 15:11:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: linux-spi@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Message-ID: <20141110151140.GA3815@sirena.org.uk>
References: <1415525113-25598-1-git-send-email-b.galvani@gmail.com>
 <1415525113-25598-3-git-send-email-b.galvani@gmail.com>
 <20141109101712.GM2722@sirena.org.uk>
 <20141109225650.GA27950@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8LcJRZYx/wLV/pN5"
Content-Disposition: inline
In-Reply-To: <20141109225650.GA27950@gmail.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] spi: meson: Add support for Amlogic Meson SPIFC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8LcJRZYx/wLV/pN5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 09, 2014 at 11:56:50PM +0100, Beniamino Galvani wrote:
> On Sun, Nov 09, 2014 at 10:17:12AM +0000, Mark Brown wrote:

> > This will busy wait for up to a second, that seems like a long time to
> > busy wait.  We also appear to be using this for the entire duration of
> > the transfer which could be a fairly long time even during normal
> > operation if doing a large transfer such as a firmware download, or if
> > the bus speed is low.

> Yes, probably the timeout value is too long since the maximum length
> of a basic transfer is 64 bytes. Can you suggest a reasonable value?

10ms?  It depends somewhat=20

> > > +	while (done < xfer->len && !ret) {
> > > +		len =3D min_t(int, xfer->len - done, SPIFC_BUFFER_SIZE);
> > > +		ret =3D meson_spifc_txrx(spifc, xfer, done, len,
> > > +				       last_xfer, done + len >=3D xfer->len);
> > > +		done +=3D len;
> > > +	}

> > I noticed that the handling of /CS was done in the spifc_txrx() function
> > - will this do the right thing if the transfer needs to be split for the
> > buffer size?

> It should. When the transfer gets split, CS is kept active for all the
> chunks and the value of CS after that depends on the value of
> cs_change.

Can you be more specific about how that works?  I'm just not seeing the
code that handles this.

> > > +	if (!ret && xfer->delay_usecs)
> > > +		udelay(xfer->delay_usecs);

> > The core will do this for you if you implement this as transfer_one().

> Please correct me if I'm wrong, but I think that transfer_one() can't
> be used in this case. The hardware doesn't support direct manipulation
> of CS and allows only to specify if CS must be kept active after the
> current transfer. So I need to know for each transfer if it's the last
> and this can be achieved only implementing transfer_one_message().

This is already in a function that's operating at the transfer_one()
level, the function is even called transfer_one() and besides it's
clearly not something specific to this hardware so should be factored
out into the core instead of open coded.

--8LcJRZYx/wLV/pN5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUYNWsAAoJECTWi3JdVIfQUbQH/R+WA5WkTd5kxqYoVA77kn/3
CX0Rs9IR+peXFR0ZkVYxQA+Or/APV3EiJ8O6ECf0aiHh4oRv+a5NyZSgELarfOiL
jraGi5PKLWW3Ac2DUL4RFeGHQ6NgAMOMKH+6nMxE/d6IS81zVLzFdQrBTNORzWmQ
cftA0dfZNYDqMGtLYt5zrvC/ZdRiu2qRZgF8AoHy/TWep/xthjPcO2YquXB45DBk
jPDSl8pEe5gSKoSvhG9udCOSpaah40tSoi+45GXqKbzshWmiKtM3CqpuGljFH/FG
dJLOUog401k4j3DYFX6oE3MUmJ9qPBCySBnrCrYQOvjxf4DAF7rHJK1+WRUfdrs=
=X4Go
-----END PGP SIGNATURE-----

--8LcJRZYx/wLV/pN5--
