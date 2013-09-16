Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3IPICq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:02:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34304 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab3IPICo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:02:44 -0400
Date: Mon, 16 Sep 2013 18:02:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why does test_bit() take a volatile addr?
Message-Id: <20130916180231.1570f7c5cebab599cef5b4bb@canb.auug.org.au>
In-Reply-To: <20130916072603.GA11007@redhat.com>
References: <87ioy11k8s.fsf@rustcorp.com.au>
	<20130916165344.144f0d0f1b58111f1c8c87cc@canb.auug.org.au>
	<20130916072603.GA11007@redhat.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Sep_2013_18_02_31_+1000_znUmxkLdG_xA4WSy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Sep_2013_18_02_31_+1000_znUmxkLdG_xA4WSy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

On Mon, 16 Sep 2013 10:26:03 +0300 "Michael S. Tsirkin" <mst@redhat.com> wr=
ote:
>
> On Mon, Sep 16, 2013 at 04:53:44PM +1000, Stephen Rothwell wrote:
> >=20
> > On Mon, 16 Sep 2013 13:38:35 +0930 Rusty Russell <rusty@rustcorp.com.au=
> wrote:
> > >
> > > Predates git, does anyone remember the rationale?
> > >=20
> > > ie:
> > >         int test_bit(int nr, const volatile unsigned long *addr)
> >=20
> > Because we sometimes pass volatile pointers to it and gcc will complain
> > if you pass a volatile to a non volatile  (I think).
>=20
> Where are these? I did git grep -W test_bit and looked for volatile,
> couldn't find anything.

OK, so it was a bit of a guess.  Have you really checked the type of
every address passed to every call of test_bit()?

Second guess:  we wanted to make the test_bit access volatile (as opposed
to the datatypes of the objects being tested) so that things like

	while (testbit(bit, addr)) {
		do_very_little();
	}

don't get over optimised (since we are operating in a very threaded
environment that the compiler not might expect).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__16_Sep_2013_18_02_31_+1000_znUmxkLdG_xA4WSy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSNrscAAoJEECxmPOUX5FE5PIP/2hAsnGU76wd3St+ktVnP8k+
BJYBdiMJCwMqm0YWBGtJrcuIaViOdelgvyXFjSvOal/54xI69HBWn9CgxISpDAZ9
f/Rery1+OsvnKMNMvTsyBjfCtv59bAibyjBi95lTYbcUJzk8+fF8jf5RkmmjpaWq
B2LZyICgzNZMexSpQ3wnrn9JOHx85grTV9E7dDD2brtTo10MG2IXUvrTYTT0ur8l
DDrhr3NWcST1cmsTsKrQGrQPoGINRpd98WpJJrzg/TdHm81Mf9EOF0RDC/TEppel
JWFxRtUARZijd45Y6MUbpQlWJ7zlcW0pgmjqakxrwvidSIgeLvJk8rVJ/C2pX3cw
sJ7YS4dfly4cdW3PGALjHPainRutJiQJM3TtSILuqfNCd0XH8i72OHMP0dupJB1n
j5Adzo66w+YlUVzB6T3TKe5B7ShBXR7WBEiejfuHPY03Dalg2AZTp4ZlIqUmyAcz
FiYUZmu49aHtSoYPK2NiWGMCxXjv1dN8w6ntX0CzQ0LQMGvBbIySJQLLsbKe7awW
zX3niVoqkw636oFhRS13pHDKOM0Eo7HU5cyg4PEIfMJ2jPYzc5EPDYCCPQhqRTMW
iwclrMK6LnBWl8fFFIB7Rrfk2jXsOn9TNBGITXbCBufWTH6ZOYPznlexTHUJxRfw
KQ5yT7V3opRXZ1cHyNsd
=ZbOF
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Sep_2013_18_02_31_+1000_znUmxkLdG_xA4WSy--
