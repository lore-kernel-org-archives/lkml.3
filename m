Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaHSTG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 15:06:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39943 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbaHSTGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 15:06:54 -0400
Date: Tue, 19 Aug 2014 14:06:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Peter Chen <Peter.Chen@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tim Bird <tbird20d@gmail.com>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] usb: chipidea: msm: Use USB PHY API to control
 PHY state
Message-ID: <20140819190643.GF22003@saruman.home>
Reply-To: <balbi@ti.com>
References: <1408094479-13857-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hK8Uo4Yp55NZU70L"
Content-Disposition: inline
In-Reply-To: <1408094479-13857-1-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hK8Uo4Yp55NZU70L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2014 at 12:21:19PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> PHY drivers keep track of the current state of the hardware,
> so don't change PHY settings under it.
>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

looks correct to me from a PHY API perspective, so:

Acked-by: Felipe Balbi <balbi@ti.com>

However, it doesn't look like msm_phy_init() is equivalent to the lines
removes. Care to comment ?

> ---
>  drivers/usb/chipidea/ci_hdrc_msm.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci=
_hdrc_msm.c
> index d72b9d2..81de834 100644
> --- a/drivers/usb/chipidea/ci_hdrc_msm.c
> +++ b/drivers/usb/chipidea/ci_hdrc_msm.c
> @@ -20,13 +20,11 @@
>  static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
>  {
>  	struct device *dev =3D ci->gadget.dev.parent;
> -	int val;
> =20
>  	switch (event) {
>  	case CI_HDRC_CONTROLLER_RESET_EVENT:
>  		dev_dbg(dev, "CI_HDRC_CONTROLLER_RESET_EVENT received\n");
> -		writel(0, USB_AHBBURST);
> -		writel(0, USB_AHBMODE);
> +		usb_phy_init(ci->transceiver);
>  		break;
>  	case CI_HDRC_CONTROLLER_STOPPED_EVENT:
>  		dev_dbg(dev, "CI_HDRC_CONTROLLER_STOPPED_EVENT received\n");
> @@ -34,10 +32,7 @@ static void ci_hdrc_msm_notify_event(struct ci_hdrc *c=
i, unsigned event)
>  		 * Put the transceiver in non-driving mode. Otherwise host
>  		 * may not detect soft-disconnection.
>  		 */
> -		val =3D usb_phy_io_read(ci->transceiver, ULPI_FUNC_CTRL);
> -		val &=3D ~ULPI_FUNC_CTRL_OPMODE_MASK;
> -		val |=3D ULPI_FUNC_CTRL_OPMODE_NONDRIVING;
> -		usb_phy_io_write(ci->transceiver, val, ULPI_FUNC_CTRL);
> +		usb_phy_notify_disconnect(ci->transceiver, USB_SPEED_UNKNOWN);
>  		break;
>  	default:
>  		dev_dbg(dev, "unknown ci_hdrc event\n");
> --=20
> 1.8.3.2
>=20

--=20
balbi

--hK8Uo4Yp55NZU70L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT86BDAAoJEIaOsuA1yqREsk8P/i/PpJcuKgH7PHVpjtEYlCWe
Y6p8wB9n/HHoXJ8IrGuaMBHspJKxSDGO6zBTh1UIrr55jdlh29DXBRDStENXalVg
D8wWYEr/R8TywFgz2TrzcW3oK8ltpENmEfv0NEVeJiDIXdnbKKrl0Wo4Da5MLb8p
kLV7/5iz1rwPBAPr1VkKda938Un8wHwTV9uD3Gv0xHKhe8hoJI0FNfSP4qvp3THd
5pum1N+XWZVKO2+b3M4gFWGLWtO1m57acHyyyiRb2k8XNasv+P4SugWjGImbCbZ/
EFAyJYKo0WVrchYyMHE8u0RAAnspuNEloip1ndlarLmcIFS+QMxuNekJcRMy3ivd
V+Sd+0POe8KxAdWf+S6kgjwb3GggjNG/RTpWTfZDD72dgxWVcpi4cbKIQBWPihlM
86VC67v2E6Z933d1YW3pzeFsOcE/UfHwrK2zXCYP5CmzG3QA8yjXuTVLe7zrTv7c
aD5hiroVNH4EFDjLOZG2rOW4EosJNEp9P3bZjPcJARfyBtU9JtviulnPVStvOwrv
JWHHn0ssajcqhQB4z1Jt77m9YyviimHRKrW/pyIrNa9KghKdNoKBKinU6pdYSQAG
thA3WzaVzum/VQmd2bPW96QHK1dZ2FkIY+KPPjc09E6H86JavX04sId/cbR44Ian
BFHlJs6PJqCuzpkm6AOk
=nKtx
-----END PGP SIGNATURE-----

--hK8Uo4Yp55NZU70L--
