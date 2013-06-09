Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab3FIRDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 13:03:15 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:35236 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab3FIRDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 13:03:14 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: N900 device tree conversion: how to do first step
Date: Sun, 9 Jun 2013 19:03:08 +0200
User-Agent: KMail/1.13.7 (Linux/3.9.0-rc4+uvd+synaptics-generic; KDE/4.10.4; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        aaro.koskinen@iki.fi, linux-omap@vger.kernel.org, freemangordon@abv.bg,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
References: <20130609015944.GA23559@amd.pavel.ucw.cz> <201306091124.41251@pali> <20130609164745.GB16066@amd.pavel.ucw.cz>
In-Reply-To: <20130609164745.GB16066@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6055323.VniHuSWUpp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201306091903.09766@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6055323.VniHuSWUpp
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 09 June 2013 18:47:45 Pavel Machek wrote:
> On Sun 2013-06-09 11:24:40, Pali Roh=C3=A1r wrote:
> > On Sunday 09 June 2013 03:59:44 Pavel Machek wrote:
> > > Hi!
> > >=20
> > > I'd like to convert Nokia N900 to device tree.
> > >=20
> > > Unfortunately, serial port is not easily available (very
> > > special cable would be needed, does someone know where to
> > > get one?) and I don't have BDI (and very special cable
> > > would be needed, too).
> >=20
> > Hello,
> >=20
> > I used serial port only in qemu for debugging. Maybe you can
> > try to play with qemu first. Qemu has good n900 HW support.
>=20
> Yes, qemu is helpful.
>=20
> For the record: this is how you use it.
>=20
> KERNEL=3D/data/l/linux-n900/zImage_dtb
> ./qflasher -m rx51 -x ./xloader-qemu.bin -s
> ./secondary-qemu.bin -k $KERNEL -o n900.img -p k=3D6072
>=20
> > sd-empty
>=20
> ./qemu-system-arm -s -M n900 -mtdblock n900.img -sd sd-empty
> -serial stdio -clock unix -redir tcp:5555:10.0.2.15:22
>=20
> ...and this patch is needed to make it past rx51_init.
>=20
> Author: Pavel <pavel@ucw.cz>
> Date:   Sun Jun 9 18:45:39 2013 +0200
>=20
>     Comment out errata workaround that breaks qemu.
>=20
> diff --git a/arch/arm/mach-omap2/board-rx51.c
> b/arch/arm/mach-omap2/board-rx51.c index 938e46f..0ffd7d3
> 100644
> --- a/arch/arm/mach-omap2/board-rx51.c
> +++ b/arch/arm/mach-omap2/board-rx51.c
> @@ -108,11 +108,13 @@ static void __init rx51_init(void)
>  	rx51_peripherals_init();
>  	rx51_camera_init();
>=20
> +#if 0
>  #ifdef CONFIG_ARM_ERRATA_430973
>  	printk(KERN_INFO "RX-51: Enabling ARM errata 430973
> workaround.\n"); /* set IBE to 1 */
>  	rx51_secure_update_aux_cr(1 << 6, 0);
>  #endif
> +#endif
>=20
>  	/* Ensure SDRC pins are mux'd for self-refresh */
>  	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);

Hm, right qemu not running in omap secure mode, so it can really=20
break booting. So before calling secure code it is needed to=20
check if we are really on secure device. I think this code help:

if (omap_type() =3D=3D OMAP2_DEVICE_TYPE_SEC)

Can somebody confirm if above check is correct for OMAP3 HS=20
device? And also if it does not pass in qemu?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart6055323.VniHuSWUpp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlG0tU0ACgkQi/DJPQPkQ1JTWgCcDc2GSTnHvQiKGLtin+fIxNem
830AnRAxO5x+yWVPyvUY2/NqrG28TcZU
=4ZnU
-----END PGP SIGNATURE-----

--nextPart6055323.VniHuSWUpp--
