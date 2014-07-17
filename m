Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbaGQRV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:21:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43943 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbaGQRV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:21:28 -0400
Date: Thu, 17 Jul 2014 12:20:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kernel@stlinux.com>, <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <peter.griffin+familyguy@linaro.org>
Subject: Re: [RFC PATCH] usb: dwc3: core: allow vendor drivers to check probe
 status
Message-ID: <20140717172045.GM10459@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405617213-27360-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="um2V5WpqCyd73IVb"
Content-Disposition: inline
In-Reply-To: <1405617213-27360-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--um2V5WpqCyd73IVb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 17, 2014 at 06:13:33PM +0100, Lee Jones wrote:
> This patch provides mechanism for subordinate devices to check
> whether the DWC3 core probed successfully or otherwise.  Useful
> if PHYs are required to configure controllers, but aren't yet
> available.  The DWC3 core driver will defer probe if PHYs are
> unavailable, however subordinate DWC3 drivers currently do not
> have any visibility or means to check status - until now.

what's a subordinate DWC3 driver ?

> Another way to do this would be to *_phy_get*(), but if every
> driver did this it would create a high level of code
> duplication.
>=20
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/usb/dwc3/core.c | 12 ++++++++++++
>  drivers/usb/dwc3/core.h |  1 +
>  2 files changed, 13 insertions(+)
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index eb69eb9..171ca52 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -47,6 +47,14 @@
> =20
>  /* ---------------------------------------------------------------------=
----- */
> =20
> +static bool is_enabled =3D false;
> +
> +int dwc3_is_enabled(void)
> +{
> +	return is_enabled;
> +}
> +EXPORT_SYMBOL(dwc3_is_enabled);

no, no, no, no. Let me try that again, hello no! You _do_ realise there
are systems with more than one dwc3 instance, right ? And this is the
most fragile possible way of doing this.

You never explained what's a dwc3 subordinate driver, you don't show any
example of how this would be used and why/where does the PHY need to
poke into DWC3. Why isn't probe defer enough for you ? Which platform
are you working on ? what is the problem that you're trying to solve ?

=46rom this patch, all I can is NAK this patch with no mercy, sorry.

--=20
balbi

--um2V5WpqCyd73IVb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTyAXtAAoJEIaOsuA1yqREHSAP/3LVR5BSRVxHqSlfsBFo9PW8
lVbGAMC//Rqo/EiZCHvQsitYDe/PfyPRE6NS1NQvw8THg7uJAgCX/A87+m9V2Cp0
vjVCflOpdTfiJU+pGvLWWaJxaNlLHttCuIf83+Rbt1pBC3lHhb0LnyIRoU2KsSVn
xHyKUeK4vScvlRsEQ+fZAHLB/dmJLOlMv3nA8BUrbQo/moH6nZxhKSodmPHVcEgP
X73XuUmRg1Cm2fcS+l67X+ISWDeASKX7jjNu19VIohDV2fKsNr8/hqGR3OK5vD5m
Ir6Xzho2DB3M1gQQf068ndcs4RWF3w5kjB7EkWPb3DBXS1rvjgK1VJ0xaLwbQuBA
fegVpw4JDTVhsElue3q/s8pxpB80kIizW7gqOzzwapGz3IHrkGKo+IzaLbb9BQeM
uS94RL7rQ1IRQDHqA6iA6zUaPf67iEPNXuvVWk8bwLqHZxnEjTn9Q3O8JzZAOEst
uD8UCiS7f6iQ6bsVNV0d+VZFdbE0Sj43axYkoHnST+k2GtHhw5hHis9AwMKTQupa
Jt8w5J3yz99yTbLpNKwQROaKOrdYiR+rJ+4g329wGUNSsCDCSBi4Hw485StZVNuK
iHauB7tK9gjlU1j1p/dhFkcnrOKvmd6r3vo/yU72QhtUuy3JDW9cznSstSsqLBam
Ru0BFpXAl3U8JCT2mWwx
=Al43
-----END PGP SIGNATURE-----

--um2V5WpqCyd73IVb--
