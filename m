Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab3HNTEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:04:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50167 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946Ab3HNTEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:04:36 -0400
Date: Wed, 14 Aug 2013 20:04:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, tobetter@gmail.com, patches@linaro.org
Message-ID: <20130814190410.GO2401@sirena.org.uk>
References: <1376476171-19072-1-git-send-email-tushar.behera@linaro.org>
 <20130814182239.GC23847@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kPJUzav3owWaKxsz"
Content-Disposition: inline
In-Reply-To: <20130814182239.GC23847@kroah.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] usb: misc: usb3503: Force late initialization
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kPJUzav3owWaKxsz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2013 at 11:22:39AM -0700, Greg KH wrote:
> On Wed, Aug 14, 2013 at 03:59:31PM +0530, Tushar Behera wrote:

> > Currently there is no other way to ensure that USB3503 chip is probed
> > after the USB PHY has been initialized, hence the last resort.

> Are you sure that deferred probing doesn't solve this issue?

In order for deferred probing to help the device would need to acquire
some resource from the parent USB controller once active, allowing it to
defer when it fails to get that resource.  Currently there's nothing
there for that and it's not clear that's sane and sensible (it'd be more
obvious for it to be a child of the USB controller since that's what it
really is). =20

We can't just treat it as a PHY (which is the obvious workaroud) since
we do also need to use the built
in PHY in the SoC.

--kPJUzav3owWaKxsz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC9SnAAoJELSic+t+oim9/ZYP/1NZm8LplajSim/kqVu3zcHy
TWh3/jHvomcSv7wBo9XBae8/Bs6d9+qNVEnTWPLH+NXjKIIbB08qPwkaPBoFkXdc
zK25987O+9AWl0ho7jOOW8dm5l6r0ZZrAjV8YkWVWH7FkR2vn//YxQR0xN0oJDO+
bHJ0ShB4XRoRwTq5WvjjCYgzr4H8OkDIYKv9jXFwhXK4+f4TC/G0v9f/Kf16JiPf
9g0tgvMsv+GxWhCRgQuBparX3PFLuHB2sElTPb8s2WEPt8PXSGd4oHVi9L8KBoin
57A7EkRITICETxhSApQtc7Cj1bcRcv33dOn4aXStnNA4c1UmKLVWiVtBRsLtmV8q
9XvIOl7T6IgWha3av4EENVHFRWCX9HucDm62UyLHWDceDP2bD+G/UtOHs+l4slCb
mthlpd9rnxCXnKCKLyNxkSVMrjCsqaZKUpTa6N1M75bTsGyxO7y5Zlcsx3HqUlQj
aXC+IHAvH59LgfWj6F6LfW4EZbv1UEGxtegndWQbrIhPtZOodwuDcYRaH0WIOl3Z
Fh9uBuVvz0DvSWh69/SFL40pzANcPNz7heGSj3F14y6YTwas2SBXpF/nHN5kayet
rKhEDcAjCCxlFOKfwelJ7tk72Kd8UB0SzvgoZxaYeiglvqidKAlX86PMPxiO6P34
vLCXTGfLXH9m+ZD/GH/u
=mf3C
-----END PGP SIGNATURE-----

--kPJUzav3owWaKxsz--
