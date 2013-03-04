Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab3CDXXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 18:23:47 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42148 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab3CDXXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 18:23:46 -0500
Date: Tue, 5 Mar 2013 10:23:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: linux-next: manual merge of the drm-intel tree with Linus' tree
Message-Id: <20130305102334.0cc15cb90a0f8baa4126cc14@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__5_Mar_2013_10_23_34_+1100_.sYOjZtRr6=.d=bM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Mar_2013_10_23_34_+1100_.sYOjZtRr6=.d=bM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got conflicts in
drivers/gpu/drm/i915/intel_hdmi.c and drivers/gpu/drm/i915/intel_sdvo.c
between commit 18316c8c39a8 ("drm: Remove duplicate drm_mode_cea_vic()")
from Linus' tree and commit 4f3a8bc7ba6e ("drm/i915: rename some HDMI bit
definitions") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_hdmi.c
index fa8ec4a,4d222ec..0000000
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@@ -781,8 -777,8 +777,8 @@@ bool intel_hdmi_mode_fixup(struct drm_e
  	if (intel_hdmi->color_range_auto) {
  		/* See CEA-861-E - 5.1 Default Encoding Parameters */
  		if (intel_hdmi->has_hdmi_sink &&
 -		    drm_mode_cea_vic(adjusted_mode) > 1)
 +		    drm_match_cea_mode(adjusted_mode) > 1)
- 			intel_hdmi->color_range =3D SDVO_COLOR_RANGE_16_235;
+ 			intel_hdmi->color_range =3D HDMI_COLOR_RANGE_16_235;
  		else
  			intel_hdmi->color_range =3D 0;
  	}
diff --cc drivers/gpu/drm/i915/intel_sdvo.c
index d07a8cd,63dcb76..0000000
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@@ -1076,9 -1076,11 +1076,11 @@@ static bool intel_sdvo_mode_fixup(struc
 =20
  	if (intel_sdvo->color_range_auto) {
  		/* See CEA-861-E - 5.1 Default Encoding Parameters */
+ 		/* FIXME: This bit is only valid when using TMDS encoding and 8
+ 		 * bit per color mode. */
  		if (intel_sdvo->has_hdmi_monitor &&
 -		    drm_mode_cea_vic(adjusted_mode) > 1)
 +		    drm_match_cea_mode(adjusted_mode) > 1)
- 			intel_sdvo->color_range =3D SDVO_COLOR_RANGE_16_235;
+ 			intel_sdvo->color_range =3D HDMI_COLOR_RANGE_16_235;
  		else
  			intel_sdvo->color_range =3D 0;
  	}

--Signature=_Tue__5_Mar_2013_10_23_34_+1100_.sYOjZtRr6=.d=bM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRNSz2AAoJEECxmPOUX5FEZqoP/1nPS0tj3XwJTdDiQhzKXV8g
T1hJS7MiFQvLLPT8eAnG7/GgmekP00Ryvh9ZUvNVpuQ5BcjEMnlN99pArrm41zzM
YFczmop0E0a96Y3/LFguWT6Le1h0gIEqjMWYdVO7KMJf12NrfxFRmFssgiHRYDrA
lDBygxJtz9bq4/8NBDmmtxXycB5ApZFwvudw+mShXftNo74+IDidbnqbXaYzsnTl
jf70kO/JGoSkHV9oQdoATJsIMnoghNN6b+xIwov6P3ldeq3K7l5Yyku+Py+FlNbZ
j0zKYnsHYhL3w88TB+J7S1yxsXCkXPCBrac2e4KR1Vfer6UDdZ1jRufxCVIUllpd
Ecjzi3oyMIOFZGxlS6OUezITRbXfMFZh36JkBGNQ9keYxRMm8VGciNnX1KpTb6Rb
9eAdnSpIMhhbBGpNDSXI/zdcyF3EWcBVAbF5TTX7qBWT9ucEJdOv351PIWmRcAAO
VI+gaiwdcSUcDZIm1ekho/lnVbVTbY37FtgVRNiKU3p801XCd7XoJwwh5zRW62Sr
En4HbO3dKOu9HN8WsTTZ0FrG2wucRa0p64OIprJ83rYVnUO6E6hv953M8TuQkHRB
KmbXqEwwN5utqbZCOKor29fNd8T7yh+Gryh8JiIsoPawASLg+ZTUyH1Fxe8rp7PL
AtgCA5FSM7d/X07x8tWs
=6OCE
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Mar_2013_10_23_34_+1100_.sYOjZtRr6=.d=bM--
