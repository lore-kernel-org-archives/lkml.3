Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3LPVVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:21:39 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34436 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3LPVVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:21:36 -0500
Date: Mon, 16 Dec 2013 15:20:56 -0600
From: Felipe Balbi <balbi@ti.com>
To: Apelete Seketeli <apelete@seketeli.net>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 3/3] usb: musb: fix setting JZ4740 gadget periphal mode
 on reset
Message-ID: <20131216212056.GE12896@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386992918-1531-1-git-send-email-apelete@seketeli.net>
 <1386992918-1531-4-git-send-email-apelete@seketeli.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dzs2zDY0zgkG72+7"
Content-Disposition: inline
In-Reply-To: <1386992918-1531-4-git-send-email-apelete@seketeli.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Dzs2zDY0zgkG72+7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 14, 2013 at 04:48:38AM +0100, Apelete Seketeli wrote:
> JZ4740 USB Device Controller is not OTG compatible and does not have DEVC=
TL
> register in silicon.
>=20
> During ethernet-over-usb transactions, on reset, musb driver tries to
> read from DEVCTL and consequently sets device as host (A-Device)
> instead of peripheral (B-Device), which makes it a composite device to
> the USB gadget driver.
> This induces a kernel panic during power down where the USB gadget
> driver does a null pointer dereference when trying to access the
> composite device configuration.
>=20
> On reset, do not rely on DEVCTL value for setting gadget peripheral
> mode: hardcode it instead to B-Device.
>=20
> Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
> ---
>  drivers/usb/musb/musb_gadget.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadge=
t.c
> index 32fb057..b4bea7a 100644
> --- a/drivers/usb/musb/musb_gadget.c
> +++ b/drivers/usb/musb/musb_gadget.c
> @@ -2119,6 +2119,14 @@ __acquires(musb->lock)
>  	/* Normal reset, as B-Device;
>  	 * or else after HNP, as A-Device
>  	 */
> +#if defined(CONFIG_USB_MUSB_JZ4740) || defined(CONFIG_USB_MUSB_JZ4740_MO=
DULE)

NAK, no ifdefs in this driver. Pass a quirk flag through platform_data
or something similar.

--=20
balbi

--Dzs2zDY0zgkG72+7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSr264AAoJEIaOsuA1yqREkc8QAIWWmDSDNfFhszkkbb/i6hv7
emxBd0TFKTVlH+wyuIcplYFl7IPOfPjxZevR87cMRh1zcLjtnEZL/uFGoc7kXi4Z
DfO92eAzA+BndUzpdvNToHCvXEuiqZxqzuP8UgUBBaxstpwDBy9oc2pIRa2+nfNs
sGtQkKIYIGY5CeiSHlC80zM8at2psfXUHNGP3Cj6Zz+NboFdNDDaSHPt/XtSKesB
pTmg7JGpwI+CFi7xjEKwVhs4n5MRLlGkm/EHZVHZT0+cTdNgN/9lnDd6fDgFEGWi
CGWNNiqiRPaR/cl1MnHQSZiiaTKzM2BelsyClDQ0x2jAQNHTLUtymsVW5PzAQ6K1
RH2smXAJvjIyMtzHFUYWbqEGQmnMDyY/qDXJAw3WxN4deZBXY9/79qfkuaosxwmh
L4wB9wxs3Bnk6PijHNCG/J0B2/6LJBl/tvQ4byaI38yuG6ibDYSx27Jeq/ru1giY
Vzqnl4EgiRDRtb1xPwZuA11uOUL9u/S4gGX+2kEX8dCNjOQwrEhpCi4RbElKZ0h1
L+VdplVRumJIpSQDAGQvJN3r7uWaYztYuYToA5/Rv56wdCnWhIm+PX0wE9+VPC1r
2sfplUq06vO9B0Umh39yd5Y16cbxTQV3sjlVWEau0IMwzlQbgaDwMRzGK4UHPWiY
8fh6sQ/9ZjZIkKgyHfV4
=KUh6
-----END PGP SIGNATURE-----

--Dzs2zDY0zgkG72+7--
