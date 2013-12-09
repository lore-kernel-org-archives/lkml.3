Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289Ab3LIV5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:57:51 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47524 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3LIV5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:57:47 -0500
Date: Mon, 9 Dec 2013 15:56:41 -0600
From: Felipe Balbi <balbi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 01/23] mm/memblock: debug: correct displaying of upper
 memory boundary
Message-ID: <20131209215641.GF29143@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386625856-12942-1-git-send-email-santosh.shilimkar@ti.com>
 <1386625856-12942-2-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="twz1s1Hj1O0rHoT0"
Content-Disposition: inline
In-Reply-To: <1386625856-12942-2-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--twz1s1Hj1O0rHoT0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 09, 2013 at 04:50:34PM -0500, Santosh Shilimkar wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
>=20
> When debugging is enabled (cmdline has "memblock=3Ddebug") the memblock
> will display upper memory boundary per each allocated/freed memory range
> wrongly. For example:
>  memblock_reserve: [0x0000009e7e8000-0x0000009e7ed000] _memblock_early_al=
loc_try_nid_nopanic+0xfc/0x12c
>=20
> The 0x0000009e7ed000 is displayed instead of 0x0000009e7ecfff
>=20
> Hence, correct this by changing formula used to calculate upper memory
> boundary to (u64)base + size - 1 instead of  (u64)base + size everywhere
> in the debug messages.
>=20
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Very minor patch but perhaps we should Cc: stable here ? not that it
matters much...

--=20
balbi

--twz1s1Hj1O0rHoT0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSpjyZAAoJEIaOsuA1yqREsZwQAJA7Gd1mKnfy3iCkZJmiDeEs
dts3AWkF7IKcStwYsfNfSd1068vkqHSZ+bA587djfb3EWmYCPb+7f9Vf8SH90wkT
W1cg/b0l5v0T8t+rmHvuuwXjLOjWj7cPE4CZzJDe3bckGDuXq6/1Bu7i+cHNLW/r
xI1rrlWuv0WyzzmLTl/kWB7rgdSXR/6X5+ANnEZu6kcMO+Wxy/ns617G1vY+TNnB
KqNnjn1hnUBQqJONxjzp0bm3sKP0c6V5fq2QqkwVrGZWoXZx2Ia1zzlu+3eJ1y/V
TiIL7tiuDkvxQdNyiiUSjGfSt0MUd0GxgSf/ZEP8Wd9dnx/WIUgozDEq7b5YPeXc
2OjNRFm9jcPZ4MRgwjoEl8iUC9BQQjEvKum/RLB3nMO3sCMTf0ikwr6B5wU0aTMh
HnADwM6+zmYnmOH2k40n5iPsPWbDYZnZCRMVGhjNg+7N6BWwumU6qg1zu+4g5k7X
eS5TqV53Wz4HFoOTkCxfdw0oKMcQOo/2cq7HSk0sPPPbfD6adVxypmeFpaN8CjMy
YlzUQaLS1DQPz4tnVuAl24YHPIzvwg1kPHaOl7PTx0GjDy07kv0ezgw/bZjfe6aJ
3LNSqikxNUqfW0dzWGSgvA7qGB1duSZfx8aLruLHC5/hapshU4xiSWdPqiJiXZP4
vW4rBSzTCdxFRUj8vGhI
=vg5q
-----END PGP SIGNATURE-----

--twz1s1Hj1O0rHoT0--
