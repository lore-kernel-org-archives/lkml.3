Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3BFOQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:16:17 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34735 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab3BFOQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:16:15 -0500
Message-ID: <5112659D.50808@ti.com>
Date: Wed, 6 Feb 2013 16:15:57 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Clark <robdclark@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <patches@linaro.org>, <linux-kernel@vger.kernel.org>, <arm@kernel.org>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] OMAPDSS: enable omapdss for ARCH_MULTIPLATFORM
References: <1358891160-9534-1-git-send-email-robdclark@gmail.com> <201301222153.19580.arnd@arndb.de> <201302051631.40254.arnd@arndb.de>
In-Reply-To: <201302051631.40254.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig4033146243A5EA9D21D9E6A2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig4033146243A5EA9D21D9E6A2
Content-Type: multipart/mixed;
 boundary="------------090606060704060100070604"

This is a multi-part message in MIME format.
--------------090606060704060100070604
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi Arnd, Rob,

On 2013-02-05 18:31, Arnd Bergmann wrote:
> On Tuesday 22 January 2013, Arnd Bergmann wrote:
>> On Tuesday 22 January 2013, Rob Clark wrote:
>>> At least core omapdss does not have any build dependencies on
>>> ARCH_OMAP2PLUS, and adding this dependency in the Kconfig breaks omap=
drm
>>> for ARCH_MULTIPLATFORM builds.
>>>
>>> Signed-off-by: Rob Clark <robdclark@gmail.com>
>>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>=20
> It seems nobody has applied this patch, as it has not shown up in
> linux-next or upstream. Who should take care of this? If nobody feels
> responsible, I can put it into arm-soc/fixes.

That would normally be me, but I've been on a long leave, and just came
back. It'll take me some time to get back on track.

I don't think it makes sense to add ARCH_MULTIPLATFORM only for omapdss,
like this patch does. I think we should add it for omapfb and the panel
drivers also.

I did get a report of an omapdss build-break with allyesconfig. It seems
to happen because omapdrm and omap_vout use "select" to enable omapdss,
instead of depending on omapdss. This causes an illegal config to be
created. Perhaps this is the problem that Rob mentions in his patch?

Adding ARCH_MULTIPLATFORM for omapdss, as this patch does, removes
(well, hides) the above mentioned problem and allyesconfig works ok. You
can still break the config, but you need to manually select the Kconfig
options the wrong way.

I have patches to add the ARCH_MULTIPLATFORM for omapdss, and to fix the
omap_vout and omapdrm Kconfig files. Each of them changes only one line.
Arnd, are you ok with queuing those patches via arm-soc/fixes? Or should
I send them individually to respective maintainers?

I can send the patches properly for review, but I've also attached them
here so Rob can test.

 Tomi


--------------090606060704060100070604
Content-Type: text/x-patch;
 name="0001-OMAPDSS-add-support-for-ARCH_MULTIPLATFORM.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-OMAPDSS-add-support-for-ARCH_MULTIPLATFORM.patch"

=46rom b2a01a69089c965a703125e001037eff4f09af4e Mon Sep 17 00:00:00 2001
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Date: Wed, 6 Feb 2013 15:21:14 +0200
Subject: [PATCH 1/3] OMAPDSS: add support for ARCH_MULTIPLATFORM

omapdss, omapfb and omap's panel drivers currently depend on
ARCH_OMAP2PLUS. To make omapdss usable on multiplatform builds, add an
optinal dependency to ARCH_MULTIPLATFORM.

No other change is needed, as omapdss, omapfb and panel drivers already
compile on non-omap platforms.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/video/omap2/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/omap2/Kconfig b/drivers/video/omap2/Kconfig
index b07b2b0..e1cd489 100644
--- a/drivers/video/omap2/Kconfig
+++ b/drivers/video/omap2/Kconfig
@@ -1,7 +1,7 @@
 config OMAP2_VRFB
 	bool
=20
-if ARCH_OMAP2PLUS
+if ARCH_OMAP2PLUS || ARCH_MULTIPLATFORM
=20
 source "drivers/video/omap2/dss/Kconfig"
 source "drivers/video/omap2/omapfb/Kconfig"
--=20
1.7.10.4


--------------090606060704060100070604
Content-Type: text/x-patch;
 name="0002-omap_vout-fix-the-dependency-on-OMAPDSS.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0002-omap_vout-fix-the-dependency-on-OMAPDSS.patch"

=46rom 61fb1e64b5374510bfaeb2137a5af5f6ea33ba34 Mon Sep 17 00:00:00 2001
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Date: Wed, 6 Feb 2013 15:54:08 +0200
Subject: [PATCH 2/3] omap_vout: fix the dependency on OMAPDSS

omap_vout uses "select" in Kconfig to enable omapdss. This doesn't work
correctly, as "select" forces omapdss to be enabled in the config even
if it normally could not be enabled.

Instead of using select, this patch changes omap_vout to use "depend
on".

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/media/platform/omap/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap/Kconfig b/drivers/media/platform=
/omap/Kconfig
index 390ab09..c102615 100644
--- a/drivers/media/platform/omap/Kconfig
+++ b/drivers/media/platform/omap/Kconfig
@@ -4,9 +4,9 @@ config VIDEO_OMAP2_VOUT_VRFB
 config VIDEO_OMAP2_VOUT
 	tristate "OMAP2/OMAP3 V4L2-Display driver"
 	depends on ARCH_OMAP2 || ARCH_OMAP3
+	depends on OMAP2_DSS
 	select VIDEOBUF_GEN
 	select VIDEOBUF_DMA_CONTIG
-	select OMAP2_DSS
 	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3
 	select VIDEO_OMAP2_VOUT_VRFB if VIDEO_OMAP2_VOUT && OMAP2_VRFB
 	default n
--=20
1.7.10.4


--------------090606060704060100070604
Content-Type: text/x-patch;
 name="0003-omapdrm-fix-the-dependency-on-OMAPDSS.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0003-omapdrm-fix-the-dependency-on-OMAPDSS.patch"

=46rom aca9e04648a6cef98f65ff754bf903f456c8bc5d Mon Sep 17 00:00:00 2001
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Date: Wed, 6 Feb 2013 16:03:44 +0200
Subject: [PATCH 3/3] omapdrm: fix the dependency on OMAPDSS

omapdrm uses "select" in Kconfig to enable omapdss. This doesn't work
correctly, as "select" forces omapdss to be enabled in the config even
if it normally could not be enabled.

Instead of using select, this patch changes omapdrm to use "depend
on".

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/staging/omapdrm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/omapdrm/Kconfig b/drivers/staging/omapdrm/Kc=
onfig
index b724a41..09f65dc 100644
--- a/drivers/staging/omapdrm/Kconfig
+++ b/drivers/staging/omapdrm/Kconfig
@@ -3,8 +3,8 @@ config DRM_OMAP
 	tristate "OMAP DRM"
 	depends on DRM && !CONFIG_FB_OMAP2
 	depends on ARCH_OMAP2PLUS || ARCH_MULTIPLATFORM
+	depends on OMAP2_DSS
 	select DRM_KMS_HELPER
-	select OMAP2_DSS
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
--=20
1.7.10.4


--------------090606060704060100070604--

--------------enig4033146243A5EA9D21D9E6A2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJREmWdAAoJEPo9qoy8lh71n08P/350+p9yw7cypvkRm0sdNuGk
dQHy7ND7y2i7S8ZuUwHsyYG1/dIHur+N4L2rTtCzEjGxTdd1Wj17zGSbfIGW8kh/
lefG6zoeGhkO/k2uXHZZAx5Sntm9TjfF/tM0tRDuQJGfUZJ+BgItpMZ9BHHOtX6x
O7Lw0LQmaln+2Gycfxo8wCcak/jbQQ58cctyaPw5yWIUR4GPcIZvZo9jopjtSQVF
4aP1uF5+i0WE+z81L5VruDb9CEKQuGNxrrYA9Uc6JonLeT+HAwlwYV78aXAP+K19
4rNuaYxrBvmv+JBYNJFMdu7dcsedzWrigEyQUspmRKYWQ4ehKYErR+vheFCyVkfL
oBTLCx7FDx9Rvugd9dKlAYmcFnJXrZDPdl5wZ7czG0LuC2Ony7uMddvqgy7Lv5qZ
Fhr2QhI3hvxwsTMU4FSiOK/fFcD544/lD/RoQj6j1US8r5dbfo84no+jC2DNZbkG
ygMJlpePcKBFquR+0I9cU/iKuQJZUg3hb+sA0Kfb813f2YJQUVoBwHqh8HyHrQwD
/Zrh/XbegbbxRetg7cYrmsUTuECA/V57t32hSIBkoxGjCCaSjPKkR8MRBdQIYcn5
TdaB60TgLzaaFKzOdAbyMD4fZNXxMVDOMfxs1m7F41//cux+hwV/5W1jBui75jCJ
wvoacAojawXxmzbz8yVe
=Nq6L
-----END PGP SIGNATURE-----

--------------enig4033146243A5EA9D21D9E6A2--
