Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab3IRBZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 21:25:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43611 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3IRBZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 21:25:37 -0400
Date: Wed, 18 Sep 2013 11:25:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlZpbGxlIFN5cmrDpGzDpCI=?= 
	<ville.syrjala@linux.intel.com>
Subject: linux-next: manual merge of the drm-intel tree with Linus' tree
Message-Id: <20130918112530.4595070b1c7f4ec72e0ea8b6@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__18_Sep_2013_11_25_30_+1000_Z5yerY9ArOcnP5/I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Sep_2013_11_25_30_+1000_Z5yerY9ArOcnP5/I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_drv.h between commit 6e1b4fdad515 ("drm/i915:
Delay disabling of VGA memory until vgacon->fbcon handoff is done") from
Linus' tree and commit eb14cb747bc5 ("drm/i915: Add state readout and
checking for has_dp_encoder and dp_m_n") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_drv.h
index 28cae80,b85354f..0000000
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@@ -793,6 -814,13 +815,14 @@@ extern void hsw_pc8_disable_interrupts(
  extern void hsw_pc8_restore_interrupts(struct drm_device *dev);
  extern void intel_aux_display_runtime_get(struct drm_i915_private *dev_pr=
iv);
  extern void intel_aux_display_runtime_put(struct drm_i915_private *dev_pr=
iv);
 +extern void i915_disable_vga_mem(struct drm_device *dev);
+ extern void intel_dp_get_m_n(struct intel_crtc *crtc,
+ 			     struct intel_crtc_config *pipe_config);
+ extern int intel_dotclock_calculate(int link_freq,
+ 				    const struct intel_link_m_n *m_n);
+ extern void ironlake_check_encoder_dotclock(const struct intel_crtc_confi=
g *pipe_config,
+ 					    int dotclock);
+=20
+ extern bool intel_crtc_active(struct drm_crtc *crtc);
 =20
  #endif /* __INTEL_DRV_H__ */

--Signature=_Wed__18_Sep_2013_11_25_30_+1000_Z5yerY9ArOcnP5/I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSOQEOAAoJEECxmPOUX5FEn1QP/2cgamnYcf1ONAiEnHEn742j
oMPMxuRvSf5WuAD4lN+XVwp2N8M/3u1cFIqSiRLgFmscC8Q+qxRIX4dCDseeZ63J
5f74hD1i1ua0ac2Rk5dmQ2GySbY8ZVE/qOkoIZF3aLkKA4AU+DRZNTJPjgN5X7re
HdCsCxkYoOfdqHoxm/bt6REsW9pRl7Z4R5xd7Ev179/QLnhv1hZlC0mh7u0N9OD6
Ux8dpkHZf7/Li1bquwfWQcCaBJzLXK/wUrK/YuGo9H3zRZvf8cs2hpUMK0+am/e9
bix19GRGLFI/rkchz9z1+30LX578gbzK5+joUX24nnllwqekFrcC7B5qLwhQVQZt
PS+eyd2yoEufNQGalA4JnFe/9Iq75FdKSu80LNSeL4/scNjHp5DbA0BhlZBYOoHp
Ss5hbxWv5hx3b6fqJYokM0ExWUY5jYsiM5UziuncRMBH7giGSt8273+JbwIkvNE5
tAycTZzK30li1OuiDXQk2hNGmR4oAHjNg718yaRvfshPsywfrjGSnbsw7CE2qdnQ
Z1n7WzNazlDIO6ibOVfipVKAqqhBEvyUla+3zonHyQ4rLm8JgnwPZJJr2JdSxlr+
WeRpusUmrvpvslszvqOUpWzz+368oDfbEpS/330ihsZXk2LNPsn2P8R2IaDVz1Sq
OazJfUjC8dxNYwQU3NV4
=ky7I
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Sep_2013_11_25_30_+1000_Z5yerY9ArOcnP5/I--
