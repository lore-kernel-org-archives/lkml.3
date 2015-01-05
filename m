Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbbAEPdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:33:00 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45111 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbbAEPc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:32:58 -0500
Date: Mon, 5 Jan 2015 16:32:54 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Vince Hsu <vinceh@nvidia.com>
Cc: Emil Velikov <emil.l.velikov@gmail.com>, swarren@wwwdotorg.org,
        gnurou@gmail.com, bskeggs@redhat.com, martin.peres@free.fr,
        seven@nimrod-online.com, samuel.pitoiset@gmail.com,
        linux-tegra@vger.kernel.org, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Nouveau] [PATCH nouveau 09/11] drm: export some variable and
 functions to resue the PM functions
Message-ID: <20150105153252.GI12010@ulmo.nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-10-git-send-email-vinceh@nvidia.com>
 <54A20F4D.4040100@gmail.com>
 <54A2198A.4000707@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aznLbwQ42o7LEaqN"
Content-Disposition: inline
In-Reply-To: <54A2198A.4000707@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aznLbwQ42o7LEaqN
Content-Type: multipart/mixed; boundary="fckbADODYWZD5TdN"
Content-Disposition: inline


--fckbADODYWZD5TdN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 30, 2014 at 11:18:34AM +0800, Vince Hsu wrote:
> Hi Emil,
>=20
> On 12/30/2014 10:34 AM, Emil Velikov wrote:
> >On 23/12/14 10:40, Vince Hsu wrote:
> >>This patch adds some checks in the suspend/resume functions to distingu=
ish
> >>the dGPU and mobile GPU and exports some variables/functions so that the
> >>nouveau platform device can reuse them.
> >>
> >Hi Vince,
> >
> >Afaiu one needs to export a symbol as it's used by another module or
> >subsystem. With the follow up two patches you are not doing either one,
> >so I'd assume that you can just omit the EXPORT_* changes.
> The nouveau platform device driver is built as another module -
> nouveau_platform.ko. :)

I'd like to hear the opinion of the nouveau people and Alex, but I'd
very much prefer if nouveau_platform.o was simply linked into the
nouveau.ko module. I don't see any good reason to keep it separate.

Something like the attached patch (untested) ought to do it.

Thierry

--fckbADODYWZD5TdN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=patch
Content-Transfer-Encoding: quoted-printable

diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kcon=
fig
index 40afc69a3778..5ab13e7939db 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -26,7 +26,7 @@ config DRM_NOUVEAU
 	  Choose this option for open-source NVIDIA support.
=20
 config NOUVEAU_PLATFORM_DRIVER
-	tristate "Nouveau (NVIDIA) SoC GPUs"
+	bool "Nouveau (NVIDIA) SoC GPUs"
 	depends on DRM_NOUVEAU && ARCH_TEGRA
 	default y
 	help
diff --git a/drivers/gpu/drm/nouveau/Makefile b/drivers/gpu/drm/nouveau/Mak=
efile
index ea40cd653c7c..13acf90c11c8 100644
--- a/drivers/gpu/drm/nouveau/Makefile
+++ b/drivers/gpu/drm/nouveau/Makefile
@@ -394,8 +394,6 @@ nouveau-$(CONFIG_ACPI) +=3D nouveau_acpi.o
 endif
 nouveau-$(CONFIG_DRM_NOUVEAU_BACKLIGHT) +=3D nouveau_backlight.o
 nouveau-$(CONFIG_DEBUG_FS) +=3D nouveau_debugfs.o
+nouveau-$(CONFIG_NOUVEAU_PLATFORM_DRIVER) +=3D nouveau_platform.o
=20
 obj-$(CONFIG_DRM_NOUVEAU)+=3D nouveau.o
-
-# platform driver
-obj-$(CONFIG_NOUVEAU_PLATFORM_DRIVER) +=3D nouveau_platform.o

--fckbADODYWZD5TdN--

--aznLbwQ42o7LEaqN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUqq6kAAoJEN0jrNd/PrOh7zYP/2/Gz2qekJVUUI7xu/Y2h+OZ
et5jVzpdlpjTr9IXLtNkC4clUwgE4Q5ZCRYg30rlpXbnwqEyzgrluCMBkkU6An4H
6G21xMgEeB74FKzXmOuNZs3oPLLW8jk7ajlXWqd/FL1373WKJbinrAiIuyMg3yTB
DZvhLHvJ7rO8L/myXIJ0TpZu4Ze3sQM+owYqEYeUK8BPa5lJ7VITcsIGKBHLbV3X
+9Zyy8GNl/Lx5qbYu4/CXSs7JLHmpy+mVRR6XJVRqEENgADi/KC94pa4quMH6ULA
ybbLb7MdXrmRiV2k8lOCOklIHVFEdL/rqsqWULke6Fx5uLgj4YMZfBi3wLgqRBSJ
Nwdr1DMImJMScTqoGSrFp24ZSAx11LV56xsoAfHGEFk7OkeGx5SJxctVhRcIhc+w
eKVT65CzxN3rWkfTu7NHKGmINSqDqsSaPeIx0MYnuDvL/i6sOhxxXHjGahjxwzQw
JqhjXYxu54kR3GrFgw8C9XCH3PCAX0fokUx13/zIKEzadJWl3mRGH/BXAu5C1gNc
DCY8C1TZU30od7AOUHsKIrNyCPMR3rG/zd/7oPgOUKiCoNT5zuSWKzOJC+DZRtkF
ZK917wnFDx1FrsxHfx0e9qT3VRZraWfWZHqQOK9wgaBNCha0QvbMRlS7/MY8+BV4
extweO0xPnys4iyzqd1l
=z+yG
-----END PGP SIGNATURE-----

--aznLbwQ42o7LEaqN--
