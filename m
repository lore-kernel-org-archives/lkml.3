Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaAZUw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 15:52:26 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59741 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaAZUwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 15:52:25 -0500
Date: Sun, 26 Jan 2014 20:52:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <khali@linux-fr.org>, LM Sensors <lm-sensors@lm-sensors.org>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Wei Ni <wni@nvidia.com>
Message-ID: <20140126205216.GJ11727@sirena.org.uk>
References: <52E561D0.4040308@roeck-us.net>
 <20140126211357.6fa68909@endymion.delvare>
 <52E573B6.9040903@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XAtoqsFAXbjZCl7Z"
Content-Disposition: inline
In-Reply-To: <52E573B6.9040903@roeck-us.net>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: lm90 driver no longer working on PCs in 3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XAtoqsFAXbjZCl7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 26, 2014 at 12:44:38PM -0800, Guenter Roeck wrote:
> On 01/26/2014 12:13 PM, Jean Delvare wrote:

> >Me, I really don't know. I seem to remember I tested Wei's patch set on
> >an emulated ADM1032 chip and it was working fine. So maybe it depends
> >on the kernel configuration, or something changed on the regulator side
> >meanwhile.

> The regulator code changed with 3.13; the dummy regulator no longer exist=
s,
> and the functionality it provided is supposed to be handled automatically.
> But that only really works on devicetree based systems and otherwise retu=
rns
> -EPROBE_DEFER as mentioned above.

CONFIG_REGULATOR_DUMMY should never have been used in production, it was
a debug tool to help bringup but it broke things as often as it fixed
them particularly with init ordering which is why it generated a warning
when it was used. =20

The dummy driver is still there, if you're doing bringup you can hack it
in still or if you genuniely used it then specify that full constraints
are provided like the changelog says (and as I've previously said).

> Another possible fix would be to have the regulator core return -ENODEV
> instead of -EPROBE_DEFER on non-dt systems. No idea if this would be acce=
ptable
> or even feasible.

No, this would introduce breakage due to init ordering.

--XAtoqsFAXbjZCl7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5XV8AAoJELSic+t+oim9pjIP+wcYrZ6mIBF3B8X6h3HJxqi8
soWuCkNA7goN+ntsokGLR1PnV4+b2ORl8O0athS9WDlKFuuSt1VkBo9sP+mxNX15
JNdMsQVtOWJEffDMtWqM+xDGExvOOZF3irt+GR+S461chwKyM4uoRngiMhYMB21Q
jF+njPZXoqs1Whn+Pagm68xzKCWoRNXGm4QkBRWBtmBwgtLVFZ/o7duku5zi6Udw
nnWNcXoEXQxyy2vK3X1VWW4K0LKDtTtY6XR2ypWUWJuKnipKR8LpAYtAeFNUaXVy
mXqXPz1/4tszu4l2X599otfgR1L3SHZRwFlaWLJX3GejvNawsCOYxkAh1KxPTLe0
ILqSnq4Wt54zM6X410OpYV+VBhgRDDYGJz5ZozVaQuhup+bRLQh2MhUjUUk2k+v9
oc6kHhF0JlKZp24cAzMahNSs889SmGRnm9+eOCOLiXmTzmvT4JCe8e06bbJdxqFc
5bCTs511aVrfRuN9Y/1XaTe86EhbSTxLGila4YwADKQkfNW/J6yJWxsgBDSt1caH
Nre8x52v6L/iLE8rRQoJaHCr6MGWzbubMEQfb8FzsYQr3/50LiGh2Ponz/MTcKpE
PrlksCEv8Du6o6fOK05MMzUmFE9+Y/KMenjHeBc/W4dSUqdmiJ76FCFwGiP7CWnt
8tOWHTHG5xJO2IBVTejX
=WgQg
-----END PGP SIGNATURE-----

--XAtoqsFAXbjZCl7Z--
