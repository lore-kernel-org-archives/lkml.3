Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab3J1Ozl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:55:41 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45641 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab3J1Otg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:36 -0400
Message-ID: <526E797B.9000903@monstr.eu>
Date: Mon, 28 Oct 2013 15:49:31 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Suneel Garapati <suneelg@xilinx.com>,
        Vlad Lungu <vlad.lungu@windriver.com>
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
References: <20131029013317.a33ae4ff86b88ea17bb58e74@canb.auug.org.au>
In-Reply-To: <20131029013317.a33ae4ff86b88ea17bb58e74@canb.auug.org.au>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="xmttpKbA8Xuj3J3AfOgsA0gXO4tsPGd00"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xmttpKbA8Xuj3J3AfOgsA0gXO4tsPGd00
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/28/2013 03:33 PM, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>=20
> drivers/tty/serial/xilinx_uartps.c: In function 'xuartps_clk_notifier_c=
b':
> drivers/tty/serial/xilinx_uartps.c:436:7: error: 'PRE_RATE_CHANGE' unde=
clared (first use in this function)
>   case PRE_RATE_CHANGE:
>        ^
> drivers/tty/serial/xilinx_uartps.c:436:7: note: each undeclared identif=
ier is reported only once for each function it appears in
> drivers/tty/serial/xilinx_uartps.c:446:36: error: dereferencing pointer=
 to incomplete type
>    if (!xuartps_calc_baud_divs(ndata->new_rate, xuartps->baud,
>                                     ^
> drivers/tty/serial/xilinx_uartps.c:461:7: error: 'POST_RATE_CHANGE' und=
eclared (first use in this function)
>   case POST_RATE_CHANGE:
>        ^
> drivers/tty/serial/xilinx_uartps.c:470:24: error: dereferencing pointer=
 to incomplete type
>    port->uartclk =3D ndata->new_rate;
>                         ^
> drivers/tty/serial/xilinx_uartps.c:475:7: error: 'ABORT_RATE_CHANGE' un=
declared (first use in this function)
>   case ABORT_RATE_CHANGE:
>        ^
> drivers/tty/serial/xilinx_uartps.c: In function 'xuartps_probe':
> drivers/tty/serial/xilinx_uartps.c:1385:2: error: implicit declaration =
of function 'clk_notifier_register' [-Werror=3Dimplicit-function-declarat=
ion]
>   if (clk_notifier_register(xuartps_data->refclk,
>   ^
> drivers/tty/serial/xilinx_uartps.c:1418:2: error: implicit declaration =
of function 'clk_notifier_unregister' [-Werror=3Dimplicit-function-declar=
ation]
>   clk_notifier_unregister(xuartps_data->refclk,
>   ^
>=20
> Caused by commits in the tty tree.
>=20
> I have left this broken for today.
>=20

Soren: Please correct me if I am wrong.
But this should be fixed by:
"[PATCH 3/3] tty: xuartps: Fix build error when COMMON_CLK is not set"

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--xmttpKbA8Xuj3J3AfOgsA0gXO4tsPGd00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJueXsACgkQykllyylKDCEroQCglGsovvzwq9ib5GvZHVzMlF8W
8acAn3QdO0AhyftPoEknmMG3UNT2Pp4k
=seVI
-----END PGP SIGNATURE-----

--xmttpKbA8Xuj3J3AfOgsA0gXO4tsPGd00--
