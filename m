Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbaAVDJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 22:09:16 -0500
Received: from ozlabs.org ([203.10.76.45]:51236 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbaAVDJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 22:09:14 -0500
Date: Wed, 22 Jan 2014 14:09:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlZpbGxlIFN5cmrDpGzDpCI=?= 
	<ville.syrjala@linux.intel.com>
Subject: linux-next: manual merge of the drm-intel tree with the drm tree
Message-Id: <20140122140908.c57e7336c70156e30eda2a18@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_Jan_2014_14_09_08_+1100_FoM7x0L4JZZkNM_K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Jan_2014_14_09_08_+1100_FoM7x0L4JZZkNM_K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_display.c between commit c326c0a9c98c
("drm/i915: Call drm_calc_timestamping_constants() earlier") from the drm
tree and commit bbee18af2a25 ("drm/i915: Prepare to track new pipe config
per pipe") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_display.c
index 14b024becb91,e1d3ae1212a7..000000000000
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@@ -9660,14 -9705,7 +9703,15 @@@ static int __intel_set_mode(struct drm_
  		/* mode_set/enable/disable functions rely on a correct pipe
  		 * config. */
  		to_intel_crtc(crtc)->config =3D *pipe_config;
+ 		to_intel_crtc(crtc)->new_config =3D &to_intel_crtc(crtc)->config;
 +
 +		/*
 +		 * Calculate and store various constants which
 +		 * are later needed by vblank and swap-completion
 +		 * timestamping. They are derived from true hwmode.
 +		 */
 +		drm_calc_timestamping_constants(crtc,
 +						&pipe_config->adjusted_mode);
  	}
 =20
  	/* Only after disabling all output pipelines that will be changed can we

--Signature=_Wed__22_Jan_2014_14_09_08_+1100_FoM7x0L4JZZkNM_K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS3zZYAAoJEMDTa8Ir7ZwVRSoP/R0gK1HqFim6I3tSfaNMgbXa
IPKQkMDCPx6Fm+rhrcZJXKjIjBUk1p0VE3laDemUQANJAoxWD4uAvibeCuslw2rC
l+hTRWxnkoB5xfVsAdHKu3YVi5e4Y1txTCr7D1f8JVHZ1cuN/Rt/wgdY7ehamt02
6NmiPJMOHXkL5zSxlRw+bSgoK+ew3MJ14icYjUsu7d+2TNOSMOaOT5++B2x+1I1W
SO8S8rS9ghrhb6s5Hak69XfRsUwubOrpAUIa7QAMfHP6c2dhVxly5vZfXei65sqM
SUPnNJ7lNfc4aMVcsc7G50gfmRFQgPIZwb1WAJlKIILfCiedmz6FKe4Wy2Q3D3dA
+ViMMI4Kh5SoAXTPp7HQzTGzY3siAGKwiFYcgVCQY/pnzIopXhftiErvjOqVnAq+
huWkALLKzDcjGn1g9HW2Z0sTC0avM6/EPAqqHqAAIrLrAaNch64X74Yygpd6YDaT
jqOQJv20+ky17L90L03XcQ42pZgGqX6mLO7iPtKnkbH59BgOQEfbEcs2S1AcKO3h
Fbiiwej77huNjd04QiiR2xPl1DTWv1CBnpct2BcLJBowI9dQ1fHbURtrm7erdZVw
tgXB9WlbuKk4a/Q/G+HxWgZwsUyziATzOFaFth1TYGT7FEnD0DgYqSVe955pz4cz
x4yee5ODdO1x8bysFknS
=+D0N
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Jan_2014_14_09_08_+1100_FoM7x0L4JZZkNM_K--
