Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab3LJXuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:50:10 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40605 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3LJXuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:50:08 -0500
Date: Tue, 10 Dec 2013 23:50:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20131210235000.GK11468@sirena.org.uk>
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
 <1386718523-2587-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cEobB2knsyc5ebfU"
Content-Disposition: inline
In-Reply-To: <1386718523-2587-4-git-send-email-sboyd@codeaurora.org>
X-Cookie: If your bread is stale, make toast.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/8] regmap: Add support for using regmap over ssbi
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cEobB2knsyc5ebfU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2013 at 03:35:18PM -0800, Stephen Boyd wrote:

> +	while (val_size) {
> +		ret =3D ssbi_read(context, *(u16 *)reg, val, 1);
> +		if (ret)
> +			return ret;
> +		reg +=3D sizeof(u16);
> +		val +=3D sizeof(u8);
> +		val_size -=3D sizeof(u8);

I'd expect this to generate out of bounds accesses and bad interactions
on the bus if we go through the loop more than once since it appears to
incrementing the address of reg for every register.  I'm also having a
hard time understanding why this is doing a read per byte, ssbi_read()
seems to map fairly directly onto the interface of the operation so
there doesn't seem to be any reason for this loop to exist in the first
place.

Has this been tested? =20

It'd be helpful to CC the entire series, or at least the patches this
builds on...

--cEobB2knsyc5ebfU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSp6ilAAoJELSic+t+oim9v00QAJsPEdpQOzJy4LqwJ2wtUHsY
aN54nNgQK2RB5uml/8y7WJTFoibJ6Sz+rAMSV1ibwk/oeBpGc6X0sKZkCh63qe2i
3QqsXh9BkM7JShFABDmwLyY35k16vtfm8WELljiansNeN0hupeHGDzD96TnOSIau
SxvvdjO3z0I/s9LeYRwEXDSTJ26toz/DJTTp4xfU3nH1b3Nkez9uwaXsYL5+ySO1
ku8oTwDOei5O6CZnYGVAe7sFgAOOf6n2U/p0ZOP+M9S7ghqB82N98pfaHo8fNdoz
PmaUB/E6hqtPlRZzVkRM9/KoT+HxZLjdVoWt/xijRVOKNGtQDaHBb3flGChDb/Sl
rZgFcxsYdfvjxmioxxShlpXIux2AMSQ0ygAVr1RS53oaDCiae1KHCP+WbLcde/OD
1VxGAE4orgpeJ1XgsyChECohZmM0rKHGoXfHdg8kgQG3cjJHhBF/uhmJg/uVF+IK
3mrkRFsDYwB1qmv5hsPDBrYJrsEXcvB59Bm9NFpkk3mWRqvstIBOk5aJ18NDaUjG
23ZgCLIHpZ5FDjkCSQr5NgUvR7TiwyEeqc8ynWMyrLUoBTVWf+chDdloqi8KDOL6
hy0ZEVnE631fA63+r70gxP0jTEpK6KGjmHl4eaqk9cnr0UooIaSjUx+ES0oxPB/G
x3vLemmh3mkAYmAJcoca
=iDRj
-----END PGP SIGNATURE-----

--cEobB2knsyc5ebfU--
