Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3LATZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 14:25:22 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:46794 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3LATZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 14:25:18 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Compile failure on linux-n900 branch -- MEDIA_CAMERA_SUPPORT needed for n900 compilation
Date: Sun, 1 Dec 2013 20:25:13 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: sre@ring0.de, sre@debian.org, kernel list <linux-kernel@vger.kernel.org>
References: <20131127125149.GA9389@amd.pavel.ucw.cz> <201312011050.18256@pali> <20131201192120.GD9743@amd.pavel.ucw.cz>
In-Reply-To: <20131201192120.GD9743@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16701173.Ygq5ElTYrD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312012025.13622@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart16701173.Ygq5ElTYrD
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 01 December 2013 20:21:20 Pavel Machek wrote:
> Hi!
>=20
> I just hit this one:
>=20
>   CC      arch/arm/mach-omap2/board-rx51-camera.o
> In file included from
> arch/arm/mach-omap2/board-rx51-camera.c:34:0:
> arch/arm/mach-omap2/../../../drivers/media/platform/omap3isp/
> isp.h: In function 'isp_pad_buffer_type':
> arch/arm/mach-omap2/../../../drivers/media/platform/omap3isp/i
> sp.h:347:19: error: 'const struct v4l2_subdev' has no member
> named 'entity'
> arch/arm/mach-omap2/../../../drivers/media/platform/omap3isp/
> isp.h:350:12: error: 'const struct v4l2_subdev' has no member
> named 'entity' make[1]: ***
> [arch/arm/mach-omap2/board-rx51-camera.o] Error 1 make: ***
> [arch/arm/mach-omap2] Error 2
> make: *** Waiting for unfinished jobs....
> Command exited with non-zero status 2
>=20
> Problem seems to be that isp.h expects CONFIG_MEDIA_CONTROLLER
> to be set, but board-rx51-camera.c is always compiled. We
> could do
>=20
> config MACH_NOKIA_RX51
>         bool "Nokia N900 (RX-51) phone"
> -        depends on ARCH_OMAP3
> +        depends on ARCH_OMAP3 && MEDIA_CONTROLLER
>         default y
> 	select OMAP_PACKAGE_CBB
>=20
> ...but that's cruel to the user. Would this be acceptable?
>=20
> config MACH_NOKIA_RX51
>         bool "Nokia N900 (RX-51) phone"
>         depends on ARCH_OMAP3
>         default y
> 	select OMAP_PACKAGE_CBB
> +	select MEDIA_CONTROLLER
> +       select MEDIA_CAMERA_SUPPORT
>=20
> 									Pavel

board-rx51-camera.c is not part of mainline kernel and will never=20
be (due to DT migration). So maybe it could be better to add=20
#ifdef to board-rx51-camera.c. Keeping changes for Makefile/Kconfig=20
files is harder because of future rebase...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart16701173.Ygq5ElTYrD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKbjRkACgkQi/DJPQPkQ1IkpACfQtLEYBG8XOkIL4bFBBaEJzsZ
Gb0AniWwDq9tssXufjcIHYN8et9pgG78
=UG6w
-----END PGP SIGNATURE-----

--nextPart16701173.Ygq5ElTYrD--
