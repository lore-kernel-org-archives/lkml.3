Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaDUPOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 11:14:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46699 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbaDUPOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 11:14:00 -0400
Date: Mon, 21 Apr 2014 10:11:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 06/19] bus: omap_l3_noc: un-obfuscate l3_targ address
 computation
Message-ID: <20140421151117.GF27341@saruman.home>
Reply-To: <balbi@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1397767775-10965-1-git-send-email-nm@ti.com>
 <1397767775-10965-7-git-send-email-nm@ti.com>
 <20140417220036.GE8504@saruman.home>
 <5355185B.70003@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+jhVVhN62yS6hEJ8"
Content-Disposition: inline
In-Reply-To: <5355185B.70003@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+jhVVhN62yS6hEJ8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 21, 2014 at 08:08:43AM -0500, Nishanth Menon wrote:
> On 04/17/2014 05:00 PM, Felipe Balbi wrote:
> > On Thu, Apr 17, 2014 at 03:49:22PM -0500, Nishanth Menon wrote:
> >> just simplify derefencing that is equivalent.
> >>
> >> Signed-off-by: Nishanth Menon <nm@ti.com>
> >> ---
> >> V2: just ordering change
> >> V1: https://patchwork.kernel.org/patch/3984201/
> >>  drivers/bus/omap_l3_noc.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
> >> index c8facb0..f7d3bf4 100644
> >> --- a/drivers/bus/omap_l3_noc.c
> >> +++ b/drivers/bus/omap_l3_noc.c
> >> @@ -76,7 +76,7 @@ static irqreturn_t l3_interrupt_handler(int irq, voi=
d *_l3)
> >>  			err_src =3D __ffs(err_reg);
> >> =20
> >>  			/* Read the stderrlog_main_source from clk domain */
> >> -			l3_targ_base =3D base + *(l3_targ[i] + err_src);
> >> +			l3_targ_base =3D base + l3_targ[i][err_src];
> >=20
> > hmmm, wasn't it so that pointer arithmetic was slightly faster than
> > array indexing ? In that case would it be best to:
> >=20
> > l3_targ_base =3D base + *(l3_targ + i + err_src);
> >=20
> Yes, if this was a hot path (example: interrupt handler that gets
> invoked very often), I would probably have preferred optimization at
> this point.
>=20
> However, the patch is just a step away from patches that converts the
> target information into a structure under flagmux structure allowing
> us to get rid of multiple array operations.
>=20
> This patch just makes the further changes a bit readable.

alright, the error IRQ doesn't fire very often indeed.

--=20
balbi

--+jhVVhN62yS6hEJ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVTUVAAoJEIaOsuA1yqREcHMP/AocSRYVdtg54C5i7tGscswR
UD89bCjcboPCfXcV/CV2WNbSRh3cF5yCdbOe2DukFo2W0soHHvQcQSQN477z9R1Q
eiyaU5/6VPhwtxsMSzmR/0kBNcGCkO1S0FE5bhMl/aj5fOYr4cvJzRJFwWTOpD5Q
6VnOxGF4pJg15JoBfE7vx71rMhN1FX3JwuhBNbykJdwaihUk+5sPKCJQVnsVv7eF
0ltPNvDNRSOi7xjiwejhvIy0PY8KRhu65oDf/x4ZRq6hpEIwhk4TjwMvShVSh2Lx
TpaPdYv2fYtl2m7UXry8ety3Z4ek+wL6xDucidJA5onGX4NwgCwBWMyUcdoG1qdV
odmtol5Dg8HMnI1h3oY+1ly1iEsuIiRbvCfF/uvbfrE7s1J6Sj8qdILKqwyyTanR
LtmrljshoP++BLvtKgJhmjhOQ7he11iHHQGMGwaem7LsyAbEW1/midynWQhhz1Wx
d54Imo+dgBk2JiuC2EFJW4cpHDTOWOl1pBCtiXoOj+PHRUdAZQIJfNpojgkFAZo/
eOxi+T58iaXjU6dvKTOVpeJE3kwYqJkQ4JnZR5csypJCaTOkFukYaZ5tnZzjtomh
93ZWxBihrXymdhyhmFGwddyyuPFsgVp7BZ0rmlZmgu+HTcyX2Y6e6ZkfTVdTAqI1
cQRrghx+niRdY+XSgC2a
=S+0h
-----END PGP SIGNATURE-----

--+jhVVhN62yS6hEJ8--
