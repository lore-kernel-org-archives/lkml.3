Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbaD1VEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:04:14 -0400
Received: from mout.gmx.net ([212.227.17.20]:51835 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbaD1VEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:04:12 -0400
Date: Mon, 28 Apr 2014 22:54:31 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        peter.p.waskiewicz.jr@intel.com, oat.elena@gmail.com,
        dan.carpenter@oracle.com, w-lkml@lebenslange-mailadresse.de,
        teobaluta@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] staging: rtl8188eu: fix Coverity defects in
 os_dep/ioctl_linux.c
Message-ID: <20140428225431.2ea55d58@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/xgnGmM50=Jv87MudXB/IFu7"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:lxLJzW1OPTKgMst41ScaqbgKAFGH9BBCg/JuXj3jQqsX8fFfAyK
 9RalAzJNSZAvmRHzJ6sFpdn6Bw0h4+USjTPF2qq1X9qKoqwjGumg7U5bfyoJ3X7zILurfEe
 iuFm9qYXtsi+THM/ycEzS8mKoUd003BZO7Lu0sYaZKgjo10Y8is5PjIhufI/yrkzx0GpTU8
 NNQeA7r7h4U7LQMQwYuJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xgnGmM50=Jv87MudXB/IFu7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This is a cleanup of staging/rtl8188eu/os_dep/ioctl_linux.c regarding Cover=
ity
resource leak findings.

The changes leave the current implementation intact and just attack the pro=
blems
in the error paths, however, it seems that we could get easily rid of some =
of
the mallocs altogether.

   char *input =3D kmalloc(wrqu->data.length, GFP_KERNEL);
   copy_from_user(input, wrqu->data.pointer, wrqu->data.length);
   qAutoLoad =3D strncmp(input, "autoload", 8);

The series is compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

Christian Engelmayer (5):
  staging: rtl8188eu: fix potential leak in rtw_wx_read32()
  staging: rtl8188eu: fix potential leak in rtw_wx_set_enc_ext()
  staging: rtl8188eu: fix potential leak in rtw_mp_QueryDrv()
  staging: rtl8188eu: fix potential leak in rtw_mp_SetRFPath()
  staging: rtl8188eu: fix potential leak in rtw_mp_pwrtrk()

 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 69 +++++++++++++++++-----=
----
 1 file changed, 45 insertions(+), 24 deletions(-)

--=20
1.9.1

--Sig_/xgnGmM50=Jv87MudXB/IFu7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXsAHAAoJEKssnEpaPQKEwZYP/Atfnd9RB5wBb4KDSK6JO/63
8C6HH2dlKR9DGnXXBGpngHdsBsz/X+IyqOmAHVt6msFdSthj5bzmr9VB3YPRN/KH
N2SDGp4rLVwaPYgkKCd47fAgPAgiBFQKaOGSB7uHtGVm9HTJ2JzQ1d7sYjLbfhqc
dUab3abuOZEpfXg+5flJTD07bUtF/+jzUYrcZFiYAqDJXs82a05RXfTBoRKuusjU
8vdDmSX4jnEnrz55YrnAx0wXboPgVdg9WcTj3fGI87fUU7sGsS2Xle/69TiXvcGL
GWCxWIV5KCvYBbw8odEtnChVPmk6TxQZZQgw4IfU88R3OsonwkmVi7ZC3q8a+CtG
ZjJeTSNOuNgiWFeiE/kUT+7UfQK/eohtCZFsqqI/N6t4aYe0uWkDkiI3t8yZ3S+H
MWCWjfsxNTDVUxvDHkZ0seRpMHq9xGpyHgtpCgekb45zYP0V++UgEW0csfHTN7E+
7xiynyHizQAarMTcwWiyr4jknPQu8U5j04PCYT6nY4I2NxAFM1W2UVFTY442kUd2
izwMVduRG+QbWSUCT/Urbua986W1EDr+kRj7o4+hKyYS8/MUElttK6AvsmMh9XH1
lwS6RyueGUmXvQsQRjWD0Cp66EnTF0E+/cIgle3yNJXOzkaO3y/FVfC0NWMQqGIG
uunSvTHLAV6mcuuvbhTx
=hHee
-----END PGP SIGNATURE-----

--Sig_/xgnGmM50=Jv87MudXB/IFu7--
