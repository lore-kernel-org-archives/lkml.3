Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3GAEii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 00:38:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35635 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab3GAEih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 00:38:37 -0400
Date: Mon, 1 Jul 2013 14:38:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: linux-next: manual merge of the trivial tree with the fbdev tree
Message-Id: <20130701143824.dcff27129ecf4b29e836401e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__1_Jul_2013_14_38_24_+1000_IUZgo81xS8uuMOBL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Jul_2013_14_38_24_+1000_IUZgo81xS8uuMOBL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/video/omap2/displays/panel-n8x0.c between commit ecc8b3708986
("OMAPDSS: Add panel dev pointer to dssdev") from the fbdev tree and
commit 8b513d0cf603 ("treewide: Fix typo in printk") from the trivial
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/omap2/displays/panel-n8x0.c
index d3860c5,860b180..0000000
--- a/drivers/video/omap2/displays/panel-n8x0.c
+++ b/drivers/video/omap2/displays/panel-n8x0.c
@@@ -527,7 -527,7 +527,7 @@@ static int n8x0_panel_update(struct oma
  	dh =3D dssdev->panel.timings.y_res;
 =20
  	if (x !=3D 0 || y !=3D 0 || w !=3D dw || h !=3D dh) {
- 		dev_err(dssdev->dev, "invaid update region %d, %d, %d, %d\n",
 -		dev_err(&dssdev->dev, "invalid update region %d, %d, %d, %d\n",
++		dev_err(dssdev->dev, "invalid update region %d, %d, %d, %d\n",
  			x, y, w, h);
  		return -EINVAL;
  	}

--Signature=_Mon__1_Jul_2013_14_38_24_+1000_IUZgo81xS8uuMOBL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR0QfGAAoJEECxmPOUX5FEI28QAIr60hm9BliHiYyyOcrwvx4J
mFJG27KVqUi19GycOySGzmy8o4V3db4owJZh9ZjlzHlo6zR5B0mqUXVVAqIuXRGO
Qr8RpV7e44T0aY6oIpou0SVFlHDRtv9JbHXCAAFTH+leztVDDnikE1Mub/1nx9Fr
2KhUtv2pTeH7/kuDiHo6a0uPwCdb2Seflqadx1s4HTUA7SCB9W9edbgGAAM6IOB0
v06n13r8sFf2Ii9jBA0NskCFvUXp3u0KAXNbkjodfGacMjgR5WxYuH9puu9OA8NE
HgrzJJtMyjYLpxnzBAKOQZI3NtQTeXfwjY/2trXLwNctHqaLzsYRPVPFJZRWqRyA
RGaA2h1u5eYremSbnC53uHP6CEfJOZ8zWFDqsvwDivunZUhQXGQteIRyhhiBAluT
9fPX7FoxGVgjXdG7nm80RaPatkxag+VXrYPhGZn5JBtLeKEUdCEEGyTzbzxxSQCS
ZQV8wWHmwvbJ35np6NiOCBbY1xMoTN6EbFcLbGyLnBS+b7/d9gfup8kDJlCWqBcn
Bm6YsLv42Fm6QKF4yVXmwIXCnnqGH9XIXMfMsBpX2OIHNBgmnShqkriuBfnRx2Cw
ZJiOxLdqlVHSiFQRbUBlUo76bf7m+faa+ylD5IULQjyAIjyYEgTgyR3FAiIltJRV
oDQ2ldSKViWE1VpFoGnz
=nm7Z
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Jul_2013_14_38_24_+1000_IUZgo81xS8uuMOBL--
