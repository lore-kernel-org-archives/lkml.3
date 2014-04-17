Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaDQWDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 18:03:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47423 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaDQWDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 18:03:15 -0400
Date: Thu, 17 Apr 2014 17:00:36 -0500
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 06/19] bus: omap_l3_noc: un-obfuscate l3_targ address
 computation
Message-ID: <20140417220036.GE8504@saruman.home>
Reply-To: <balbi@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1397767775-10965-1-git-send-email-nm@ti.com>
 <1397767775-10965-7-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RpqchZ26BWispMcB"
Content-Disposition: inline
In-Reply-To: <1397767775-10965-7-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RpqchZ26BWispMcB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 17, 2014 at 03:49:22PM -0500, Nishanth Menon wrote:
> just simplify derefencing that is equivalent.
>=20
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> V2: just ordering change
> V1: https://patchwork.kernel.org/patch/3984201/
>  drivers/bus/omap_l3_noc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
> index c8facb0..f7d3bf4 100644
> --- a/drivers/bus/omap_l3_noc.c
> +++ b/drivers/bus/omap_l3_noc.c
> @@ -76,7 +76,7 @@ static irqreturn_t l3_interrupt_handler(int irq, void *=
_l3)
>  			err_src =3D __ffs(err_reg);
> =20
>  			/* Read the stderrlog_main_source from clk domain */
> -			l3_targ_base =3D base + *(l3_targ[i] + err_src);
> +			l3_targ_base =3D base + l3_targ[i][err_src];

hmmm, wasn't it so that pointer arithmetic was slightly faster than
array indexing ? In that case would it be best to:

l3_targ_base =3D base + *(l3_targ + i + err_src);

--=20
balbi

--RpqchZ26BWispMcB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTUE8EAAoJEIaOsuA1yqREbHEP/R8V2DkmOU3FRI+fJMwB1BYz
m01hQMSEme3ACAvGDvdQco08BXviyYohmf7cTMoChrdz70km2OX///2knSuHsjMp
Bo1oexhpB7vYRYabvVId29v9LVT+hdKoMbliysN8J5sBbg6CbNPBx3oJtnv/M0od
1hHVjDk59nYM8IwyTnLtHtgnCkrNnMrHAk7RpUdQkjMYyksJ77tPaJ9gUnATOXOb
v/E43AX3B4SlQmBlfooMG/Bhz5CGE6xp14rIXJjc+X3ma8wdNvXVeI1zqaGiy2Dc
K2qmde7bc5+0fAWq7GPBa0wfcJLr9KVEaGnUQddAKH5sD2dpRpX7gMwj4snn6mTJ
f2AjJrp3XO7ClOHlh7+eYmhbaQNl1NHt5k5l7447lrGufVbNUKq00TOEjBz7sZK2
paFBPUSsLDKCZ5ZAsPzelH3r3EtFQKlbtupP5i6bVcRqaoosGDnX72dIQvtq/afy
28PVjYE+RgJJXmuSUHdPKPON4dUEKlDTROHIGVysJr9G5rmS7Li+d0oju2f9zxIO
7bMWrPqRKMyQhfafAHdpkknRjC1TR3I6X62YWgP2ULYvNChg7iHq4HcWjz3pgo2e
1ixWbjV1gWbmZRZQRANlJ0WpCOr47bImtl5z+/2MAXEgOsVMY5/Z1N/1zktke7xQ
8/jZy/zNaGmLw6xpSGjD
=+vZe
-----END PGP SIGNATURE-----

--RpqchZ26BWispMcB--
