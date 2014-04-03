Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161106AbaDCBAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 21:00:37 -0400
Received: from ozlabs.org ([203.10.76.45]:51913 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161060AbaDCBAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 21:00:36 -0400
Date: Thu, 3 Apr 2014 12:00:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Roper <matthew.d.roper@intel.com>,
        Rob Clark <robdclark@gmail.com>
Subject: linux-next: manual merge of the drm-intel tree with the drm tree
Message-Id: <20140403120026.481c9a08f440b72ffaf19fa6@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Apr_2014_12_00_26_+1100_Q5ssZFc7DN=N523v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Apr_2014_12_00_26_+1100_Q5ssZFc7DN=N523v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_display.c between commit f4510a2752b7 ("drm:
Replace crtc fb with primary plane fb (v3)") from the drm tree and commit
262ca2b08fbd ("drm/i915: Rename similar plane functions to avoid
confusion") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_display.c
index 3ffe5a6124f1,c31c6203c7ca..000000000000
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@@ -2291,9 -2398,11 +2398,11 @@@ void intel_display_handle_reset(struct=20
  		 * disabling them without disabling the entire crtc) allow again
  		 * a NULL crtc->fb.
  		 */
 -		if (intel_crtc->active && crtc->fb)
 +		if (intel_crtc->active && crtc->primary->fb)
- 			dev_priv->display.update_plane(crtc, crtc->primary->fb,
- 						       crtc->x, crtc->y);
+ 			dev_priv->display.update_primary_plane(crtc,
 -							       crtc->fb,
++							       crtc->primary->fb,
+ 							       crtc->x,
+ 							       crtc->y);
  		mutex_unlock(&crtc->mutex);
  	}
  }

--Signature=_Thu__3_Apr_2014_12_00_26_+1100_Q5ssZFc7DN=N523v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTPLKwAAoJEMDTa8Ir7ZwVujMQAJLPIbe11qDSdiqCSdEx8vcg
xRF9Vdz2YPp5FTG3cfxPk64Av8MomxC0Tet5NCn4hUIEoeSDtcsXMk0bNdo8zOsG
0t5UHdg9MSCFNz+Lh2sHIN8DT50OSI4rRsaMDcB5wPePfo3/fHw1QXnDXITa05uO
ZvW1o9glrzCwJCSsfM8BCY6fRhYI6FEjRntD0+rRUrN3bDoOyxjc5NwismxtuSkS
xJCjnyi2IORXZXAaZMh5z6vnen3BbsrWtKR2F/DzJHoUdAeJvyPi+7C6yDHO5plX
0IkEirIgIPdOLHyjO+LKT0FXHCbOv9pPbByNSNYyj2nPNs2eBpb6e+MBKBqguebq
+1+rxszghow0HPJGTS++MqwlcWrjV33XX7VT2XjpH+seU+KB0g1oKkcaR2gSNcsx
DAkwyLvmq+r6uOZi3Trh5Gs9O/2/H0RQ0NwnOzq8cADj/OdOhRyGHAIsAPn7ngWf
YZ4m+N+9LTrSeK3hIgbldiNmmSreqHMCp7HzhDp9JvFyMxixEtMtQaZSgBsQfVID
y68PzUCKFQ8nqkp74nIQfZCX1QiyAljLqfFz8sRG9uMZ9QcX0FbqkQcXastvLd1y
ZlsAkLSHeacsVuwqmbwxzr97un3k7D6LjgvEQcvIeftb1FDY/xulXMWSLKYQayk6
to/QXtXkLtA9UjJF1nPC
=79qp
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Apr_2014_12_00_26_+1100_Q5ssZFc7DN=N523v--
