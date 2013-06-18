Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3FRDET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 23:04:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49566 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3FRDER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 23:04:17 -0400
Date: Tue, 18 Jun 2013 13:04:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlZpbGxlIFN5cmrDpGzDpCI=?= 
	<ville.syrjala@linux.intel.com>,
        Dave Airlie <airlied@linux.ie>
Subject: linux-next: manual merge of the drm-intel tree with the drm tree
Message-Id: <20130618130401.78cd4bac29c31fce22a13897@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Jun_2013_13_04_01_+1000_h9oymsxEphodw9Y1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Jun_2013_13_04_01_+1000_h9oymsxEphodw9Y1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_fb.c between commit b72447cdf129 ("drm/i915:
Drop bogus fbdev sprite disable code") from the drm tree and commit
b51b32cde175 ("drm/i915: s/drm_i915_private_t/struct drm_i915_private/")
from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_fb.c
index 3b03c3c,244060a..0000000
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@@ -291,7 -292,9 +292,7 @@@ void intel_fb_output_poll_changed(struc
  void intel_fb_restore_mode(struct drm_device *dev)
  {
  	int ret;
- 	drm_i915_private_t *dev_priv =3D dev->dev_private;
+ 	struct drm_i915_private *dev_priv =3D dev->dev_private;
 -	struct drm_mode_config *config =3D &dev->mode_config;
 -	struct drm_plane *plane;
 =20
  	if (INTEL_INFO(dev)->num_pipes =3D=3D 0)
  		return;

--Signature=_Tue__18_Jun_2013_13_04_01_+1000_h9oymsxEphodw9Y1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRv84mAAoJEECxmPOUX5FEJEsQAJM0sef9B/birsZv5PmB1wV2
dSvpzgHaJmWcOXz1G5VwhHIvAl9V63p9OTFX3GBFjtb5XLfuY6CDGWagu13saLLU
0TG+y+1t9UdbTS5nkl7GZAJwzJCCXs0Fzs05c6zxDaqN1rh2PfLEtp72OOq4k70o
JT2IPcbaDqoNNYeAqTHL1NjVNhsMaAWkKnk0NeS4qxw57/ThiO8NBftUUd6Tt6SH
F80oqN3RLcIRZzY3q5ERwyEsBQ/aFQ87g6ywvExRU/7oYmX9yF7sS1W/eLaIAjhJ
0EEjqxym2GwYOA189ocxhRIjsQW3ArLIekM1bsjRSmtSSwmzHqAw7WjAZyjXM6uE
n9NO2obmeBHtbDf9nt7PWAEnin3XOazImPzcxIlSvyfODHFlZ55hBltZ1STOVK2q
hOc+ShxrilaSfpaQxrOh+wi+ChhnhU9q6YzCFtvRNI2P5numVUTWk8+cWxbqvTio
F+TYV3eI0VtBOdvqux46HSu6hwNmXiRZKdijHndTYSZnedAxH1x5GjdG0+LgpSrm
x7/QetCK1g6hlB/DB3LYkbpbpgb+cMIVQQcfN43i4IM7nCh4TpPOCTDmwbv2pGkb
e5S+W5O+sFTD0p3SZfooH0ypMFm5uBLDiR0WI1AyUzVY2USN8IwEvyhtKJ9wLoga
NoIVzfrfe05yasrV1PeM
=zhC2
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Jun_2013_13_04_01_+1000_h9oymsxEphodw9Y1--
