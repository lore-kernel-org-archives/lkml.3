Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaEOPiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:38:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33003 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaEOPiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:38:18 -0400
Date: Thu, 15 May 2014 10:37:57 -0500
From: Felipe Balbi <balbi@ti.com>
To: Zhuang Jin Can <jin.can.zhuang@intel.com>
CC: Felipe Balbi <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <david.a.cohen@linux.intel.com>, <Yuan@intel.com>,
        Hang <hang.yuan@intel.com>, <Zhuang@intel.com>, <Li@intel.com>,
        Jiebing <jiebing.li@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] usb: dwc3: gadget: check link trb after free_slot is
 increased
Message-ID: <20140515153757.GB7360@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140515215757.GD16153@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <20140515215757.GD16153@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

On Fri, May 16, 2014 at 05:57:57AM +0800, Zhuang Jin Can wrote:
> In ISOC transfers, when free_slot points to the last TRB (i.e. Link
> TRB), and all queued requests meet Missed Interval Isoc error, busy_slot
> points to trb0.
> 	busy_slot->trb0
> 		   trb1
> 		   ...
> 	free_slot->trb31(Link TRB)
>=20
> After end transfer and receiving the XferNotReady event, trb_left is
> caculated as 1 which is wrong, and no TRB will be primed to the
> endpoint.
>=20
> The root cause is free_slot is not increased the same way as busy_slot.
> When busy_slot is increased by one, it checks if points to a link TRB
> after increasement, but free_slot checks it before increasement.
> free_slot should behave the same as busy_slot to make the trb_left
> caculation correct.
>=20
> Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
> Signed-off-by: Jiebing Li <jiebing.li@intel.com>
> ---
>  drivers/usb/dwc3/gadget.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 54da8c8..2ebe82b 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -828,10 +828,6 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
>  			length, last ? " last" : "",
>  			chain ? " chain" : "");
> =20
> -	/* Skip the LINK-TRB on ISOC */
> -	if (((dep->free_slot & DWC3_TRB_MASK) =3D=3D DWC3_TRB_NUM - 1) &&
> -			usb_endpoint_xfer_isoc(dep->endpoint.desc))
> -		dep->free_slot++;
> =20
>  	trb =3D &dep->trb_pool[dep->free_slot & DWC3_TRB_MASK];

I have a feeling this has a negative side effect of letting us use the
link TRB for data transfer... I mean, if we don't increment free_slot
before accessing our trb_pool, we have no way to skip link trb on this
access here.

How did you find the bug ? do you have good instructions on how to
reproduce it ? How did you test the patch and for how long ?

cheers

--=20
balbi

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTdN9VAAoJEIaOsuA1yqREKDwQAIS0kiAToZ5wPkuTBT3/fQbg
R8ET7bR0/zBBYxlUXesxdlVIEZiWvg3Cxcosnaxe1XjhqGu68CYk1c79dfSUeLBv
rLR6c3KKhgpKSYwHqNy97x27L0qtYBP86B8cplK/iXejGyc/FqNLmCU/W7xqg4od
1krS+UOre+2g0MeOYDbJyX486WQuQNUx/XU/d+vYBEJ9UR3TESQ9HE+98ZVai0gs
ZvqE1RiPEBnHTZkb3ak7FBc8D34jDHIb75E4Myj8e8MrZywq13wbDIm5MiugpcCl
3iTdr2egvOXTdBvj5sJLsK4e96fYDL0ta5X6zTaHsCVSr0Dnsz9xbLKwxg5ECxXo
m+zdi+oR9L2zdacFV8/zavZUiqJJcijnjrQn3SX5V/Y5xm+VTUHhIcxOGuWJKfP4
0uFbRkBiyljMngcvi8OEIzje8NiX1N5RDM3WSMl6VbqS3gPGaMfacDSoHQNX0exb
1xzzpawiB2309cyzST8NEFXkQdI6FyTdKPVKu/3Dwtpo0qHZnMkk5sz+ctv25Vux
fy4AuWcgnNuIJR1cng6NfxSncr3eSs+ZtJatg+E15SROnivJwlh+bd3Y+P4owqFa
dq20DDK1WqxVtaBttMg2E2TSwq7tMR87mjgj6KMozPvV8xzGYtOAyh5/Ikl+ZTCr
HX8KD350HzyCXVE1Uvk8
=Hecb
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
