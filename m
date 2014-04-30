Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946005AbaD3SKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 14:10:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48676 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752159AbaD3SKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 14:10:17 -0400
Date: Wed, 30 Apr 2014 11:06:09 -0700
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH] spi: Force the registration of the spidev devices
Message-ID: <20140430180609.GC3000@lukather>
References: <1398705774-12361-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140429183758.GH15125@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
Content-Disposition: inline
In-Reply-To: <20140429183758.GH15125@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4zI0WCX1RcnW9Hbu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark

On Tue, Apr 29, 2014 at 11:37:58AM -0700, Mark Brown wrote:
> On Mon, Apr 28, 2014 at 10:22:54AM -0700, Maxime Ripard wrote:
>=20
> > spidev device registration has always been a controversial subject
> > since the move to DT.
>=20
> Why can we not handle this by using sysfs to bind spidev to the
> device?

I just tried it, and apparently, you can't really use this, since spi
devices are created from the device tree (or ACPI) whenever the master
registers.

As such, you still need a DT node for every spidev device you might
want to use.

It doesn't really work either for a device that would be bound to a
driver, that you unbind, and then try to bind to spidev instead. It
looks like the device is released whenever you unbind it, so you can't
really use it afterwards.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTYTuRAAoJEBx+YmzsjxAgyYQP/19p0oazTKpRYs8BASsvyuwN
bxUYEelpHBzoEpEbtvwbIsDNJ41JjOuqDCV5SKKO3vdEY1cxuiEB2Xnv1Ke4nXyX
/StujpY39tY1F8G26tXI4cdENF7AVoi3suB7g0FrUh2VMAqI0ROZyufnejFe9SSB
GIQyaCogSTYWTtb/kyQRldgHCG271zMJmN6PE3Pgph66AxHBSTXIEhT7Uw8VdGB2
a0dWB93DPbWJ6jyGE7fKV9sjGSDmW+FcF1FEfAqzK3emNItW+ss0RHxvESFLj1/l
Rfpx51JgDCrMVna+wAk/1m3G4E7MnywQPCd2ZXi4LjUiN4zmz9oUIef6/lZ/OqUy
F5LVxELfg3HAKmQroA+unyjrtVuvl/o+oWyrnRi5frlSiRDxwUxsgfLzZA3mjln8
9bG2pmzEvfE7ggY74JNqoD3vwkCZQJYyVErBXC/IFQEKAOrA4Lngy6a2ajPsk+Ei
5HWAy50iCUmfuIkYg9xTg63juTyfbUya+IumxxVVyKdldSNkOyEind8haNq56/fL
nFWwTuOeeaR/KxHFWzmAhQHolC5hZm9av5bi21AVd9qPi+w1zV4wsqdBnQsKeFS/
Rts2I4aTnu1AaDVhP2Y1KIGkMvfanWtzG1b8if5fDqni1s/rSha5hgyWR7HD97C2
hhkn5KPqJJx8mle+J19v
=IZlz
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--
