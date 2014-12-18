Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaLRLJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:09:05 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:59441 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaLRLJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:09:03 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
Date: Thu, 18 Dec 2014 12:08:58 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.2; x86_64; ; )
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <201412101251.30610@pali> <1420702.eyL56f8lc9@xps13>
In-Reply-To: <1420702.eyL56f8lc9@xps13>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2414730.WOLHplvgZ8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412181208.58969@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2414730.WOLHplvgZ8
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 10 December 2014 14:32:16 Gabriele Mazzotta wrote:
> On Wednesday 10 December 2014 12:51:30 Pali Roh=C3=A1r wrote:
> > On Tuesday 09 December 2014 21:07:01 Pali Roh=C3=A1r wrote:
> > > Now we have autodetection code for fan multiplier and
> > > maximal fan speed so we do not need to have those
> > > constants for each laptop in kernel driver code.
> > >=20
> > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > ---
> > > !!!Please do not apply this patch until all affected
> > > machines will be tested!!!
> > >=20
> > > I tested autodetection code only on Dell Latitude E6440
> > > (where it worked). Other machines which needs to be
> > > tested:
> > >=20
> > > Dell Latitude D520
> > > Dell Latitude E6540
> > > Dell Precision WorkStation 490
> > > Dell Studio
> > > Dell XPS M140 (MXC051)
> > > ---
> >=20
> > Can somebody else with dell laptops test this patch series?
>=20
> i8k_get_fan_nominal_rpm() returns -22 on my XPS13, so nothing
> changed with this patch series applied.
>=20
> Gabriele

So your BIOS cannot report nominal_rpm and because your machine=20
is not in dmi list, all 3 patches do nothing for your machine.

But you need to set multiplier to 1, right?

What about this patch? (on top of 3/3)

=2D-- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -850,6 +850,10 @@ static int __init i8k_probe(void)
 		 */
 		for (fan =3D 0; fan < I8K_FAN_COUNT; ++fan) {
 			i8k_fan_mult[fan] =3D I8K_FAN_DEFAULT_MULT;
+			if (i8k_get_fan_rpm(fan) > I8K_FAN_MAX_RPM) {
+				i8k_fan_mult[fan] =3D 1;
+				continue;
+			}
 			for (val =3D 0; val < 256; ++val) {
 				ret =3D i8k_get_fan_nominal_rpm(fan, val);
 				if (ret > I8K_FAN_MAX_RPM) {

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2414730.WOLHplvgZ8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSStcoACgkQi/DJPQPkQ1LFkQCfacL6chK5y+7x3cIsOGs/Lthz
IuAAnRRH2Ay3+4D69sFJJ07LVHrHsSJj
=YiaA
-----END PGP SIGNATURE-----

--nextPart2414730.WOLHplvgZ8--
