Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab3C1OLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:11:41 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:44089 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab3C1OLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:11:40 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: Driver lis3lv02d_i2c not working on Nokia RX-51
Date: Thu, 28 Mar 2013 15:11:34 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.1; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>
References: <201302170046.26569@pali> <201303261602.40219@pali> <20130326205319.GK14155@blackmetal.musicnaut.iki.fi>
In-Reply-To: <20130326205319.GK14155@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1466540.IZWCsGrCpG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201303281511.35101@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1466540.IZWCsGrCpG
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 26 March 2013 21:53:19 Aaro Koskinen wrote:
> Hi,
>=20
> On Tue, Mar 26, 2013 at 04:02:39PM +0100, Pali Roh=C3=A1r wrote:
> > CCing Aaro and Tony. Look at this thread on:
> > https://lkml.org/lkml/2013/2/16/152
> >=20
> > What do you think how to fix this problem? I do not know
> > about any HW regulator for n900 accelerometer and possible
> > solutions could be revert that commit or adding fake
> > regulator to board code...
>=20
> I think the following should work:
>=20
> ...
>=20
> From: Aaro Koskinen <aaro.koskinen@iki.fi>
> Date: Tue, 26 Mar 2013 21:34:22 +0200
> Subject: [PATCH] OMAP: RX-51: add missing regulator supply
> definitions for lis3lv02d
>=20
> Add missing regulator definitions for lis3lv02d accelerometer.
> Fixes the following probe issue:
>=20
> [   57.737518] lis3lv02d_i2c 3-001d: Failed to get supply
> 'Vdd': -517 [   57.747100] i2c 3-001d: Driver lis3lv02d_i2c
> requests probe deferral
>=20
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> ---
>  arch/arm/mach-omap2/board-rx51-peripherals.c |    4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c
> b/arch/arm/mach-omap2/board-rx51-peripherals.c index
> 3a077df..1a88467 100644
> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@ -547,12 +547,16 @@ static struct regulator_consumer_supply
> rx51_vio_supplies[] =3D { REGULATOR_SUPPLY("DVDD", "2-0019"),
>  	/* Si4713 IO supply */
>  	REGULATOR_SUPPLY("vio", "2-0063"),
> +	/* lis3lv02d */
> +	REGULATOR_SUPPLY("Vdd_IO", "3-001d"),
>  };
>=20
>  static struct regulator_consumer_supply
> rx51_vaux1_consumers[] =3D { REGULATOR_SUPPLY("vdds_sdi",
> "omapdss"),
>  	/* Si4713 supply */
>  	REGULATOR_SUPPLY("vdd", "2-0063"),
> +	/* lis3lv02d */
> +	REGULATOR_SUPPLY("Vdd", "3-001d"),
>  };
>=20
>  static struct regulator_init_data rx51_vaux1 =3D {

Hi, on #maemo IRC channel we have found some accelerometer=20
regulators and I wrote this patch which is working fine with 3.8:

@@ -728,12 +730,16 @@ static struct regulator_consumer_supply=20
rx51_vio_supplies[] =3D {
 	REGULATOR_SUPPLY("DVDD", "2-0019"),
 	/* Si4713 IO supply */
 	REGULATOR_SUPPLY("vio", "2-0063"),
+	/* lis3lv02d IO supply */
+	REGULATOR_SUPPLY("Vdd_IO", "3-001d"),
 };
=20
 static struct regulator_consumer_supply rx51_vaux1_consumers[] =3D=20
{
 	REGULATOR_SUPPLY("vdds_sdi", "omapdss"),
 	/* Si4713 supply */
 	REGULATOR_SUPPLY("vdd", "2-0063"),
+	/* lis3lv02d supply */
+	REGULATOR_SUPPLY("Vdd", "3-001d"),
 };
=20
 static struct regulator_init_data rx51_vaux1 =3D {

Now I see that patch is same as Aaro's :-) so please include it.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1466540.IZWCsGrCpG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFUT5YACgkQi/DJPQPkQ1LqRQCbBXPrjp9wtdiLstQkTEMt53AT
ymwAoILuWVIrYLhTV473ASPh9K3YOvyh
=ieDT
-----END PGP SIGNATURE-----

--nextPart1466540.IZWCsGrCpG--
