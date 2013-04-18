Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965828Ab3DRLPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:15:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55433 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935410Ab3DRLPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:15:20 -0400
Date: Thu, 18 Apr 2013 12:15:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2] regulator: core: Add
 regulator_map_voltage_ascend() API
Message-ID: <20130418111517.GD13687@opensource.wolfsonmicro.com>
References: <1366252489.17095.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a6YTfLRor63AaheO"
Content-Disposition: inline
In-Reply-To: <1366252489.17095.1.camel@phoenix>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a6YTfLRor63AaheO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2013 at 10:34:49AM +0800, Axel Lin wrote:
> A lot of regulator hardware has ascendant voltage list.
> This patch adds regulator_map_voltage_ascend() and export it.
>=20
> Drivers that have ascendant voltage list can use this as their map_voltag=
e()
> operation, this is more efficient than default regulator_map_voltage_iter=
ate()
> function.

I've applied this since it's a good API to have and it'll let people
build drivers on it.  It does seem like if we know the list is sorted we
ought to be able to take advantage of that to do better than a linear
scan.  Not sure it's worth bothering though as these tend not to have
that many values to map.

--a6YTfLRor63AaheO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRb9W+AAoJELSic+t+oim9jLIP/2A1CGmDSCRFCmEwHckcsN8j
WnUFvUzc1bfmdtmc70BLijRbVR+DfN4l6+wYXRdvWdnfa1F8bywrGNwt7omTZSRd
EBFV43+UzXnqFOL6QWuxBBwvC32pQ5AdGwRhnw7V2kpabT8LGdlHU+qi1jmmhzLg
aFFKKGFzFPGYVybLDOQ//0ymKFKH5n6eG8V5oQqLq91v4NIRrhAWdG2HtYK97Nkr
IPSM3hMRQj3AABqWeHBPBT3dGEjSAUD2IQU9bqvGSfDIW2/lNXmdfRApyAaryVIN
0UKREuFh9na1d9933tQsVjaATZg7722ww8r83luUxuLEb2cx/T2UTa7U0DTxpGpP
NJ4HyGS+9uXGaNoDPRU0MYVWDYVZznjzaBvnZEY9+sle3SImvYfiG0CBH4EbR1Bj
OpXAFG0LJNYwiCqHjPVwdgABMA+s+u5vNwIUidcjze15GPLZlU08hnwaISrRu4VO
vEWs8nUat0UL9SSMmUz3KacT8FjEgJKdOcXq5MnLxXIG2hiOsWw0gWn3Jleq+WAh
miHTTxVlu0IYwMlaWyChU4i+Gcf6CNfftVASBmuGn4zX8kJg26HZqduxycs0UkdK
Ch3j5dHZXFrFCkqqJ8vSgJywL/kY2xcWPpQI3A8BhyvFCGuYKojhvYeV6pGl1E59
wykJscRHGQMFnegy2dsx
=iXB3
-----END PGP SIGNATURE-----

--a6YTfLRor63AaheO--
