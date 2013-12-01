Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab3LAU3s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 15:29:48 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:46814 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3LAU3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 15:29:47 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Compile failure on linux-n900 branch -- MEDIA_CAMERA_SUPPORT needed for n900 compilation
Date: Sun, 1 Dec 2013 21:29:40 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: sre@ring0.de, sre@debian.org, kernel list <linux-kernel@vger.kernel.org>
References: <20131127125149.GA9389@amd.pavel.ucw.cz> <201312012025.13622@pali> <20131201200112.GE9743@amd.pavel.ucw.cz>
In-Reply-To: <20131201200112.GE9743@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4431161.WZZr0yzqd8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312012129.41555@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4431161.WZZr0yzqd8
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 01 December 2013 21:01:13 Pavel Machek wrote:
> Hi!
>=20
> > board-rx51-camera.c is not part of mainline kernel and will
> > never be (due to DT migration). So maybe it could be better
> > to add #ifdef to board-rx51-camera.c. Keeping changes for
> > Makefile/Kconfig files is harder because of future
> > rebase...
>=20
> Ok, that makes sense.
>=20
> This breaks compilation, too, but I don't think I want to fix
> that.
>=20
>   Example code (PVR_EXAMPLES) [N/m/y] (NEW)
>=20
> (Select Y to break compile).
>=20
> Thanks,
> 								Pavel
>=20
> ---
>=20
> Fix compilation in !CONFIG_MEDIA_CAMERA_SUPPORT case, and make
> it such that it is unlikely to cause merge conflicts later.
>=20
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>=20
> diff --git a/arch/arm/mach-omap2/board-rx51-camera.c
> b/arch/arm/mach-omap2/board-rx51-camera.c index
> 8b4b59a..bae2cc0 100644
> --- a/arch/arm/mach-omap2/board-rx51-camera.c
> +++ b/arch/arm/mach-omap2/board-rx51-camera.c
> @@ -31,6 +31,7 @@
>=20
>  #include <asm/gpio.h>
>=20
> +#ifdef CONFIG_MEDIA_CAMERA_SUPPORT
>  #include "../../../drivers/media/platform/omap3isp/isp.h"
>  #include "../../../drivers/media/platform/omap3isp/ispreg.h"
>=20
> @@ -375,9 +376,11 @@ static struct isp_platform_data
> rx51_isp_platform_data =3D { { .dev_id =3D "2-0010"},
>  	.subdevs =3D rx51_camera_subdevs,
>  };
> +#endif
>=20
>  void __init rx51_camera_init(void)
>  {
> +#ifdef CONFIG_MEDIA_CAMERA_SUPPORT
>  	if (rx51_camera_hw_init()) {
>  		printk(KERN_WARNING "%s: Unable to initialize camera\n",
>  		       __func__);
> @@ -387,4 +390,5 @@ void __init rx51_camera_init(void)
>  	if (omap3_init_camera(&rx51_isp_platform_data) < 0)
>  		printk(KERN_WARNING "%s: Unable to register camera=20
platform
> " "device\n", __func__);
> +#endif
>  }

Thanks, I commited patch to linux-n900 tree.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4431161.WZZr0yzqd8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKbnDUACgkQi/DJPQPkQ1KHvwCcCHbLr/DzL5P/RPb4b1IML6oH
lqcAn1kFVLeekByGt7qNjKzGAUt5vr9B
=jJca
-----END PGP SIGNATURE-----

--nextPart4431161.WZZr0yzqd8--
