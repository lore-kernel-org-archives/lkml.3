Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbaJXU0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 16:26:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47681 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbaJXUZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 16:25:59 -0400
Date: Fri, 24 Oct 2014 15:25:10 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] phy: berlin-sata: Move PHY_BASE into private data
 struct
Message-ID: <20141024202510.GK11455@saruman>
Reply-To: <balbi@ti.com>
References: <1413882477-27922-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1413882477-27922-2-git-send-email-sebastian.hesselbarth@gmail.com>
 <54462865.6000205@ti.com>
 <544629F0.3090505@gmail.com>
 <544AB33F.9030701@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HBg0C3yr6HVa1ZCc"
Content-Disposition: inline
In-Reply-To: <544AB33F.9030701@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HBg0C3yr6HVa1ZCc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 24, 2014 at 10:14:55PM +0200, Sebastian Hesselbarth wrote:
> On 21.10.2014 11:40, Sebastian Hesselbarth wrote:
> >On 10/21/2014 11:33 AM, Kishon Vijay Abraham I wrote:
> >>On Tuesday 21 October 2014 02:37 PM, Sebastian Hesselbarth wrote:
> >>>Currently, Berlin SATA PHY driver assumes PHY_BASE address being
> >>>constant. While this PHY_BASE is correct for BG2Q, older BG2 PHY_BASE
> >>>is different. Prepare the driver for BG2 support by moving the phy_base
> >>>into private driver data.
> >>>
> >>>Acked-by: Antoine T=E9nart <antoine.tenart@free-electrons.com>
> >>>Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> >...
> >>>---
> >>>  drivers/phy/phy-berlin-sata.c | 42
> >>>++++++++++++++++++++++++++++--------------
> >>>  1 file changed, 28 insertions(+), 14 deletions(-)
> >>>
> >>>diff --git a/drivers/phy/phy-berlin-sata.c
> >>>b/drivers/phy/phy-berlin-sata.c
> >>>index 69ced52d72aa..9682b0f66177 100644
> >>>--- a/drivers/phy/phy-berlin-sata.c
> >>>+++ b/drivers/phy/phy-berlin-sata.c
> >>>@@ -30,7 +30,7 @@
> >>>  #define MBUS_WRITE_REQUEST_SIZE_128    (BIT(2) << 16)
> >>>  #define MBUS_READ_REQUEST_SIZE_128    (BIT(2) << 19)
> >>>
> >>>-#define PHY_BASE        0x200
> >>>+#define BG2Q_PHY_BASE        0x200
> >[...]
> >>>+static u32 bg2q_sata_phy_base =3D BG2Q_PHY_BASE;
> >>>+
> >>>+static const struct of_device_id phy_berlin_sata_of_match[] =3D {
> >>>+    {
> >>>+        .compatible =3D "marvell,berlin2q-sata-phy",
> >>>+        .data =3D &bg2q_sata_phy_base,
> >>
> >>Can't the base directly come from dt?
> >
> >You are suggesting a "marvell,phy-base-address" property, right?
> >I have no strong opinion about it, I accept your call (or DT maintainer
> >ones).
>=20
> Kishon,
>=20
> I still have the DT patches for BG2Q queued up for v3.19 (I missed the
> arm-soc merge window for v3.18). That means, there has been no release
> with the phy binding used and I can rework a little more.
>=20
> Can you please confirm that you want a DT property for the phy base addre=
ss,
> e.g. marvell,phy-base-address =3D <{0x200,0x80}> ?
>=20
> If so, I'd also rename the compatible from berlin2q-sata-phy to more
> generic berlin-sata-phy.

I think what Kishon is asking, is why this 0x200 offset isn't already on
reg. so that instead of, e.g.:

	reg =3D <0x40000000 0x1000>;

you would have:

	reg =3D <0x40000200 0x1000>;

then everybody's happy. It's unfortunate, however, that we already
shipped DT sources with the bogus (?) reg property and now we have to
support that broken binding. My suggestion would be to add a new
compatible which comes with proper reg property and still add that weird
phy_base for the old compatible, so that:

	if (of_device_is_compatible(node, "marvell,berlin2q-sata-phy"))
		phy->phy_base =3D PHY_BASE;

then, if new compatible comes with proper 'reg', phy->phy_base would be
zero and everything should still work. How does this sound ?

--=20
balbi

--HBg0C3yr6HVa1ZCc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSrWmAAoJEIaOsuA1yqREer0P/jt1nbqH9VGhTjPepAaFlb/k
qqvvs38OUI9HFG/KYTGYEu+kOQJa34YgpClzP/nmghc9Uvu4gP2Mtnws2rKmYF77
B+7G4uFAAl9r7nrH3xfINcx15hMxbWcVHGiX+H1Qtx1IB5zDuyvVxhRm8ED7N5Eb
zIKlhuf3Nyil3phV7DirNaB4+T47ASobRyyaz1JoxsmJrg6QEOgiJW8ln2E8OC7z
jEX0o6IrONOSl0SYGJLIkmm/dbyFPuhehlAgusmbEPRslMqcxBvyfv3EJUyzIV/w
mB4h5ZycpwKLiR3LxkUneLH8tyUd1GZdRKrIMcBIAK2ajMhYa1bRfvu6ive/Fh2V
Z9pPxgzoElwKigGpIai8uCABnYvgow/Dc9CFZ8xL/+tPWYhOWLfGvYz1QvbVWO7r
NeOYbvHjqL71Q8HI/B4dmcq0SCDkobZhQb4GfbRyL+eBS/+RvDomWThjcoS8eTEz
E3Eqofk/Ry0ydir8/OjI44Ol929rLOoiFvJzRmAqgwg1Hd6LVcZH7brgGXhX+IFm
GIjALogpQf3RaQdTBZozTRpWVKtQF/RNbqccDpd4sPbyV614Rmr4soGjs8AeWBPF
TrCv3Dz+AxdC+/2YG+pX92XLu57Q550ZZSTABajqvR+jl6o0NB0f3c3bOHsFzerh
SWs+2AiuW4tWX7HGfHrt
=B86C
-----END PGP SIGNATURE-----

--HBg0C3yr6HVa1ZCc--
