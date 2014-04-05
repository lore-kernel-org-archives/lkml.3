Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaDEWhE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 18:37:04 -0400
Received: from mout.gmx.net ([212.227.15.18]:65523 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbaDEWhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 18:37:01 -0400
Date: Sun, 6 Apr 2014 00:36:49 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] modpost: Fix ressource leak in read_dump()
Message-ID: <20140406003649.1ba3c993@spike>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/K/Q6=w.Begg1bhk1B4iX5RC"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:uDPmdjWyP/yiOjWCkyBnDF/Jdbfex5dIaqN165udzjFmsy1CCKH
 m09LEQHbhfe1N//wLEemKAim3JWKLMTHczDIGft7rJEZ2P+hBTx6p633yW9uLuqf4M+fQJP
 N1ja2qSFCxwS4vtjcvvdbXALqbrrrzkpkuPVJI0vr9kS9xfK+Bm2eBHL/Mxy1h0u1WW4FSt
 F5Eqwa2WSXRwdYgpQgxLg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/K/Q6=w.Begg1bhk1B4iX5RC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Function read_dump() memory maps the input via grab_file(), but fails to ca=
ll
the corresponding unmap function. Add the missing call to release_file().
Detected by Coverity: CID 1192419

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested - Applies against v3.14 as well as linux-next.
---
 scripts/mod/modpost.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 0663556..ea3e2bd 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -2113,8 +2113,10 @@ static void read_dump(const char *fname, unsigned in=
t kernel)
 		s->preloaded =3D 1;
 		sym_update_crc(symname, mod, crc, export_no(export));
 	}
+	release_file(file, size);
 	return;
 fail:
+	release_file(file, size);
 	fatal("parse error in symbol dump file\n");
 }
=20
--=20
1.8.3.2

--Sig_/K/Q6=w.Begg1bhk1B4iX5RC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTQIWBAAoJEKssnEpaPQKEZY8P/17wdX2Cn53C6G1U3yZouFd8
dLiJ6vyqhJ0Esg0E9aZr4VKDFB+ZMm1+ihqe/Tnks+cjRKFjEnlwjYOrKUNS4sMS
jaiFjztlkwiZksr/LXMYS7Ta7xEbCG/6nPXaJhGf4l24Wn5331uVDd9hRanwuqVX
v8mDjTfK/IPczJmh9H6+Q38oH1EHzo+G+9FAKa9xgioOHQJW9nv3yrawqJxUe//i
htb2hUsGQaGNRRJ1NI3hMp6X4aJ2VAW+wdmjW227wDLjlihw5PHM1kSNReEHp52c
Gh8i9sBP1UDaV160rxWYJXBy2wAl8wWzrO+zAvYCbNf3gLp84UQHqBagmpDE4YBV
/t5SIug0YJZmL7XHbjufgXGMNwo67xr3siLd/JjRDSV9lFCNrLA0r1qTaNG71Nfc
1auywMifZ3TChdv5+VHl6mtADvEZi/iBVOCVS3X7frMDBSP4okPJnw7j34VowlWj
MBlJheILYDwEaw1DdmX8+W4lhsTy9GbR8cgQzN2FzkBzGQJj3s+aCAhQDTbBBKQC
EV3ZWqC5rQVf2rLKjy8xjUh75IRfWTbMSU67aHBqyLFeSbt1ZTpIjv+gbuE0ihhE
3KHTfIXzFmvkk5x5NTksidPtUGCw7oT8APFIOd0j1tgfJEofwJI5fjwCeulLmNjw
4x/KJyzIFSyAj9zmDbiP
=UjVE
-----END PGP SIGNATURE-----

--Sig_/K/Q6=w.Begg1bhk1B4iX5RC--
