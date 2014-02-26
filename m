Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaBZNZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:25:36 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:33938 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaBZNZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:25:34 -0500
Date: Wed, 26 Feb 2014 14:25:30 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
Subject: Re: [PATCH] backlight: add PWM dependencies
Message-ID: <20140226132529.GC29779@ulmo.nvidia.com>
References: <1391518634-6472-1-git-send-email-linus.walleij@linaro.org>
 <20140210104032.GB20143@ulmo.nvidia.com>
 <CACRpkdb1T1GCqEpy9=fPp4hYQErLYiQqJezrFhoS3x1MU=0S9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VywGB/WGlW4DM4P8"
Content-Disposition: inline
In-Reply-To: <CACRpkdb1T1GCqEpy9=fPp4hYQErLYiQqJezrFhoS3x1MU=0S9g@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VywGB/WGlW4DM4P8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 10, 2014 at 12:09:29PM +0100, Linus Walleij wrote:
> On Mon, Feb 10, 2014 at 11:40 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
>=20
> > it seems like at least BACKLIGHT_LP8788 is missing a corresponding
> > dependency as well.
> >
> > I have applied Sascha's patch to remove the obsolete HAVE_PWM symbol,
> > and this will fix at least the build issues. However it will also cause
> > the driver to fail at runtime because the pwm_*() functions won't work.
>=20
> So it definately needs that API, not just stubs.
>=20
> But isn't it proper for Kconfig to allow you to break things
> like that by configuring out stuff and have stubs come in?
>=20
> I'm a bit torn here.

After thinking about this some more, I've come to the conclusion that
the drivers should have the dependency. Kconfig should make sure that
the resulting drivers work.

If somebody wanted to knowingly build this driver with a configuration
that won't work at runtime, then they should be using COMPILE_TEST
instead.

So I'm leaning towards applying this patch if there are no objections.

Thierry

--VywGB/WGlW4DM4P8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDetJAAoJEN0jrNd/PrOh4coP/Als6SaArd/CT4bpdFqdKj3Z
QjwO4TnR8rKVpdgscGHGJmvdIJMvGP1euoYIFtgpOw4BccZfPJtYVNVLWWS+ovby
jCmcj66wa++tsDsZWwVVVXOOxyBDTKzPuIBnAK3SQar4cntzufasiBqIjAchSx4l
uj089YlQ99zq7PD0lTs4tzmkKqDd1UqkwqUZrjOmHdfQDSikjBv4bjjrmYCfbFcl
2LLNcpRb7DnlYW5oKWwV9XC45LZ0YdXooVsoYrYDqqGXsHMcnxx3d6TTx8eMCshU
UiyzNrNcvPaJx78xNhVagoQ+P9GididRqtnoahofgLmPYZmtZK9rOWwmoFLFLZeA
+q3UTCW+iZou5YcXy0Zep6qrLRd9PAf5BcxEYf+gTVpZINwKXGY8W5GkVYZWnMKG
/AAfF/PeUUm3wtfgN5zhfR1WwWdaHTyV61waI82c0hR2q2TiHxsQM/w6HF50HpD/
QBpjgZrtVMbrvE2MfcSZKQnBmuJKOC5PZtcc48pGlZ2bWn2cbog0oo1k2zwN5qrd
h3MnIwAbZRBxJJ4/aTxhPerBhwHGB6nkLnKK1THiBUUvXyLoqk8uph8XRFOAfY9J
DTcLSXNUeuX3TPBdPx158VdiYGS1OZKxZ2GUGWcSNCNRgpdg5vlnP79jaZaMatsJ
5O7fgf54k4kc5YN7zwc8
=F3kA
-----END PGP SIGNATURE-----

--VywGB/WGlW4DM4P8--
