Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaEEPiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:38:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47913 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaEEPiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:38:14 -0400
Date: Mon, 5 May 2014 10:38:04 -0500
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <mpa@pengutronix.de>
Subject: Re: [PATCH] usb: musb: dsps: Remove debugfs entry in
 musb_platform_exit
Message-ID: <20140505153803.GD17875@saruman.home>
Reply-To: <balbi@ti.com>
References: <1399300384-4179-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="76DTJ5CE0DCVQemd"
Content-Disposition: inline
In-Reply-To: <1399300384-4179-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--76DTJ5CE0DCVQemd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 05, 2014 at 08:03:04PM +0530, George Cherian wrote:
> Remove the dsps_debugfs entry as part of musb_platform_exit().
> Without this MUSB never gets probed if compiled built-in.
>=20
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  drivers/usb/musb/musb_dsps.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
> index 9d9acaa..9876374 100644
> --- a/drivers/usb/musb/musb_dsps.c
> +++ b/drivers/usb/musb/musb_dsps.c
> @@ -482,6 +482,7 @@ static int dsps_musb_exit(struct musb *musb)
>  	struct dsps_glue *glue =3D dev_get_drvdata(dev->parent);
> =20
>  	del_timer_sync(&glue->timer);
> +	debugfs_remove_recursive(glue->dbgfs_root);

already fixed:

commit 0fca91b8a446d4a38b8f3d4772c4a8665ebcd7b2
Author: Daniel Mack <zonque@gmail.com>
Date:   Wed Apr 2 11:46:51 2014 +0200

    usb: musb: dsps: move debugfs_remove_recursive()
   =20
    When the platform initialization fails due to missing resources, it will
    return -EPROBE_DEFER after dsps_musb_init() has been called.
   =20
    dsps_musb_init() calls dsps_musb_dbg_init() to allocate the debugfs
    nodes. At a later point in time, the probe will be retried, and
    dsps_musb_dbg_init() will be called again. debugfs_create_dir() will
    fail this time, as the node already exists, and so the entire device
    probe will fail with -ENOMEM.
   =20
    Fix this by moving debugfs_remove_recursive() from dsps_remove() to the
    plaform's exit function, so it will be cleanly torn down when the probe
    fails. It also feels more natural this way, as .exit is the counterpart
    to .init.
   =20
    Signed-off-by: Daniel Mack <zonque@gmail.com>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 3372ded..e2fd263 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -470,8 +470,9 @@ static int dsps_musb_exit(struct musb *musb)
 	struct dsps_glue *glue =3D dev_get_drvdata(dev->parent);
=20
 	del_timer_sync(&glue->timer);
-
 	usb_phy_shutdown(musb->xceiv);
+	debugfs_remove_recursive(glue->dbgfs_root);
+
 	return 0;
 }
=20
@@ -708,8 +709,6 @@ static int dsps_remove(struct platform_device *pdev)
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
=20
-	debugfs_remove_recursive(glue->dbgfs_root);
-
 	return 0;
 }
=20

--=20
balbi

--76DTJ5CE0DCVQemd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTZ7BbAAoJEIaOsuA1yqRES/gQAJsx7sOf2ekqgoW2CusSjl9H
uQHFKjbeQ/wElg4bC1RCjDUGHci77Cj5BmvUKLqoqHnHsR/Ee7vPQW0L914rSFil
gR5Ffto3yf/FgQds8+LxrVWx6bH0jfz5NH7xdYG41wJnTMbjlRbHV+qibqBBy5Lj
uf6irXmuKtG4Pd1WS2UBB8mZ0ZqNO5q/RVBcXHJnuymNUHOibmDisqtQLib6w39V
BjYjRTpjuiuS42iRCCkFDzVVqQjnXFQNleEZ0e8HLKSuNn1B4lldiFJlh/BhXush
9GNykRZKrDu1/oq0zgXceOCLu3+ihY4YrCnepqrO1GilW7dqcWat0435XGIomR5g
bQvtR2PfeCAZEjcGmTYO6/67+lSbjpp3pQb3Gc6pngIUjtKEkJkT36cVh9ny99xe
hZOuUBGergR2d/PI89ufDlYqxZWYOZbnSA31N1W/7VtaEFHsC2amALI9Xt/k/ODY
FO18CLNaavknWVyGyxLxb3m6WcFK6q5kbGkLhz8VSOELNYFwPrDls3vNUN++APK4
p98GnfFX5Kqo5b+MzZ0iFpf3ZZZcgUvmHOwMzbAWGUVKIt9XHWPcjtFCoZAC3eUQ
/ObmHdo+Vbzkgsv2pB8nXncYwCyvNNsd66aw32CI3UwwbcajHHH1Mo7OVIHzwfgh
MpjkkDuQ8Wg5LNZ8OeHN
=FfY0
-----END PGP SIGNATURE-----

--76DTJ5CE0DCVQemd--
