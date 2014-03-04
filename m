Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaCDDfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 22:35:54 -0500
Received: from ozlabs.org ([203.10.76.45]:58080 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999AbaCDDfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 22:35:53 -0500
Date: Tue, 4 Mar 2014 14:35:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: linux-next: build failure after merge of the omap_dss2 tree
Message-Id: <20140304143543.4ab2321f14a61d84bb63b692@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Mar_2014_14_35_43_+1100_4Ky9lYRYA_YIKbTB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Mar_2014_14_35_43_+1100_4Ky9lYRYA_YIKbTB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

After merging the omap_dss2 tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from drivers/staging/xgifb/XGIfb.h:3:0,
                 from drivers/staging/xgifb/vb_init.c:4:
drivers/staging/xgifb/vgatypes.h:5:38: fatal error: ../../video/sis/vgatype=
s.h: No such file or directory
 #include "../../video/sis/vgatypes.h"
                                      ^
In file included from drivers/staging/xgifb/XGIfb.h:3:0,
                 from drivers/staging/xgifb/vb_setmode.c:2:
drivers/staging/xgifb/vgatypes.h:5:38: fatal error: ../../video/sis/vgatype=
s.h: No such file or directory
 #include "../../video/sis/vgatypes.h"
                                      ^
In file included from drivers/staging/xgifb/vb_util.c:1:0:
drivers/staging/xgifb/vgatypes.h:5:38: fatal error: ../../video/sis/vgatype=
s.h: No such file or directory
 #include "../../video/sis/vgatypes.h"
                                      ^
In file included from drivers/staging/xgifb/XGIfb.h:3:0,
                 from drivers/staging/xgifb/XGI_main.h:4,
                 from drivers/staging/xgifb/XGI_main_26.c:16:
drivers/staging/xgifb/vgatypes.h:5:38: fatal error: ../../video/sis/vgatype=
s.h: No such file or directory
 #include "../../video/sis/vgatypes.h"
                                      ^

Caused by commit 08667731d1d4 ("video: move fbdev to
drivers/video/fbdev").

I have applied this merge fix patch (you should add it to your tree):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 4 Mar 2014 14:28:03 +1100
Subject: [PATCH] video: staging fixup for drivers movement

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/xgifb/vb_def.h    | 2 +-
 drivers/staging/xgifb/vb_struct.h | 2 +-
 drivers/staging/xgifb/vgatypes.h  | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/xgifb/vb_def.h b/drivers/staging/xgifb/vb_def.h
index 5c739bebd8a5..949f0e5eed8d 100644
--- a/drivers/staging/xgifb/vb_def.h
+++ b/drivers/staging/xgifb/vb_def.h
@@ -1,6 +1,6 @@
 #ifndef _VB_DEF_
 #define _VB_DEF_
-#include "../../video/sis/initdef.h"
+#include "../../video/fbdev/sis/initdef.h"
=20
 #define VB_XGI301C      0x0020 /* for 301C */
=20
diff --git a/drivers/staging/xgifb/vb_struct.h b/drivers/staging/xgifb/vb_s=
truct.h
index c08ff5b2d6ee..0d27594554ca 100644
--- a/drivers/staging/xgifb/vb_struct.h
+++ b/drivers/staging/xgifb/vb_struct.h
@@ -1,6 +1,6 @@
 #ifndef _VB_STRUCT_
 #define _VB_STRUCT_
-#include "../../video/sis/vstruct.h"
+#include "../../video/fbdev/sis/vstruct.h"
=20
 struct XGI_LVDSCRT1HDataStruct {
 	unsigned char Reg[8];
diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgaty=
pes.h
index ddf7776c295b..264351441f99 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -2,8 +2,8 @@
 #define _VGATYPES_
=20
 #include <linux/fb.h>	/* for struct fb_var_screeninfo for sis.h */
-#include "../../video/sis/vgatypes.h"
-#include "../../video/sis/sis.h"		/* for LCD_TYPE */
+#include "../../video/fbdev/sis/vgatypes.h"
+#include "../../video/fbdev/sis/sis.h"		/* for LCD_TYPE */
=20
 #ifndef XGI_VB_CHIP_TYPE
 enum XGI_VB_CHIP_TYPE {
--=20
1.9.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__4_Mar_2014_14_35_43_+1100_4Ky9lYRYA_YIKbTB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFUoUAAoJEMDTa8Ir7ZwV1/0P/2wNfrOZvblQNIy/JtB6Bqyc
/tP9oh0yRw1VZcpslInZhQjqAVKIKT0zrtu8mUPc0fHdQIymjZ0dqvBR3R8Nay4z
Wdv+PoHVqkGl/s/JCE3eMYfpK6Ef6cwDnJPVCv9+UhiRj02Osf08KOuJHYoDQvz2
mR/2XspcXDhP+SCHnavu0l1e9VWHa+124amQvnHTfU5/PPz+7YbV6VSGfBku9X5o
AIGx9kj2URvZqNj3zDSuZzH2iCmeBuU+QsNu7J1uIBh7g09n6Bsma7HP6K4EjzyQ
n5hKmy4vLIIo9IFYv/ykoQSjYBcwtHOs+En868EzbV6TgXxYw3gbCNR05JN+dYtY
mcvspooEReMYP4L98YP6oohivY+FmGVx26NPRlOV1lSRcUujT4fJoIu8Tfb3z4zs
aAca7rjSh6UbYupUQBFQAug9WlDT6tDenYI3IfvnJL4vy4GY3+jGsVZSTwj/BckP
a3jVkwuu+fnRYj+gWnZ4MoQ5ZcSXqXh+exloMqCswYydxtqnUnqwauyBYyr4V3u1
zWXoLjkq1bm2RPFoqK9HJMRPA84voj4FAgC7NSEwvDznJLyTMg65eGMeLMnyvyY+
idEisep8juXk4st1ftVEtr/HfTnpzO1b0sQzDcgPfxtKlAE/HgU3msDuZGXs24iy
7WCko5eSJxsYPoiMiywI
=gcb2
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Mar_2014_14_35_43_+1100_4Ky9lYRYA_YIKbTB--
