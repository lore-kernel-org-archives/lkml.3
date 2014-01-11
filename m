Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaAKSJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:09:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59422 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbaAKSJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:09:54 -0500
Message-ID: <52D188DA.6020904@pengutronix.de>
Date: Sat, 11 Jan 2014 19:09:30 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: uclinux-dist-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>, dmaengine@vger.kernel.org
Subject: blackfin + dmaengine: conflicting define/enum "DMA_COMPLETE"
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="UejLngAmEUxIJW3u6G98AGcAaXkTuUBBj"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UejLngAmEUxIJW3u6G98AGcAaXkTuUBBj
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

in current linux-next (and net-next) the compilation of the CAN
drivers[1] with ARCH=3Dblackfin fails with:

>   CC [M]  drivers/net/can/c_can/c_can.o
> In file included from linux/include/linux/netdevice.h:38:0,
>                  from linux/drivers/net/can/c_can/c_can.c:32:
> linux/include/linux/dmaengine.h:55:2: error: expected identifier before=
 numeric constant
> linux/include/linux/dmaengine.h: In function 'dma_async_is_complete':
> linux/include/linux/dmaengine.h:1023:9: error: 'DMA_IN_PROGRESS' undecl=
ared (first use in this function)
> linux/include/linux/dmaengine.h:1023:9: note: each undeclared identifie=
r is reported only once for each function it appears in

There are two locations where DMA_COMPLETE is defined:

> arch/blackfin/mach-bf548/include/mach/defBF547.h:602:#define           =
   DMA_COMPLETE  0x8        /* DMA Complete */
> arch/blackfin/mach-bf548/include/mach/defBF544.h:622:#define           =
   DMA_COMPLETE  0x8        /* DMA Complete */

and

> include/linux/dmaengine.h-enum dma_status {
> include/linux/dmaengine.h:      DMA_COMPLETE,
> include/linux/dmaengine.h-      DMA_IN_PROGRESS,
> include/linux/dmaengine.h-      DMA_PAUSED,
> include/linux/dmaengine.h-      DMA_ERROR,
> include/linux/dmaengine.h-};

What's the appropriate fix for the problem?

Marc

[1] Yes, c_can isn't a blackfin driver, but it's the first one in my
    compile tests and it fails.
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--UejLngAmEUxIJW3u6G98AGcAaXkTuUBBj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlLRiN0ACgkQjTAFq1RaXHNmQACff00DewAZDQ20tz62dIQIszlC
584AmwUydKTzi7JoUfYoRzNMd122NCmM
=Wr7p
-----END PGP SIGNATURE-----

--UejLngAmEUxIJW3u6G98AGcAaXkTuUBBj--
