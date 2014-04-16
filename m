Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaDPR3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:29:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35260 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaDPR26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:28:58 -0400
Date: Wed, 16 Apr 2014 18:28:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Jane Wan <Jane.Wan@gainspeed.com>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "Emilian.Medve@Freescale.com" <Emilian.Medve@Freescale.com>,
        "kenth.eriksson@transmode.com" <kenth.eriksson@transmode.com>,
        "thomas.de.schampheleire@gmail.com" 
	<thomas.de.schampheleire@gmail.com>,
        "b48286@freescale.com" <b48286@Freescale.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>, "sr@denx.de" <sr@denx.de>,
        Insop Song <Insop.Song@gainspeed.com>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Message-ID: <20140416172830.GV12304@sirena.org.uk>
References: <1397328516-13260-1-git-send-email-Jane.Wan@gainspeed.com>
 <1397328516-13260-2-git-send-email-Jane.Wan@gainspeed.com>
 <20140414205547.GI25182@sirena.org.uk>
 <6f2c800fbba74470a6a49903b34e7796@SN2PR07MB064.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="grb+5QKeMfpTKipq"
Content-Disposition: inline
In-Reply-To: <6f2c800fbba74470a6a49903b34e7796@SN2PR07MB064.namprd07.prod.outlook.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Configure FSL eSPI CSBEF, CSAFT, and whether to send all
 received data to user
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--grb+5QKeMfpTKipq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 16, 2014 at 04:39:47PM +0000, Jane Wan wrote:
> On Mon, Apr 14, 2014 at 09:51:56PM +0100, Mark Brown wrote:

> > > +		if (spi_raw_rxdata_to_user[m->spi->chip_select])
> > > +			espi_trans->len =3D n_tx;
> > > +		else
> > > +			espi_trans->len =3D trans_len + n_tx;

> > Why is there even an option for the buggy behaviour?

> We have three devices attached to the FSL eSPI interface, with chip selec=
t (CS)=20
> 0-2. The device driver for the device at CS #2 requires to know all the d=
ata that=20
> the slave device put on MISO.  But the device drivers for the other two d=
evices=20
> (at CS #0 and #1) work with the existing FSL eSPI driver.  The device at =
CS #0 is=20
> Micron n25q512a compatible.

> We make the FSL eSPI driver configurable through device tree.  If we make=
 a fix=20
> without the DT option, the fix will break other device drivers working wi=
th the=20
> existing FSL eSPI driver.

> Could this still be considered as a solution?  If this is ok, I can send =
it as a separate=20
> patch.  Otherwise, we will look if this driver can be modified without DT=
 option.

No, this is completely unaceptable.  The drivers relying on the buggy
behaviour are broken and must be fixed.  The whole point of DT is to
describe the hardware, not to allow the OS to implement workarounds for
itself.

--grb+5QKeMfpTKipq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTr27AAoJELSic+t+oim94mcP/3nnTHvDU/iRSANZlP3KN5El
d4Eof9WtT8Pe/3qv2JSGT8yU9rO9NtVT8SsGJcRanP/Rh3tOoDZQdR6rR6Zo26v/
bt1TXsdG/C75iEtkF417f3ZaxvGQXDNGkSV6osUjpXXbD6VTuXOSaPIz+oi3BlH3
TD7EfjW4y7IEENEsRisLrA/mHak3oapQCnyvMUE13//G/U1R1wjJrBcqDh7r8nhG
/cS1MmrKmr9p55u/CBHtgNsibpTD7OD/ujg8l3u2dZmfPKkA/pohi9pxOLfMYkQ7
2+RKUHZARV/AHrBRlMuK15wQ0gYmo12AVVdQkErdh6S0cBXKSDF2wFa6wNaInljj
rtuqVHKlHu37JWdpyXCz+QRrmEl4ZjOTJxelxK/m71mAf4lhSqtyJRmNR7QWZOaR
+RgXtj7KTN91WgOlFcL911L7CbaVGcEPNgP8IfC+nJ5kZ96piSsYIYQET3uSgI7Z
i2uv4/7gs7GCJwnOWDrCRq4UenTpio2desY03YTiR27IHeE0rr7BEFE5xUeqetE2
YEVjalnZ7kxKOuEsnk5Ftwai1Yy0D4QIPxUQDFjuBqkxqk3LgDrpi6ZOVIp8ma+v
n7Yo3irZd4KqTakHwjStd5rocp6AEthu1WWfkjDsltU6tYn0NeqW+TFMoqMxdK/X
oqjZXZpDiGLSaQww3IiK
=FQSI
-----END PGP SIGNATURE-----

--grb+5QKeMfpTKipq--
