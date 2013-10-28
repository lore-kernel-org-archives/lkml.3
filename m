Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab3J1Od3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:33:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35155 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab3J1Od1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:33:27 -0400
Date: Tue, 29 Oct 2013 01:33:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Suneel Garapati <suneelg@xilinx.com>,
        Vlad Lungu <vlad.lungu@windriver.com>, Greg KH <greg@kroah.com>
Subject: linux-next: build failure after merge of the final tree (tty tree
 related)
Message-Id: <20131029013317.a33ae4ff86b88ea17bb58e74@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Oct_2013_01_33_17_+1100_6ks+RfSX9gj2x=0x"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Oct_2013_01_33_17_+1100_6ks+RfSX9gj2x=0x
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/tty/serial/xilinx_uartps.c: In function 'xuartps_clk_notifier_cb':
drivers/tty/serial/xilinx_uartps.c:436:7: error: 'PRE_RATE_CHANGE' undeclar=
ed (first use in this function)
  case PRE_RATE_CHANGE:
       ^
drivers/tty/serial/xilinx_uartps.c:436:7: note: each undeclared identifier =
is reported only once for each function it appears in
drivers/tty/serial/xilinx_uartps.c:446:36: error: dereferencing pointer to =
incomplete type
   if (!xuartps_calc_baud_divs(ndata->new_rate, xuartps->baud,
                                    ^
drivers/tty/serial/xilinx_uartps.c:461:7: error: 'POST_RATE_CHANGE' undecla=
red (first use in this function)
  case POST_RATE_CHANGE:
       ^
drivers/tty/serial/xilinx_uartps.c:470:24: error: dereferencing pointer to =
incomplete type
   port->uartclk =3D ndata->new_rate;
                        ^
drivers/tty/serial/xilinx_uartps.c:475:7: error: 'ABORT_RATE_CHANGE' undecl=
ared (first use in this function)
  case ABORT_RATE_CHANGE:
       ^
drivers/tty/serial/xilinx_uartps.c: In function 'xuartps_probe':
drivers/tty/serial/xilinx_uartps.c:1385:2: error: implicit declaration of f=
unction 'clk_notifier_register' [-Werror=3Dimplicit-function-declaration]
  if (clk_notifier_register(xuartps_data->refclk,
  ^
drivers/tty/serial/xilinx_uartps.c:1418:2: error: implicit declaration of f=
unction 'clk_notifier_unregister' [-Werror=3Dimplicit-function-declaration]
  clk_notifier_unregister(xuartps_data->refclk,
  ^

Caused by commits in the tty tree.

I have left this broken for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__29_Oct_2013_01_33_17_+1100_6ks+RfSX9gj2x=0x
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSbnWyAAoJEMDTa8Ir7ZwVmZ4P/0UEoINvgLcACpJBh8kjeyag
yL7Olc4U9VsFps0O4Zs+28YF+e/Rnla0cysgki3drC9TON6g8Lz80Z0/JcN5e/tq
rMNYaV41lHxYvDbk/bX0O8qKosDFuzQg8NE62xYTy3jE0XTSUpjTQaIh0Z1PodSy
RA24gX09YmfcX9j6NtykXbnLj14phDKWthEoh6dTBgdaedaKomL59iju8XQPBRYq
UwCqaMsk/bbvU2tjtcWI3JCjW6RLGujk8BBR0ZKifyR7N7XuLqCuS93zhpq3SpOk
1uJA3qOIlHT8v0dJxGa84uHigRrtjJehcGlr3RDimZPoYmpY0GuiogHBaO903RRt
Y9XkU+3U8LWDHVviEH61TIfm0DEzPFhXniYAY9hQhok9Sw+DqyiDmc+VAE5fNDMl
fEPquuiraizOE2n4POvKlFxUHK5qyhbHjjEynrCiJ59v6UWPgYtexxdQVz/hudLH
VPCWsUHDgW2AzGKHuZK85xVtYbs7M8lWpMojsUtkiDBCyuYgcCLVX3DQHP1RL1sr
NFUV76JX54GZmj0fj64P0uTSOguglck+zBuYt2gZ0Esbbo9yRPxc1H+zBFMWFF+U
POU4LyDIIgUJGFJaFOdpZ5Mu1jSwNNYb49EikI6MI12RTrLG27RclOk1+xh2FygF
NxMq8svlz7tMrOS7/tX3
=iaHC
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Oct_2013_01_33_17_+1100_6ks+RfSX9gj2x=0x--
