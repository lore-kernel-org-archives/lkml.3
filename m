Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaKFD1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:27:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57031 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905AbaKFD1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:27:13 -0500
Message-ID: <1415244425.3398.49.camel@decadent.org.uk>
Subject: [PATCH 3/3] i2o: Delete the '64bit fix' comments from
 __i2o_cfg_passthru()
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 06 Nov 2014 03:27:05 +0000
In-Reply-To: <1415244281.3398.46.camel@decadent.org.uk>
References: <1415244281.3398.46.camel@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-OZhqJgrbYR4l8RgCVTei"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OZhqJgrbYR4l8RgCVTei
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We can't fix an API that is broken by definition.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/message/i2o/i2o_config.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_con=
fig.c
index f9a10a8..7529fa1 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -522,6 +522,11 @@ static int i2o_cfg_evt_get(unsigned long arg, struct f=
ile *fp)
 }
=20
 #ifdef CONFIG_I2O_EXT_ADAPTEC
+
+/*
+ * Note: The ioctl is defined to use struct sg_single_element, which
+ * limits it to 32-bit user virtual addresses even on 64-bit systems.
+ */
 static int __i2o_cfg_passthru(unsigned int iop, u32 __user *user_msg)
 {
 	struct i2o_controller *c;
@@ -597,7 +602,6 @@ static int __i2o_cfg_passthru(unsigned int iop, u32 __u=
ser *user_msg)
 			rcode =3D -EFAULT;
 			goto cleanup;
 		}
-		// TODO 64bit fix
 		sg =3D (struct sg_simple_element *)((&msg->u.head[0]) +
 						  sg_offset);
 		sg_count =3D
@@ -635,7 +639,6 @@ static int __i2o_cfg_passthru(unsigned int iop, u32 __u=
ser *user_msg)
 			/* Copy in the user's SG buffer if necessary */
 			if (sg[i].
 			    flag_count & 0x04000000 /*I2O_SGL_FLAGS_DIR */ ) {
-				// TODO 64bit fix
 				if (copy_from_user
 				    (p->virt,
 				     (void __user *)(unsigned long)sg[i].
@@ -647,7 +650,6 @@ static int __i2o_cfg_passthru(unsigned int iop, u32 __u=
ser *user_msg)
 					goto sg_list_cleanup;
 				}
 			}
-			//TODO 64bit fix
 			sg[i].addr_bus =3D (u32) p->phys;
 		}
 	}
@@ -663,7 +665,6 @@ static int __i2o_cfg_passthru(unsigned int iop, u32 __u=
ser *user_msg)
 		u32 rmsg[I2O_OUTBOUND_MSG_FRAME_SIZE];
 		/* Copy back the Scatter Gather buffers back to user space */
 		u32 j;
-		// TODO 64bit fix
 		struct sg_simple_element *sg;
 		int sg_size;
=20
@@ -689,7 +690,6 @@ static int __i2o_cfg_passthru(unsigned int iop, u32 __u=
ser *user_msg)
 		sg_count =3D
 		    (size - sg_offset * 4) / sizeof(struct sg_simple_element);
=20
-		// TODO 64bit fix
 		sg =3D (struct sg_simple_element *)(rmsg + sg_offset);
 		for (j =3D 0; j < sg_count; j++) {
 			/* Copy out the SG list to user's buffer if necessary */
@@ -697,7 +697,6 @@ static int __i2o_cfg_passthru(unsigned int iop, u32 __u=
ser *user_msg)
 			    (sg[j].
 			     flag_count & 0x4000000 /*I2O_SGL_FLAGS_DIR */ )) {
 				sg_size =3D sg[j].flag_count & 0xffffff;
-				// TODO 64bit fix
 				if (copy_to_user
 				    ((void __user *)(unsigned long)sg[j].addr_bus,
 				     sg_list[j].virt, sg_size)) {

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-OZhqJgrbYR4l8RgCVTei
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFrqiue/yOyVhhEJAQpEWxAAlc1gdjkURXIZP3Eidl0KlusGEvhWlaYy
q/5cYeDp2hALTtzyvPHhQnwrvK+XsWO8LoGZOhi53gzVCZsa+4oCypWFPh1cSPvl
BcO+EElt+qvgGM6gUVqDJE9ozwSjARXkPCA0hphqMMoBVQD4CCJYXwt84lnZB1IY
BLuxE+iJGes3CtKNvC/1Tztlw7ow0UQh/BlsLmLelKlR11jiC4UNCUnbZEC072jQ
YXTBnalOra6ydDLdPfduaqSPqx8jDjjyvOvO+Nnn2amoEdDtNi92JT5v4pMglW2n
FH6A2XrWe4KUR2JukV/g3X47fss0Nvtrc3kglvMxy1Brje6MW77501xjbOK4V+hn
G6Yy3PCXzZ/JoKCAX2K67jwzJLAkOTKVpLjz35WpeHIEyvQGttbk2sNJ5KRzq7hT
LSs3OzKNu5lO4pBd8dSe/Z/JiilV8OvZ94aBPhxquaZhlWBQdWQ/eJorYjUp8P7V
YqM4YZIt7lpv+cwZuSv09Nun6r/ZC5Tp+e0PLYgAmVx0veksp6iNzWvl9o999kZl
EyGH3aVnCKDuo5XIN7BCcBDJubenZC1fawShHQbZFaX2LmNa/T+GzloIyIfnlxgk
bd0Ali7hhPnoMBr30Nmj8TLcnKY+y25GOW4+cyXaJQaBGoEfmajysAh6aHrHivew
f60ZLnrA2qE=
=BnEm
-----END PGP SIGNATURE-----

--=-OZhqJgrbYR4l8RgCVTei--
