Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaKFEnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:43:39 -0500
Received: from ozlabs.org ([103.22.144.67]:54171 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbaKFEni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:43:38 -0500
Date: Thu, 6 Nov 2014 15:43:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tapasweni Pathak <tapaswenipathak@gmail.com>,
        Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the y2038 tree with the staging tree
Message-ID: <20141106154311.3907b565@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/9QcPEsjF=6zU8wKNzpctXO="; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/9QcPEsjF=6zU8wKNzpctXO=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the y2038 tree got a conflict in
drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c between commit
ecdd21c7b982 ("staging: ft1000: Whitespace neatening") from the staging
tree and commit 4115d2b27a50 ("staging: ft1000: Replace timeval and
time_t with time64_t") from the y2038 tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 11dbe369e18b,9a9655cdc64d..000000000000
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@@ -1019,29 -1055,19 +1019,29 @@@ static void ft1000_proc_drvmsg(struct n
  			info->CardReady =3D 1;
  			break;
  		case MEDIA_STATE:
 -			pmediamsg =3D (struct media_msg *) & cmdbuffer[0];
 +			pmediamsg =3D (struct media_msg *)&cmdbuffer[0];
  			if (info->ProgConStat !=3D 0xFF) {
 -			if (pmediamsg->state) {
 -				DEBUG(1, "Media is up\n");
 -				if (info->mediastate =3D=3D 0) {
 -					netif_carrier_on(dev);
 -					netif_wake_queue(dev);
 -					info->mediastate =3D 1;
 -					time =3D get_seconds();
 -					info->ConTm =3D time;
 +				if (pmediamsg->state) {
 +					pr_debug("Media is up\n");
 +					if (info->mediastate =3D=3D 0) {
 +						netif_carrier_on(dev);
 +						netif_wake_queue(dev);
 +						info->mediastate =3D 1;
- 						do_gettimeofday(&tv);
- 						info->ConTm =3D tv.tv_sec;
++						time =3D get_seconds();
++						info->ConTm =3D time;
 +					}
 +				} else {
 +					pr_debug("Media is down\n");
 +					if (info->mediastate =3D=3D 1) {
 +						info->mediastate =3D 0;
 +						netif_carrier_off(dev);
 +						netif_stop_queue(dev);
 +						info->ConTm =3D 0;
 +					}
  				}
 -			} else {
 -				DEBUG(1, "Media is down\n");
 +			}
 +			else {
 +				pr_debug("Media is down\n");
  				if (info->mediastate =3D=3D 1) {
  					info->mediastate =3D 0;
  					netif_carrier_off(dev);

--Sig_/9QcPEsjF=6zU8wKNzpctXO=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWvxlAAoJEMDTa8Ir7ZwVV2cP/iFE7QgZO+TJH0xRdoaCx7gm
OAXggw/GIGP9XndrMPhcFDfIPhTq4+QpCYMOkZHak1rrCwNisI0W+MOlSn7DG8Pq
MPQlZmOAgRt8zhE6POPPtRkl04sXC9Lrw+5YFJg807L1ICDB2qu+nuPtxOgA5/rp
+DQu1JXHMraz6egoQ8cubEW7Fpi7iK3Ykrj8Q3wWCEKX+F8238M++/nG7wUbD/72
B0QGBDQqT2rntOcNx60lPYcxsjl8Ogxd1eoikO7bPV+fwgwIz3BBzxt4IMYHjuQm
bfX9JPMDxngJ6J4acpAZyHxizXY6QPW1IudsI4EqXiQvlQWAdb8v+8jJP9blxAKg
F4avi7sOzP54o/5PJy4/su4mp0ZEuXC3AyrDNE5f2kQ+SI+la1VKL0SwtJQvcrhg
VE3ehw5/ATWsQwaMkn8apfpY5gi9WB0LeoC7KiAn3zJYIe4HFrUIrAi7SETjP19d
xzVCMRmxuAV44pCo08pdpjVQLR6ueIHHLJbJMNFSHF7FlHmhxJTQ6itH/vcazRYy
7F/Pv+hvB4vgq80vQneH4tVjsMg61R4Eglou+Fvl4oBHniqjfSHgphCmH1lITAvD
WXQ6I5xZhBYkZT0wIx1+RJomYzbpsnlii2SQ6MIjp8/RC2Ec4tvg89IWakMvSERD
3VsbxefQoZ5Gyb0lrbX8
=59Uq
-----END PGP SIGNATURE-----

--Sig_/9QcPEsjF=6zU8wKNzpctXO=--
