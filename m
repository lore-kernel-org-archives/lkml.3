Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab3LFMJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:09:36 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53058 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab3LFMJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:09:34 -0500
Date: Fri, 6 Dec 2013 12:09:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Jingoo Han <jg1.han@samsung.com>, "'Liam Girdwood'" <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, "'Axel Lin'" <axel.lin@ingics.com>
Message-ID: <20131206120907.GE29268@sirena.org.uk>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
 <000d01cef252$4680cf90$d3826eb0$%han@samsung.com>
 <201312061012.05535.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fc4/uDQsB6b9dq2q"
Content-Disposition: inline
In-Reply-To: <201312061012.05535.heiko@sntech.de>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/6] regulator: gpio-regulator: use
 devm_regulator_register()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fc4/uDQsB6b9dq2q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 06, 2013 at 10:12:05AM +0100, Heiko St=FCbner wrote:

> I'm not this firm in the core driver/device behaviour, but when looking a=
t=20
> __device_release_driver I see that the remove callback runs before=20
> devres_release_all, which would effectively free the gpios before the=20
> regulator gets unregistered - is this racy with a regulator change at the=
 same=20
> time?

Yes, the rest of the driver really needs to be converted to devm_ at the
same time.

--Fc4/uDQsB6b9dq2q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSob5gAAoJELSic+t+oim9hukP/jI2sMFd0wJsej+o/9ky+P5e
26aQFiT7aVxqJO+cyhR0YLqXiMmNFg4rRkv0zH7SdqhOoliELg64mXkdVHjE/2k/
9XI7Zd0a2bhs13sZKHTe7D87ARBOioTFRSKk1n473Rk08icQYJHCGwRGeq4m+31o
+FCaFr8F1+jTlW7UqWsiVx3s/MqL5UbIoOnm1iVlrNiYlsujkFRFt9ytkfdXXiAv
M1TvghXnZmeifRlcgjQNFePzTh0nAhDMzsEaMXQBUJ9MUr/x82dJhz8AuN9zIDHm
jZ419/YCNF7MgKSVPmZo+MQLL9H8L9lhhnasoMGmqEnQHB6+1/QI7un0txlIIT2G
9aLwlG3prpyKvVmmP2jk+HvNxM5Dr0XeXHOYJNWn1rIEpAyKUpiMblVBmaqxoa+S
+cyK2UVWXvEdEkbAkNBipax0MmYYKuNtx/B4bNGFgxjFTlWFfQx+HxrQSLbpPkMP
nD8DIm2g/8F1AHep1Yc3HbisKcjOxb3wlNldrxmm5MhSKNq3fRNsH+yd1d2sxfD8
snkRXQ1IJjIVrIpuSBf0lesCz+2fHlUmkmYjNxw4izFaKbVpkppntM4ZaIGcQ8kE
ZKwfqdoGhAD7Roor/axrLKZXEBagfwiwRz7qJLtE+4fHyDNFJBi1/kZ46eoIP+he
t/7wkHa5mOtOYb0Be5Mc
=aS24
-----END PGP SIGNATURE-----

--Fc4/uDQsB6b9dq2q--
