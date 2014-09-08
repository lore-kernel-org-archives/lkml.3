Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaIHE0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 00:26:41 -0400
Received: from ozlabs.org ([103.22.144.67]:57323 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbaIHE0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 00:26:40 -0400
Date: Mon, 8 Sep 2014 14:26:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Ville =?UTF-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: linux-next: build failure after merge of the drm tree
Message-ID: <20140908142631.6cb967a3@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/eaFtsqWPGZBhmcGrt2l6GYA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/eaFtsqWPGZBhmcGrt2l6GYA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/gpu/drm/i915/intel_display.c: In function 'intel_crtc_cursor_set_ob=
j':
drivers/gpu/drm/i915/intel_display.c:8302:24: error: 'dev_priv' undeclared =
(first use in this function)
   intel_runtime_pm_get(dev_priv);
                        ^

Caused by commit d7ce484eeec4 ("drm/i915: Move CURSIZE setup to
i845_update_cursor()") interacting with commit d6dd6843ff4a ("drm/i915:
fix plane/cursor handling when runtime suspended") from Linus' tree.

I am not sure why this hasn't failed before as both commits have been
in linux-next since (at least) Sept 3.

I have applied this merge fix patch (which reverts part of d7ce484eeec4):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 8 Sep 2014 14:17:21 +1000
Subject: [PATCH] drm/i915: fix up for recent merge

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/gpu/drm/i915/intel_display.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index a1acf8376c0f..18da8349a070 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8253,6 +8253,7 @@ static int intel_crtc_cursor_set_obj(struct drm_crtc =
*crtc,
 				     uint32_t width, uint32_t height)
 {
 	struct drm_device *dev =3D crtc->dev;
+	struct drm_i915_private *dev_priv =3D dev->dev_private;
 	struct intel_crtc *intel_crtc =3D to_intel_crtc(crtc);
 	enum pipe pipe =3D intel_crtc->pipe;
 	unsigned old_width, stride;
--=20
2.1.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/eaFtsqWPGZBhmcGrt2l6GYA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDS/8AAoJEMDTa8Ir7ZwVcuoP/RvYBSzPxkGbM30rOT226/y/
YrZgeErfRUK8cYDvqb9zTbXa4TPGxN0CdIkGHtcxFKtrwjPTkaAiqHWJxsNKKxDe
eZIF1R1TOkVjf2mRXH7NGdYlFyh0dM/KVON8NilNE4dIi1UEp0CdAgXrJKAsWpHI
GyS4laASQtBGzrkJKdXidljLzGCvkrygOmn/1nK5yr87veo2LI1mEulCm5yLBqVY
FBG1S/gG6LlFFgR86XO55saRauR6n4ah2PGNiX4DMXTXXnyQJX1+w5KD+/YAbP2k
XOg7yikJyvh2CqYf4nHEwQRbtfFwqVLRmnAxdxR1dghprjCFaEDiBpC0HWkO6MVN
/ihUm6dyUXL4CbcvarxrUjD1NKwTnjxL+peI9eRhapHZ3uoOOxh2aT7whEeAvhDx
x4eE2jIb6AcPOz1zF7iDHfbApuFrEgV1wSKudVWfRqobv+LQR61JgI5K8oRR7LKH
dg6v1ICxZul3dBcCSigQOmVyLMG4KzLKvsDx6SJxQFWJpWnFgY//gaEHLpoFI12i
mWWUDmwXnkLtk98oQWmcURGTLHfVc9R2PM4D/gfMGK4fJZwbH6E3DztE4+IuyQlu
ugnvk3QytIadZSdIXvDlxO9myEjIEYHjHD2ft3R7sezFPgfOd+6oCK9qTr9Z1BH0
NacE0ETvlwZgq49IIeTt
=YwNh
-----END PGP SIGNATURE-----

--Sig_/eaFtsqWPGZBhmcGrt2l6GYA--
