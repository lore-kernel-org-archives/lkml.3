Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbaANAuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:50:32 -0500
Received: from ozlabs.org ([203.10.76.45]:36300 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbaANAu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:50:26 -0500
Date: Tue, 14 Jan 2014 11:50:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: linux-next: manual merge of the v4l-dvb tree with Linus' tree
Message-Id: <20140114115018.b8dfc68565fa0f033a38e606@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__14_Jan_2014_11_50_18_+1100_7atiCk9OgUCJca5m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Jan_2014_11_50_18_+1100_7atiCk9OgUCJca5m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
drivers/staging/media/go7007/go7007-usb.c between commits 66a528c1c3d6
("Revert "staging:media: Use dev_dbg() instead of pr_debug()"") and
e6bbda9da9e8 ("Staging: go7007: fix up some remaining go->dev issues")
from Linus' tree and commit c61c3094a630 ("[media] go7007-usb: only use
go->dev after allocated") from the v4l-dvb tree.

I fixed it up (I basically used the version from the patches in Linus'
tree (they are in v3.13-rc2) - see below) and can carry the fix as necessar=
y (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/media/go7007/go7007-usb.c
index b658c2316df3,1d747de6dfa6..000000000000
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@@ -1099,13 -1097,16 +1099,15 @@@ static int go7007_usb_probe(struct usb_
  		board =3D &board_px_tv402u;
  		break;
  	case GO7007_BOARDID_LIFEVIEW_LR192:
 -		printk(KERN_ERR
 -		       "The Lifeview TV Walker Ultra is not supported. Sorry!\n");
 +		dev_err(&intf->dev, "The Lifeview TV Walker Ultra is not supported. Sor=
ry!\n");
  		return -ENODEV;
+ #if 0
  		name =3D "Lifeview TV Walker Ultra";
  		board =3D &board_lifeview_lr192;
  		break;
+ #endif
  	case GO7007_BOARDID_SENSORAY_2250:
 -		printk(KERN_INFO "Sensoray 2250 found\n");
 +		dev_info(&intf->dev, "Sensoray 2250 found\n");
  		name =3D "Sensoray 2250/2251";
  		board =3D &board_sensoray_2250;
  		break;

--Signature=_Tue__14_Jan_2014_11_50_18_+1100_7atiCk9OgUCJca5m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS1InPAAoJEMDTa8Ir7ZwVE/QP/046TFQZMkmgiYoQTDV614zS
saupnyBcoAjvbDEQhWiUdhnXxl41BvxhLcOvRfVsqIfFKnot6tD+5IWEQA18md6v
Yg8qtWrFUXOYHN1t66yZ350xF3iliEq1JHR3pCrmWyU6jteNBMjrJHCSdn3qdN8v
Ps4pDwzvtVR06XJv4bItapaIPwx5DuU0spaIwzHKdokd/rOK9EEl27btN11bkB6R
TkNPFoTKl33Wg52g3v0j/t6nE/KVXl9DtdM2/8TfON9/cHLiIauP1RZNl5BEmHmQ
yxLYEBVqelt9ST9MvNSLojms9Heoqe4anjh+2OpybAyZrrM+sg6NX2hJFJuaLCjr
o7brOaRYdXbowhLFOnDAiOeUHMA9QduyV96bNoLIy2rnaCcwMHUXDHsBUAGz8yVk
hlZdgk33dO1Xk47OyAAxKd2WRtgSqJMgSJPCml6JV2Bs5tQ5uDvmFS1HrbpQaVqF
JtA1lbax+lBIHCvG6QCM7+Hz3TlcPz99W3myuat9td43GP+fmqSRl+F2N+bkpg8r
ANHKb6NlssPT5/SJ7fiZRpoeHCK4zx+yZIM+UCdnOfmo5PUC5dH5R4Iczi4a52uE
W9mItZLYFaF5za1OxYTYL39eFgLiIVtVj+qi2q8jscLiUc/kyuvdqGF+MEn1cOzX
iXEXm5S8sOkVtFx+nS9+
=ApDJ
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Jan_2014_11_50_18_+1100_7atiCk9OgUCJca5m--
