Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaKEBL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 20:11:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:58175 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaKEBL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 20:11:28 -0500
Date: Wed, 5 Nov 2014 02:11:22 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141105011122.GA30622@earth.universe>
References: <20141104205117.GA17606@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <20141104205117.GA17606@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

On Tue, Nov 04, 2014 at 09:51:17PM +0100, Pavel Machek wrote:
> I'd like to test a modem (and eventually to get it to work :-) ) on
> n900. So far I found:
>=20
> http://lwn.net/Articles/592485/
>=20
> It says:
>=20
> # supported. Testing the patchset with ofono works like this:
> #=20
> #  # provide cmt device for ofono
> #  ln -sf /sys/bus/hsi/n900-modem /dev/cmt
>=20
> [...]
>
> That seemed to match, so I symlinked it.

looks ok. You should have the following files:

/dev/cmt/cmt_apeslpx
/dev/cmt/cmt_bsi
/dev/cmt/cmt_en
/dev/cmt/cmt_rst_rq
/dev/cmt/cmt_rst

Apart from that the kernel should be provide a phonet0
network device.

> #  # start ofono
> #  ofono --nodetach --debug
>=20
> It it a typo and it wants ofonod?

yes.

> root@n900:~# ofonod --nodetach --debug &
> [1] 3552

no output from ofono?

> root@n900:~# mdbus2 -s org.ofono /n900_0 xyz
> [ERR]: There is no method with name xyz on path /n900_0!
>
> [...]
>=20
> Any ideas?

call mdbus2 with fewer arguments to see what is available on the
bus:

mdbus2 -s                      =3D> list all system services
mdbus2 -s org.ofono            =3D> list all ofono objects
mdbus2 -s org.ofono /n900_0    =3D> list all methods from n900 object

-- Sebastian

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBCgAGBQJUWXk6AAoJENju1/PIO/qaklgP9i+VugJAU7KGGylW2O0AVHE9
5fbpP8R+GimhB8BUiTybn9Et7A++7r4yJK67nIN2u20VmQNy1zyal4TiusjpipIS
flYKlIuCiGrhRLZ3+5U73FpJK5tAWwiPmKoNz5ttT2LgpLpS24MNTAxscIS8OnMF
v+1YF63ZvlDtYzf5JF/AK1trJWkUqsexhhtyF9hRLucqIrtJ/Ac6dwVspasTyJya
n7WdJls/DuUeRwWLkzdYT7pWUl1v22P4OwvvuKoSdA1aY/b7/WiYYJC65gDk8jk2
HkFG6h742Da1l7TCh6g/si5lkNmJ2ivwbo3pMdB0DO6IZMGAHA/xxaEHkEV0KTJ4
xcjqEPf25uXWJefr9/Dzo+PgAtvZSHrP0YwLF7K9XEDLPlQdgouHTUsjg5p0z3cj
J/mT1Ei2PT6vO+qS7WryOGHAke5VcH/NvG2B61G3t3Yx6CnKuY1mfjNOK8517pfP
wmHku5HzUQkm77E1OTaJ8f44y3Wq1eQsg3C/7FV3YuL+/EfOYppcrrsPaeL2S8iy
+6JMTQr6z3BlBNv1hM/MW4PoHf5nD3Ssc5G55+rUC48QL5hvXE4OeeE3sbDiYWlN
pLyX7xWli6QXecMXnuXHeDDqyA/99zsw6NxWpca7Q4bYLLz1k4JqE4DPbVMIy48s
0waAjfL0yHWxIKuSiuU=
=9Zyu
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
