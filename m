Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbaAHSAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:00:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48838 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAHSAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:00:44 -0500
Date: Wed, 8 Jan 2014 18:00:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20140108180030.GR31886@sirena.org.uk>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
 <1387815830-8794-8-git-send-email-pawel.moll@arm.com>
 <20131224121912.GX30815@sirena.org.uk>
 <1389202297.23721.33.camel@hornet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rbg6pv1WwQpmCPiZ"
Content-Disposition: inline
In-Reply-To: <1389202297.23721.33.camel@hornet>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 07/18] regmap: debugfs: Always create "registers" &
 "access" files
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rbg6pv1WwQpmCPiZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 08, 2014 at 05:31:37PM +0000, Pawel Moll wrote:
> On Tue, 2013-12-24 at 12:19 +0000, Mark Brown wrote:

> > No, we need to find a better way of doing this such as checking to see
> > if register zero is accessible in some way.  We want to avoid having
> > those files if there's no way of populating them since this is useful
> > information for tooling.

> Something like this then?

> diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/r=
egmap-debugfs.c
> index c5471cd..45d812c 100644
> --- a/drivers/base/regmap/regmap-debugfs.c
> +++ b/drivers/base/regmap/regmap-debugfs.c
> @@ -511,7 +511,7 @@ void regmap_debugfs_init(struct regmap *map, const ch=
ar *name)
>  	debugfs_create_file("range", 0400, map->debugfs,
>  			    map, &regmap_reg_ranges_fops);
> =20
> -	if (map->max_register) {
> +	if (map->max_register || regmap_readable(map, 0)) {

Yes.

--rbg6pv1WwQpmCPiZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBAgAGBQJSzZI7AAoJELSic+t+oim9fU8P+K9OFpFDhPFobb1/9JrobIaY
tPnWUBD76fpRs+A+wnzgFh3xqNQ2ItaSs/+x7QpizbTGfADz8jTpJ1lNjCQUcH8/
gfmcJmKWYSCeql9RBij5wY+8Uvl25oJM8AgVUzjXqxfjbyumWTJ6urIFYAotAwEz
jN1G20fepdBak6nkZOj/1VDZy/VAoX7dMjW1lKWvn63iwUqrHax2i3asW1DReDBA
8y1ZXL7PqDrCyvOab1PUaut4lEPojObTgV25ldLxCMQEN6y0noGNkYm+w3OIoOX1
UlwLvkui2iO8D52wSLtKXZ8gHNJJuBJUQo+KjMDVo5docIo68a4fcsTAwuc94yrt
1w3Nn1Aw+XfD+zmOItEkHgcRzRbUtQw0xG8ciD4wZFuWPYjUKnL0+2F/LRqN95DP
DCGc97OtPB1wRqp2MRAUAJ2vh8YTYfZlI3xgOjXkt/3YzX+8k5bD5SnoF2xOfsmT
6LzX01mc2UeKdY/ZSUXGDxy63rc9EQTRmgg0v15nwS3k+9GD/R/oqMqMyWtc4FsS
yetxM3CPBJwgKNkb8kMxB3Dq79CLXvjAYaOrS9dPLYXy69fgfipNOMYTCZuiaDJ9
0DAOGZ01Zq5qe6+HDgjSBnJGILPpJSsneqOpGiZ+yaRQrk+fIyqDnZwBHWbsM8oC
gq4QFDNF/4t5avC068Q=
=Mp25
-----END PGP SIGNATURE-----

--rbg6pv1WwQpmCPiZ--
