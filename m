Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbaDIXFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 19:05:04 -0400
Received: from ozlabs.org ([103.22.144.67]:35908 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719AbaDIXFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 19:05:01 -0400
Date: Thu, 10 Apr 2014 09:04:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [GIT PULL] fbdev reorder for 3.15
Message-Id: <20140410090453.ef611201b91c4b3dbb2a9af4@canb.auug.org.au>
In-Reply-To: <CA+55aFytXaTBE6Uf2H=C-XX01Pk1-QArF6u7+yhditk-cJLVQw@mail.gmail.com>
References: <5345258C.1070308@ti.com>
	<CA+55aFytXaTBE6Uf2H=C-XX01Pk1-QArF6u7+yhditk-cJLVQw@mail.gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_Apr_2014_09_04_53_+1000_4o=ITFChVmPzLQKX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Apr_2014_09_04_53_+1000_4o=ITFChVmPzLQKX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Wed, 9 Apr 2014 12:23:47 -0700 Linus Torvalds <torvalds@linux-foundation=
.org> wrote:
>
> Are there other things pending in this area? Because if there are, I
> think I'll take you up on your "or we can rebase on top of -rc1" offer
> instead.

I have only 2 other commits that touch drivers/video in linux-next and
they are both from Tomi and both only touch a couple of files in
drivers/video/omap2/dss (and drivers/video/fbdev/omap2/dss/ since one of
them is based after the move).

I also have the following merge fix patch in linux-next (maybe you
already have this in the test merge branches):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 4 Mar 2014 16:11:12 +1100
Subject: [PATCH] video: fbdev: fix up for removal of SGI Visual Workstation

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/video/fbdev/Kconfig  | 11 +----------
 drivers/video/fbdev/Makefile |  1 -
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 31c3f3ddfd38..6b1984c7f4e7 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -765,18 +765,9 @@ config FB_HGA
 	  As this card technology is at least 25 years old,
 	  most people will answer N here.
=20
-config FB_SGIVW
-	tristate "SGI Visual Workstation framebuffer support"
-	depends on FB && X86_VISWS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  SGI Visual Workstation support for framebuffer graphics.
-
 config FB_GBE
 	bool "SGI Graphics Backend frame buffer support"
-	depends on (FB =3D y) && (SGI_IP32 || X86_VISWS)
+	depends on (FB =3D y) && SGI_IP32
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
diff --git a/drivers/video/fbdev/Makefile b/drivers/video/fbdev/Makefile
index 6ef2c66110e3..0284f2a12538 100644
--- a/drivers/video/fbdev/Makefile
+++ b/drivers/video/fbdev/Makefile
@@ -55,7 +55,6 @@ obj-$(CONFIG_FB_CG14)             +=3D cg14.o sbuslib.o
 obj-$(CONFIG_FB_P9100)            +=3D p9100.o sbuslib.o
 obj-$(CONFIG_FB_TCX)              +=3D tcx.o sbuslib.o
 obj-$(CONFIG_FB_LEO)              +=3D leo.o sbuslib.o
-obj-$(CONFIG_FB_SGIVW)            +=3D sgivwfb.o
 obj-$(CONFIG_FB_ACORN)            +=3D acornfb.o
 obj-$(CONFIG_FB_ATARI)            +=3D atafb.o c2p_iplan2.o atafb_mfb.o \
                                      atafb_iplan2p2.o atafb_iplan2p4.o ata=
fb_iplan2p8.o
--=20
1.9.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__10_Apr_2014_09_04_53_+1000_4o=ITFChVmPzLQKX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTRdIZAAoJEMDTa8Ir7ZwVn1gP/2yutmGOsUE+PQkBp/AQrmJ0
MQYEHYD9OWV+4ENMWfETVcKUE6I+yIDJELZUkj71cli5HXMEApvNhB1wwWN3eoCj
U6f+QcbhaSkYBw3y8931koRcuoIZ2xS2mmVLGzgbzjznKPgTpDVhRxKSR9xJeY0H
IwxKcovfpTOoAOpq2xNXv/vWzdNoA9YE8GlQ2EK1Ajd/3KrVwIN3QSqPS4lPxsRc
TsQmD6usMIUlRmALX+b8SU2nhZGkxWIVwU7QSsjPIY6sZyQ1t8MV2JhROjx0/9UY
NZ+pP3mr8Rcdqkq57UsAbOGjK9rYNAIZqC5mQuFBMhF2Ot4kauuaKP9YJjUSdHWb
HCBXp313S+fXeBtqo6KEzi5JM1wduMzgUP7aCgjoq9je21n31NsEYqsUH+EgjLAh
gzEhsn4o9vkhpwfGDJO2WnD0Wudc8bF9d+O9wZ/d+I0cwe3FSXgAmD8C7lpI+232
g1qtFGLADx6Erz7mkXxkb2VeE3WotQFqRkHkPa/FyMOwfn2P8C/aM36ZmCEqqdQV
/Z9E46/syLT4UZs+V8PzAgDylWB5hnIvMFi17QHE0f+jfkOfnV5Ws1gc5raFgPW5
qcZUQQkcsO9aKWP5WNsMyfYggRD7Pa+Np+WJiXhK0kX2fwRRsbCdxhBEGs/92Jq4
nBsnc6oBjqENy03vYO/c
=K7zK
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Apr_2014_09_04_53_+1000_4o=ITFChVmPzLQKX--
