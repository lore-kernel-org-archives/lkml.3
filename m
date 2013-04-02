Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025Ab3DBCqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:46:48 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56961 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760000Ab3DBCqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:46:45 -0400
Date: Tue, 2 Apr 2013 13:46:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: linux-next: manual merge of the drm-intel tree with Linus' tree
Message-Id: <20130402134636.7311b6f6f8d2a9534a4a5b7b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Apr_2013_13_46_36_+1100_0xnYxCm7K6yOgarF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Apr_2013_13_46_36_+1100_0xnYxCm7K6yOgarF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_dp.c between commit 9d1a455b0ca1 ("") from
Linus' tree and commit 965e0c489f36 ("drm/i915: introduce
pipe_config->dither|pipe_bpp") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_dp.c
index d7d4afe,92a7c62..0000000
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@@ -850,10 -792,10 +802,10 @@@ intel_dp_set_m_n(struct drm_crtc *crtc
  	 * the number of bytes_per_pixel post-LUT, which we always
  	 * set up for 8-bits of R/G/B, or 3 bytes total.
  	 */
- 	intel_link_compute_m_n(intel_crtc->bpp, lane_count,
+ 	intel_link_compute_m_n(intel_crtc->config.pipe_bpp, lane_count,
 -			       mode->clock, adjusted_mode->clock, &m_n);
 +			       target_clock, adjusted_mode->clock, &m_n);
 =20
- 	if (IS_HASWELL(dev)) {
+ 	if (HAS_DDI(dev)) {
  		I915_WRITE(PIPE_DATA_M1(cpu_transcoder),
  			   TU_SIZE(m_n.tu) | m_n.gmch_m);
  		I915_WRITE(PIPE_DATA_N1(cpu_transcoder), m_n.gmch_n);

--Signature=_Tue__2_Apr_2013_13_46_36_+1100_0xnYxCm7K6yOgarF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRWkaMAAoJEECxmPOUX5FEBaYP/3PiLPN2BNyo0a1NpWXjhlPc
x9jbd9SufCDLS/KuRpjEn3tcsZ+yOJaQlysHqTCg29nZhewHBF2mtl8MyKuRr8Gt
YECnYCV0v9QHxpu783nrfQeMaYjhgq1FmwugjC1pLuulYmtN9PQjDHc1xCCu46My
pOMa8ya01AmcsHLW/Ui+4OpG/iKtxeZ4mJGKOo1e5EaFuEqyJ1Yy/1/draMqUzHc
QQYbnXYuT9D4eCbvc0H0wnJof2Bag1QQgrNqe7S1IJtCLxQAQcVamiX6sDw9QqBq
ngNZ1b56PHYI2eJf9zqUU5jy0f8X7lHdxin9n2OPsWHqUv5AyCwhZe5/Pc1Ohx5p
YzXywgbA7h5BgH1T4Mp+PnFJRfadt8mU4OROD7hBXf5r7Jooc3jVOEC+TPKJeiGQ
sDXfk147xTzNF+rX3PI3Oqqxz5JCoamNGcJbTpqKQVD1u0+gngxGMAOeI1QaRMVT
3+/bWfaoJJe2kNbwzfnlNd7hDlyNtKAjw04ZikAcgAhyIg10BqNdbW7l8KiRT9sw
XO5D6FoN1e8gY1/2yoHb3Y63cp1HJvLIBWB/nlaiyplRi/Hv9tsOSjjVJaMohb0Q
dojLFHTpPCKyMJn585aNchmjel2XdCu0zHoNOo/+8kspDuIuvDkSZq08qpo0sS8p
asyHEGC0bPogdrTTufP2
=cthO
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Apr_2013_13_46_36_+1100_0xnYxCm7K6yOgarF--
