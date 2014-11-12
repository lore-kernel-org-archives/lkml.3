Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaKLLq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:46:26 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34798 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaKLLqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:46:24 -0500
Date: Wed, 12 Nov 2014 11:45:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Allen Martin <amartin@nvidia.com>, linux-kernel@vger.kernel.org
Message-ID: <20141112114505.GE3815@sirena.org.uk>
References: <1415787125-31218-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WiNKsjp/28UVTpBM"
Content-Disposition: inline
In-Reply-To: <1415787125-31218-1-git-send-email-thierry.reding@gmail.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Ensure voltages are within the allowed range
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WiNKsjp/28UVTpBM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2014 at 11:12:05AM +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> Unless a regulator has a fixed output voltage the core will not attempt
> to modify the output voltage. This can cause a situation where a driver
> enables the regulator but the currently configured voltage is outside
> the valid range.
>=20
> Fix this by constraining the current voltage to the allowed range upon
> regulator registration.

I've thought about doing this before but it's tricky as if there is a
voltage range it's possible something needs it at the high rather than
low end of the range and will get upset if the voltage gets lowered.
Setting the top voltage also has risks (though less bad when constraints
are sane) and requires working out what that is which we'd need to write
the machinery to do.

This is all especially likely to break given the depressing desire
everyone seems to have to put the maximum possible voltage range for
their regulators in constraints regardless of what's actually sensible
for their board design.

--WiNKsjp/28UVTpBM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUY0hBAAoJECTWi3JdVIfQbAkH/RwYA9djRlUr04NgA13nOnuS
sv5q4lvcnaYi6W77ITiv8iUI1GQZPldyh2yjeOOxPS0ZDzDQqUMRIJ49IDw7+FV3
afhTkiNwrQxs0Om77aZ1H8j/9tsI0p2PAIbKQ1/8C7YsWG0Qtdzocr9VrdoZKb3g
9ig9zdmC2nMoPrtg38TTJIV1Z5+JM77M/D6CxVuSIgXDVAg3sceO31R9pPAfKoTE
1bztLhqSvR3A2ZxA7LwdFzATuUQT/9ekAUqaeB/MTPN4f5RwXC7EHfuwse4TulCJ
jv+Yd+aLC99YGytVPlyK9hoRDWdaPKlmXTnK4XLFZ29OeTV54fMwk1EZUO5PgoA=
=sZ4B
-----END PGP SIGNATURE-----

--WiNKsjp/28UVTpBM--
