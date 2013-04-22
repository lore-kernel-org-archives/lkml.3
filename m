Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab3DVOcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:32:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49974 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab3DVOcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:32:18 -0400
Date: Mon, 22 Apr 2013 17:31:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 2/5] driver: serial: omap: prevent runtime PM for
 "no_console_suspend"
Message-ID: <20130422143136.GB7508@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1366638237-6880-1-git-send-email-sourav.poddar@ti.com>
 <1366638237-6880-3-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
In-Reply-To: <1366638237-6880-3-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 22, 2013 at 07:13:54PM +0530, Sourav Poddar wrote:
> The driver manages "no_console_suspend" by preventing runtime PM
> during the suspend path, which forces the console UART to stay awake.
>=20
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> ---
>  drivers/tty/serial/omap-serial.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-s=
erial.c
> index 08332f3..640b14e 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -1582,7 +1582,7 @@ static int serial_omap_runtime_suspend(struct devic=
e *dev)
>  	struct uart_omap_port *up =3D dev_get_drvdata(dev);
>  	struct omap_uart_port_info *pdata =3D dev->platform_data;
> =20
> -	if (!up)
> +	if (!up || (!console_suspend_enabled && uart_console(&up->port)))
>  		return -EINVAL;

-EBUSY would be a better value for uart_console case, so this check
should be splitted accordingly. Likewise on second hunk.

--=20
balbi

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdUnIAAoJEIaOsuA1yqRE0AQP/2SzcP5BIHTwNyTVuwa+/YpW
aqkJe33D15IfwjtJfMDFAxFPwSAd42CLIT/MTgHp2z2CcWPG5SYjk9VXt9Q1e2K6
/uu9/vBoHsKM6wJ8u5O/INpwNvPplEyUQlB06ZszojTP6aOD495MC5qUi6Gavtb5
FMdLLO6go4aem0T7HWNz6m1geNO1zlAytp3goQu5UKpDPFXkMq6pkkKPjNd1Zo6E
2jlg271wDM/lVTJWaO0vHVQRhdd1hA2id0CI7BBbQxKM9Rxb88wlwmRgutoulApr
9fnkcSMPGF4eC+gRvFTCiFNUIOEeP/PARLROREv9yLaQeQJmSy/TcGAgRgobZiCt
5U/+wLIy1+lYM3FTuQy0q/+Y8uvSoFR+oG02iECkyPmCs1Nly/Jxn0BZFzV3NWCl
nPc3KRAZdIIzf4WfcevCRqeI7L4+CbES4V7WAU9La9k0rb95ruc51GdaqK6s4PSs
VGoJEkxZnKBTymSa0rmgnqLUdM6vq5ZApN0bEJA3QbfdqUT88MbjawM3RN+heyhQ
QrrFJELubavFMFY0NLb0S05maN8n5178m7D9qaQ395eGlzcI52ysog2onIZ/0TZo
pCWF8C1AsMsHjDJG1rIBMked0B/UuMBKBkfvAz7WuxxET/cE3YTC2C+RXp04CN1k
CbbQb/CuJAHlMVlASIPp
=NxG/
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
