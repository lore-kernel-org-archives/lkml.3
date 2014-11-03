Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaKCToE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:44:04 -0500
Received: from sauhun.de ([89.238.76.85]:47343 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbaKCToB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:44:01 -0500
Date: Mon, 3 Nov 2014 20:45:06 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [RFC 0/2] drivers: spi/i2c: account completions as iowait
Message-ID: <20141103194506.GB1449@katana>
References: <1414936689-2707-1-git-send-email-wsa@the-dreams.de>
 <20141103130222.1c53fa39@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
In-Reply-To: <20141103130222.1c53fa39@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > However, researching the net, users currently interpret iowait entirely=
 as
> > blkio wait. Furthermore, io_schedule() calls delayacct_blkio_{start|end=
}() which
> > worked fine for my tests with I2C but might show that iowait was really=
 meant as
> > blkiowait? So, should other subsystems use it?
>=20
> I don't think so. The traditional Unix use of I/O wait is block I/O wait,
> in order to account for paging/swapping in "uptime".

I see.

> The other problem is that if you change the way it behaves you'll get
> lots of hate mail from people running server farms as all their load
> balancing and cluster management changes behaviour, plus baffled users
> wondering why their system is now busy and it wasn't in the last release.

I was fearing something like that. On the other hand, it might have been
more correct. That's why I asked.

> The other question you have to solve is that people are adding i2c and
> SPI slave support both in Android space and now perhaps upstream. How do
> you I/O account those transactions ?

I implemented I2C slave support for upstream [1] and I don't think it
needs to be acocunted. While a master transaction gets kicked off and
then waits for success using a completion, slave support is more like
serving an interrupt and then getting or putting a byte immediately.

Thanks for your answers, I'll simply keep I2C away from iowait.

   Wolfram

[1] http://thread.gmane.org/gmane.linux.kernel/1783295


--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV9tCAAoJEBQN5MwUoCm2r0MP/RpOv/f1fId2+ZltT4H7ws2f
e2y/DMaK/Fp3/11p18lPd/l4VlYOFcCMsT8qTuRYyodDn9NZU3lUE2QWZAD+NXNy
TJMqhT9D2lWn9gTQ4wzgxSdQ6XduEyhpDEVxZqK9PMjU36gXwfc2fE4JBz9oZ6vs
tAXHnZQMBqIJKrH+puoPrdk3q1CPpy2PaQKrJ/OzqlLWJ0bAYx4gm73S2Ia02GRN
eCz2oLYpQ32B/g3uIhsw9/GS7DFw5poLoG97s3a9TL5yisJJAMHz+IrZoz+dpiXj
mQwFBZnC2GLrX6eXsG/WgDPtKhgXOQHLNQWbMSuVNTiojifnTge0Vu+JXC6Alc8t
lKcboppvH+4JjV3fWwVrx6lo6xKWix5/KPEva95DxRWXXCdBJTtCx/xIBw2sKC4X
BJY1CMkCnnoTjbpPy60PkEGKLeE49hM7oMsbDiDrCrrv2IA8qJ1qaGHZM6yIeMgk
zM3w2ZPyAeBfKGp47B3wijmpLJl5mpYNxE28L1iaxlmPSwqaJpexVCcEvZseLLnF
ykGFhajbQIb15YReUoS4wbn0eUwpK/iejDHaTQ7F001ZC6Uz1mTEkAvYYGyhAOiv
FAh46TIHS6kHVWpKXaCu9CRaufjQPdyzgGLp21ejqHCYZdphhVIRw9ofPoUy6OdP
SEc3NU53/PZYog7Ai2qv
=tx1S
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
