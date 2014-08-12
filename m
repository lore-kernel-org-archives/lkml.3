Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaHLVzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:55:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60496 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaHLVzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:55:31 -0400
Date: Tue, 12 Aug 2014 22:55:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Rob Clark <robdclark@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140812215515.GC17528@sirena.org.uk>
References: <1407807429.8958.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Om/TeAJ7PLqBTUVw"
Content-Disposition: inline
In-Reply-To: <1407807429.8958.1.camel@phoenix>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: Add stub for devm_regulator_get_exclusive
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Om/TeAJ7PLqBTUVw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2014 at 09:37:09AM +0800, Axel Lin wrote:
> Fix below build error when !CONFIG_REGULATOR.
>=20
>   CC      drivers/gpu/drm/msm/hdmi/hdmi.o
> drivers/gpu/drm/msm/hdmi/hdmi.c: In function 'hdmi_init':
> drivers/gpu/drm/msm/hdmi/hdmi.c:126:3: error: implicit declaration of fun=
ction 'devm_regulator_get_exclusive' [-Werror=3Dimplicit-function-declarati=
on]

So, I just looked at that driver - it errors out on probe without the
regualtor.  Are you sure the fix isn't to add a dependency on the
regulator API or convert it back to using normal regulator gets (it was
converted without comment as part of a DT conversion), or indeed to
using the bulk regulator API.  It looks awfully like the driver is just
open coding devm_regulator_bulk_get() and friends.

There is no explanation at all in either the changelog or the code for
why the driver is asking for exclusive regulators.

--Om/TeAJ7PLqBTUVw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6o1AAAoJELSic+t+oim9fqAP/i0VChHfWo6prbWXI/gv5mst
IOPn9S859BJmgJT3rZsnPjMD3MZrOMEv0GqKdiKOdANwT2sLJFHTluBjW197Rsmv
kz0emxLU10lpyF0jgM+bJBaPvF0e6VP5Te4Pbd/JlsthcwebuwweElxPd36X1aS7
j/AePhmaNJJUBw5KsvJQk5q9FpGL6SMTSjZYWxGCfg1gn0mt0D0v+qSEbxBSFqBw
DYOzdpOChFOreabNtD2SbkUK4zuwSZco/LjTlafKWTwtY0YhCJGfs5cqLbhc3ntc
Zla6BjEE/RAZ+xb5FQQiEdEhew/op6Y6640tQBLbKVwgitrSE1f+KH/8mCDHddbr
+eczr47O7fdzGmy8kFxVSCBIxXSMuzzgGv6WzlzQiK2m2CG5uXao6Ti2te642dPj
7BTtctbuV/ejBfH7iQs00bTokkEDnij2knlJxgepIrF363R5Gi2q1e5jzTlsE2gf
OSzBWTcYyMEyggvPLFHlZ2eyWeFxZTx5vfpOujZrAMnEWbpxV3tfUtYyDbVZ5Yuk
xgP10NNvL7X5xsWIyDSG0l6m4+xyDrw007a/Z14OxyPYdTjyn0HFrnfcWpQa8L3A
E29v5Xg7um7I5k3Es3OHHPlxpVM+RHbGF37+ha+B+/G8t2+fU88Eo9wuy5nlBR02
sMVG80eeIRZSL6qyqHS/
=yEpj
-----END PGP SIGNATURE-----

--Om/TeAJ7PLqBTUVw--
