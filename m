Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbaAVDEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 22:04:14 -0500
Received: from ozlabs.org ([203.10.76.45]:50564 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069AbaAVDEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 22:04:12 -0500
Date: Wed, 22 Jan 2014 14:04:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@linux.ie>,
        <intel-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlZpbGxlIFN5cmrDpGzDpCI=?= 
	<ville.syrjala@linux.intel.com>
Subject: linux-next: manual merge of the drm-intel tree with the drm tree
Message-Id: <20140122140402.20163da276690810a1040909@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_Jan_2014_14_04_02_+1100_OYX7Ji.UJk6bH6kV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Jan_2014_14_04_02_+1100_OYX7Ji.UJk6bH6kV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/i915_irq.c between commit abca9e454498 ("drm: Pass
'flags' from the caller to .get_scanout_position()") from the drm tree
and commit d59a63ad8234 ("drm/i915: Add intel_get_crtc_scanline()") from
the drm-intel tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_irq.c
index 17d8fcb1b6f7,ffb56a9db9cc..000000000000
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@@ -649,8 -675,9 +649,9 @@@ static bool ilk_pipe_in_vblank_locked(s
  }
 =20
  static int i915_get_crtc_scanoutpos(struct drm_device *dev, int pipe,
 -				    int *vpos, int *hpos,
 +				    unsigned int flags, int *vpos, int *hpos,
- 				    ktime_t *stime, ktime_t *etime)
+ 				    ktime_t *stime, ktime_t *etime,
+ 				    bool adjust)
  {
  	struct drm_i915_private *dev_priv =3D dev->dev_private;
  	struct drm_crtc *crtc =3D dev_priv->pipe_to_crtc_mapping[pipe];
@@@ -788,6 -786,24 +791,24 @@@
  	return ret;
  }
 =20
+ static int i915_get_scanout_position(struct drm_device *dev, int pipe,
+ 				     int *vpos, int *hpos,
+ 				     ktime_t *stime, ktime_t *etime)
+ {
 -	return i915_get_crtc_scanoutpos(dev, pipe, vpos, hpos,
++	return i915_get_crtc_scanoutpos(dev, pipe, 0, vpos, hpos,
+ 					stime, etime, true);
+ }
+=20
+ int intel_get_crtc_scanline(struct drm_crtc *crtc)
+ {
+ 	int vpos =3D 0, hpos =3D 0;
+=20
 -	i915_get_crtc_scanoutpos(crtc->dev, to_intel_crtc(crtc)->pipe,
++	i915_get_crtc_scanoutpos(crtc->dev, to_intel_crtc(crtc)->pipe, 0,
+ 				 &vpos, &hpos, NULL, NULL, false);
+=20
+ 	return vpos;
+ }
+=20
  static int i915_get_vblank_timestamp(struct drm_device *dev, int pipe,
  			      int *max_error,
  			      struct timeval *vblank_time,

--Signature=_Wed__22_Jan_2014_14_04_02_+1100_OYX7Ji.UJk6bH6kV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS3zUmAAoJEMDTa8Ir7ZwVoBoP/02lVouuO92LU+J3tB+NZRwi
XUnxxgQAn5Jpm8G83xmOJKlgo3uA9GhZwwshuQHNZYP3WuK/XZBcviy+IJOGlfLz
c1GYh4UCihpNvcYkGgBOWM+wFP+l8eyaokHMsHxGQTXfPYKj20ZHW0haqdsTGguX
aGLHZlOPa2BlHaUbLEEHh/gwTnS6YitXC+0IK9zKYEl0/WZ2gk6kf1DNXJsT0Ghz
YjHibgIItTKJncRwkd1kIq9V33pOODqqU+9XZZfMZdgBiOXLXdVCab6DVGXJx+3L
rb5z1H1VnZGsHkBss4ZlBu3z+6KbCWGYfoMIPL1yrAK5CXe++oyeiaRPSp734eF7
bKglA3K59ua6aI4K+iUgYRULZMJnX1ewSynBWLD5JdddNx/ipShDjnMgnP6uIXZe
5CivbdTWxrn8qLjlaeRlveRQpvYFne0QKdx/kjlynoG1k6ZHlkmQ9NwEmsVq8INH
Lf1s5njSyJ2FONDLUkqf+5mS5OXkiHMYvt12Zx2kg7tiXhzB2yHXCOmASpFqWYdC
Nja2O9gD8MB4ZbmTIYguJKqqDP9PqLa9uILOkEQeGdT2Nzov6r3MYF0aK0fvD8zj
MoYLrBs1N/KZ+ZqcoYAS3/4HS/0O3jZOzm7nosORbL266iU3papVtVvsDRtL0ToR
BRH/BxCSVTSYZhFujMSx
=D0cz
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Jan_2014_14_04_02_+1100_OYX7Ji.UJk6bH6kV--
