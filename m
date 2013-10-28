Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab3J1OXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:23:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43615 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab3J1OXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:23:30 -0400
Date: Tue, 29 Oct 2013 01:23:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: linux-next: build failure after merge of the final tree (fbdev tree
 related)
Message-Id: <20131029012317.b9ba8173dee5bac1a5bd2404@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Oct_2013_01_23_17_+1100_DShg+nNpREjrw96n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Oct_2013_01_23_17_+1100_DShg+nNpREjrw96n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

drivers/video/xilinxfb.c: In function 'xilinxfb_of_probe':
drivers/video/xilinxfb.c:431:30: error: 'op' undeclared (first use in this =
function)

Caused by commit 353846fb8bb7 ("video: xilinxfb: Use standard variable
name convention") from the fbdev tree.

I have applied the following fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 29 Oct 2013 01:18:22 +1100
Subject: [PATCH] video: xilinxfb: Fix for "Use standard variable name conve=
ntion"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/video/xilinxfb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 9eedf9673b7f..6ff1a91e9dfd 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -428,11 +428,11 @@ static int xilinxfb_of_probe(struct platform_device *=
pdev)
 #ifdef CONFIG_PPC_DCR
 	else {
 		int start;
-		start =3D dcr_resource_start(op->dev.of_node, 0);
-		drvdata->dcr_len =3D dcr_resource_len(op->dev.of_node, 0);
-		drvdata->dcr_host =3D dcr_map(op->dev.of_node, start, drvdata->dcr_len);
+		start =3D dcr_resource_start(pdev->dev.of_node, 0);
+		drvdata->dcr_len =3D dcr_resource_len(pdev->dev.of_node, 0);
+		drvdata->dcr_host =3D dcr_map(pdev->dev.of_node, start, drvdata->dcr_len=
);
 		if (!DCR_MAP_OK(drvdata->dcr_host)) {
-			dev_err(&op->dev, "invalid DCR address\n");
+			dev_err(&pdev->dev, "invalid DCR address\n");
 			return -ENODEV;
 		}
 	}
--=20
1.8.4.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__29_Oct_2013_01_23_17_+1100_DShg+nNpREjrw96n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSbnNbAAoJEMDTa8Ir7ZwVnooP/1LS+f9SxGMr6WGR2JJtFZ8E
jojjonFKb6Fs8lLRUuEOeBDbPEW/SmRu0dkNhsPHU1vGIKUtKfI+dVL9Y9ZBF45k
IQwmMATMOK9Z7R78s2cXW0rB7+8lrCtWRSNdWXJDSj0hrDnrrzwNCRTtwla/9tWZ
N7vg94dG7lDLNaBgZqjiEuH0k1BTcLk++PNi4c0X2zdEx5242do3Uk1Bx97P19ej
Gbud4ZsK/pQhyBJcdTJLNZOIPWR6Owg30wf/xECw73lbe6hmjxa2DTLlhRXriUgR
1wgBt7yRnGVymZwM8l6GFYcOTyU3SUATbE0uIR5rGs/Pwf8dFavgMUQJlkv7IF6/
5XSBpD7XPKGpNyqMNHt2epQn+WFB0jY8taV1Aa9Vlh2vVY0xtfHGQ9hsR9lvf/rt
w4tXAjO79kfUbvIZrm4ue92vkWhAcQwtml+sPeYqR6C8CElfU6+EUFlSQ14X7WeW
DIbNyC488mbwOcPIH0Sw1q2kC4mssScMuiqGqlsOjQ/w7EZSYCXvPwTUbSV7mQvL
5T1sKr7257CPDse95eYD1QgfPANFI2k76N28/TaG+onwbqcMRZZb7XiI32Xy7+d0
C4kz9SjfTJWoSKwTIjIadhE6b0k1g/cvlwtORdwdir10yQCkLXA9rdjw6UroiseR
FVx0ce0MWTfXhYWsjPA9
=h1yv
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Oct_2013_01_23_17_+1100_DShg+nNpREjrw96n--
