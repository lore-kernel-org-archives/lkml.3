Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbaKQDMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 22:12:08 -0500
Received: from ozlabs.org ([103.22.144.67]:51821 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbaKQDMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 22:12:06 -0500
Date: Mon, 17 Nov 2014 14:11:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-ID: <20141117141158.438636fd@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/m2JCHI1uBioA0jVdI/OBfa7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/m2JCHI1uBioA0jVdI/OBfa7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/tegra/dc.c between commit 8ff64c17f3be ("drm/tegra: dc:
Add missing call to drm_vblank_on()") from Linus' tree and commits
205d48edee84 ("drm/tegra: dc: Factor out DC, window and cursor commit")
and c7679306a923 ("drm/tegra: dc: Universal plane support") from the
drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/tegra/dc.c
index 054a79f143ae,b957908aec73..000000000000
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@@ -751,7 -906,8 +906,8 @@@ static void tegra_crtc_disable(struct d
  		}
  	}
 =20
 -	drm_vblank_off(drm, dc->pipe);
 +	drm_crtc_vblank_off(crtc);
+ 	tegra_dc_commit(dc);
  }
 =20
  static bool tegra_crtc_mode_fixup(struct drm_crtc *crtc,
@@@ -934,15 -1090,9 +1090,9 @@@ static void tegra_crtc_prepare(struct d
  static void tegra_crtc_commit(struct drm_crtc *crtc)
  {
  	struct tegra_dc *dc =3D to_tegra_dc(crtc);
- 	unsigned long value;
-=20
- 	value =3D GENERAL_UPDATE | WIN_A_UPDATE;
- 	tegra_dc_writel(dc, value, DC_CMD_STATE_CONTROL);
-=20
- 	value =3D GENERAL_ACT_REQ | WIN_A_ACT_REQ;
- 	tegra_dc_writel(dc, value, DC_CMD_STATE_CONTROL);
 =20
 -	drm_vblank_post_modeset(crtc->dev, dc->pipe);
 +	drm_crtc_vblank_on(crtc);
+ 	tegra_dc_commit(dc);
  }
 =20
  static void tegra_crtc_load_lut(struct drm_crtc *crtc)

--Sig_/m2JCHI1uBioA0jVdI/OBfa7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUaWeDAAoJEMDTa8Ir7ZwVtwIP/3K3H92RoGmz0QAQlkb2+mee
OT99NUNYPdysrWnXhiEz7GaGYCx0MwnNMrEzbsPs/CSRWuBbg2cYRkvEW+c7GTAa
fBkxBIE9GPXESvWk6HJZkfh9jWyFf1rC+aZ/lW/Ea0gd3tahvTMxnZZ0eVKCVQec
Nhdr/JT36Jl8Sjlb1WYV/pKWwAgtlzPDQxfvF1MebXnbz7nIsev8CYPXwFQ8/Vma
exnmdEBZykwLDNaueYVRh46Uj/umOFnzQWprONNSN/8O4wwpzuHI/XqQVL+X7Dvf
47+VPZgmNVS7XzWP2WAV4ZlIjo6KgLwYAFC8PLSSIfRoKcz4gx3A/mcTjbPO5QiU
+O5S3lfGppTupIy5uX1FnfwuinvIcX5LHOp/gxjfipk8Cf2pdVU7dj+XHa2EbvMK
IN368AhHvNcX4HRpSZbPfuh/xp/8hthCxO/5Cdte9KfABQjKdH41PGmxmI/mN9Bj
dpEGEP9RgcwUeiwRNzakHecKaGSKY/OgJPrHgNBiU//m4hEGPHuRDQjVRiFbgogm
IV9R1JdVgFkys1ebvQH33T3RI36xu6Tni7AE6CTJez88nD4LMQI6bjols8Bx/o3t
ZQOWTbF0F6LbSAWhT+OskFQuZOgGEmqhpKCncdMa9I36FLtaILaTUVy+VGc4Xq6X
JGNbU2L1gVtdMEms3Emq
=4x9t
-----END PGP SIGNATURE-----

--Sig_/m2JCHI1uBioA0jVdI/OBfa7--
