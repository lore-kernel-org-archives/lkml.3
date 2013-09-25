Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab3IYCAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 22:00:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40204 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3IYCAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 22:00:50 -0400
Date: Wed, 25 Sep 2013 12:00:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlZpbGxlIFN5cmrDpGzDpCI=?= 
	<ville.syrjala@linux.intel.com>
Subject: linux-next: manual merge of the drm-intel tree with the
 drm-intel-fixes tree
Message-Id: <20130925120035.901f8f3eae222ae061fe3a07@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__25_Sep_2013_12_00_35_+1000_j3/RLc2heZv/nmto"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Sep_2013_12_00_35_+1000_j3/RLc2heZv/nmto
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_display.c between commit 67c72a122541
("drm/i915: preserve pipe A quirk in i9xx_set_pipeconf") from the
drm-intel-fixes tree and commit cf532bb25592 ("drm/i915: Move double wide
mode handling into pipe_config") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_display.c
index e5822e7,d12d563..0000000
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@@ -4775,21 -4881,8 +4881,12 @@@ static void i9xx_set_pipeconf(struct in
 =20
  	pipeconf =3D 0;
 =20
 +	if (dev_priv->quirks & QUIRK_PIPEA_FORCE &&
 +	    I915_READ(PIPECONF(intel_crtc->pipe)) & PIPECONF_ENABLE)
 +		pipeconf |=3D PIPECONF_ENABLE;
 +
- 	if (intel_crtc->pipe =3D=3D 0 && INTEL_INFO(dev)->gen < 4) {
- 		/* Enable pixel doubling when the dot clock is > 90% of the (display)
- 		 * core speed.
- 		 *
- 		 * XXX: No double-wide on 915GM pipe B. Is that the only reason for the
- 		 * pipe =3D=3D 0 check?
- 		 */
- 		if (intel_crtc->config.requested_mode.clock >
- 		    dev_priv->display.get_display_clock_speed(dev) * 9 / 10)
- 			pipeconf |=3D PIPECONF_DOUBLE_WIDE;
- 	}
+ 	if (intel_crtc->config.double_wide)
+ 		pipeconf |=3D PIPECONF_DOUBLE_WIDE;
 =20
  	/* only g4x and later have fancy bpc/dither controls */
  	if (IS_G4X(dev) || IS_VALLEYVIEW(dev)) {

--Signature=_Wed__25_Sep_2013_12_00_35_+1000_j3/RLc2heZv/nmto
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSQkPHAAoJEECxmPOUX5FEgJIQAIn4FURSLPXfo8bqnZTyBQJa
5PXYI4XinEc3b3CEX7iGDXMuXgeInee+UXYcCX//J2XG6FOiPG5doPFY/dS+td0x
bJEnRC485Z+Sj4Uir3RmiZsUzUvWXRvh76zhz7gjYPXYFSTnKhRQ3iHWhfUDOf4H
Mlj0jmVuNT6P9YsHity6qUywqq1YNAghDmr7s/OnQgomImEJh3/YPK9gE4+qPart
e9ylVwOOtJfPFEBKOe4YoRqUxSmgL7zj6u4szz8wzazytlqLdJ8sNe7pTu7WzQIO
iz2xMoNHVRkXsmtJ9D37TovGbNCCdgHWir6mtKoQFWm0a9kwV07Vmt4pfYttvvaU
9ls8FbhqX4R57rK3vhJpqQ/IQJLAV9Mv+ZE1fSRT09PsVV0+ZqaKAlQzgf5xSuGe
4te9aIdkTJch1/EYmdomKZVIc8umuwimFJYjdriR3zs4i9drXENnAyyinlaBkj7y
AOO2mpDzF6Sawxv2EKBGa2iuVNUjs1H6MWFBblMlpraQ1fkuLHtpKVS2rO13Ak05
Q9YFov/02A6N/2YhPMcnx0R/LGNDbGZpwhkxfHX6AIoxkHaKgEmLrObWdFCOpWd1
IiParS5TvoRBhrSPzLDOuW20uUi2p/z2VAjwKqTKpXZqJ65/q5+LZK2bILmT8/gA
L+xeGGu9iC/3xIHT1Pqc
=O0nM
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Sep_2013_12_00_35_+1000_j3/RLc2heZv/nmto--
