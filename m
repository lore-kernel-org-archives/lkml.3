Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbbAVS5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:57:19 -0500
Received: from sauhun.de ([89.238.76.85]:42162 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbbAVS5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:57:16 -0500
Date: Thu, 22 Jan 2015 19:57:12 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Korsgaard <peter@korsgaard.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-ocores: add common clock support
Message-ID: <20150122185711.GA14880@katana>
References: <1421230899-7843-1-git-send-email-jcmvbkbc@gmail.com>
 <20150122144522.GF3413@katana>
 <CAMo8Bf+XJY_bY+OB2i_SZQmAavwERG39BR8FVj202V-E3UidPg@mail.gmail.com>
 <20150122150717.GJ3413@katana>
 <87wq4e7jqy.fsf@dell.be.48ers.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <87wq4e7jqy.fsf@dell.be.48ers.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2015 at 07:28:21PM +0100, Peter Korsgaard wrote:
> >>>>> "Wolfram" =3D=3D Wolfram Sang <wsa@the-dreams.de> writes:
>=20
>  >> The clock here is not the i2c bus clock, but the clock input of the
>=20
>  > Yes, what I would expect from a clk-property :)
>=20
>  >> controller. The function ocores_init initializes the prescaler regist=
er of
>  >> the controller so that the bus clock equals 100kHz (internal clock
>  >> runs at 500kHz):
>=20
>  > 'clock-frequency' usually describes the I2C bus speed. So, for ocores,
>  > it describes speed of the clock for the controller? That would be
>  > ouch...
>=20
> Indeed :/

Oh well, then let's fix this...

> Looking back in the history, the device tree patch originally used a
> custom "clock_khz" property until some guy told him to use
> clock-frequency ;)

I have sympathy for that guy. Very uncommon to specify IP core clocks
specifically in a dts ;)

My suggestion is:

1) if there is a clk node:
	- we get the clock rate via clock framework
	- "clock-frequency" is describing the bus speed as usual (Note
	  that parsing here can be as simple as checking for 100kHz only.
	  Although a seperate patch could probably easily add support for
	  other bus speeds to)

2?) a new binding is present to specify the IP clock speed:
	- is this needed? is somebody using the driver without CCF?
	- if so, the new binding is parsed and evaluated
	- I couldn't find an existing binding to specify a clock speed.
	  Please have a look, too. Otherwise we need to introduce sth
	  like "opencores,ip-clock-khz" probably.
	- "clock-frequency" is describing the bus speed as usual

3) only "clock-frequency" is present:
	- we keep the current behaviour to be backwards compatible.
	- driver should emit a warning to convert to new style
	- must be marked deprecated everywhere

The documentation should be updated accordingly.

Thoughts?


--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwUgHAAoJEBQN5MwUoCm2DkcP/0/tPVtu13VWC+29iIkVL4VE
2nRSN4al1xsjts9a37KA81IDy70DGFG6dNd9ektSLX38ktZs7ISMA0QduHYRnxll
0JB9ZgMqecQU7zhjvzC0KzxH6AFO02k5GMkDSuOWBPtOA1qZ9M9uADuA5UIC24ba
rPUY74Y35HZUHmnZ4N+rzBUJ3mRjrJmylTd/6vGdvLnG74IDK22doVMm6sPx2zeC
0Xv87QoP9Wekm4W8/aLUwZhZHE1QdEkyuH0lzUvuUyhNWg/x5/4Q0OA+37uGBInE
y+97Q0wKQeQKjZpy/VK5yczBB8gcIsj4DHnKL1XHFM0GMTRR3GaH3DY3hYLoAgj+
4OCrgBA3CAzymB+DNrQDtA6Uiu6NOynnVU2VfwOZKv2TWEQNS6dkjmiw2rbK3qWE
Rj286M3XfiL5ji6HXElvddKjoUMu9LU7maNbYRvpQPLXxnwUkGyv593+XfPHALpC
7qbbNPf3+mQm2OylO/kUYz+QSIqhN3tQEJ6rS2f1mLKP+d8vA4qaiSE8vjRZIiZ0
tnVTO5O4/WTfwY+5B7B/Aw4ohx3dYUVFX1mwACtQqTRepM+F6UsyDTJtt45Dq9A4
rUbWnRnC1fYsXJcoCqOgIobBZ9P6y3IqOC7z3ttZbi8fn6Ts8eF6uQpynrx08QEi
vclCfcqXxifa3+t4LwYN
=GtrP
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
