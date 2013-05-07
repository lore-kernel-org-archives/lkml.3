Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab3EGB2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:28:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49825 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab3EGB2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:28:05 -0400
Date: Tue, 7 May 2013 11:27:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlZpbGxlIFN5cmrDpGzDpCI=?= 
	<ville.syrjala@linux.intel.com>
Subject: linux-next: manual merge of the drm-intel tree with Linus' tree
Message-Id: <20130507112751.195757b78defdbea58aa6134@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__7_May_2013_11_27_51_+1000_meC2q0M63deuTFfJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_May_2013_11_27_51_+1000_meC2q0M63deuTFfJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/i915_reg.h between commit a65851af5938 ("drm/i915:
Make data/link N value power of two") from Linus' tree and commit
e3b95f1eb5b9 ("drm/i915: Apply OCD to data/link m/n register #defines")
from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

Daniel, I assume all this stuff being added to the drm-intel tree is
going upstream very soon?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_reg.h
index 83f9c26,a470103..0000000
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@@ -2648,18 -2768,19 +2768,19 @@@
   * which is after the LUTs, so we want the bytes for our color format.
   * For our current usage, this is always 3, one byte for R, G and B.
   */
- #define _PIPEA_GMCH_DATA_M			0x70050
- #define _PIPEB_GMCH_DATA_M			0x71050
+ #define _PIPEA_DATA_M_G4X	0x70050
+ #define _PIPEB_DATA_M_G4X	0x71050
 =20
  /* Transfer unit size for display port - 1, default is 0x3f (for TU size =
64) */
 -#define   PIPE_GMCH_DATA_M_TU_SIZE_MASK		(0x3f << 25)
 -#define   PIPE_GMCH_DATA_M_TU_SIZE_SHIFT	25
 +#define  TU_SIZE(x)             (((x)-1) << 25) /* default size 64 */
 +#define  TU_SIZE_MASK           (0x3f << 25)
+ #define  TU_SIZE_SHIFT		25
 =20
 -#define   PIPE_GMCH_DATA_M_MASK			(0xffffff)
 +#define  DATA_LINK_M_N_MASK	(0xffffff)
 +#define  DATA_LINK_N_MAX	(0x800000)
 =20
- #define _PIPEA_GMCH_DATA_N			0x70054
- #define _PIPEB_GMCH_DATA_N			0x71054
+ #define _PIPEA_DATA_N_G4X	0x70054
+ #define _PIPEB_DATA_N_G4X	0x71054
 -#define   PIPE_GMCH_DATA_N_MASK			(0xffffff)
 =20
  /*
   * Computing Link M and N values for the Display Port link
@@@ -2672,16 -2793,18 +2793,16 @@@
   * Attributes and VB-ID.
   */
 =20
- #define _PIPEA_DP_LINK_M				0x70060
- #define _PIPEB_DP_LINK_M				0x71060
+ #define _PIPEA_LINK_M_G4X	0x70060
+ #define _PIPEB_LINK_M_G4X	0x71060
 -#define   PIPEA_DP_LINK_M_MASK			(0xffffff)
 =20
- #define _PIPEA_DP_LINK_N				0x70064
- #define _PIPEB_DP_LINK_N				0x71064
+ #define _PIPEA_LINK_N_G4X	0x70064
+ #define _PIPEB_LINK_N_G4X	0x71064
 -#define   PIPEA_DP_LINK_N_MASK			(0xffffff)
 =20
- #define PIPE_GMCH_DATA_M(pipe) _PIPE(pipe, _PIPEA_GMCH_DATA_M, _PIPEB_GMC=
H_DATA_M)
- #define PIPE_GMCH_DATA_N(pipe) _PIPE(pipe, _PIPEA_GMCH_DATA_N, _PIPEB_GMC=
H_DATA_N)
- #define PIPE_DP_LINK_M(pipe) _PIPE(pipe, _PIPEA_DP_LINK_M, _PIPEB_DP_LINK=
_M)
- #define PIPE_DP_LINK_N(pipe) _PIPE(pipe, _PIPEA_DP_LINK_N, _PIPEB_DP_LINK=
_N)
+ #define PIPE_DATA_M_G4X(pipe) _PIPE(pipe, _PIPEA_DATA_M_G4X, _PIPEB_DATA_=
M_G4X)
+ #define PIPE_DATA_N_G4X(pipe) _PIPE(pipe, _PIPEA_DATA_N_G4X, _PIPEB_DATA_=
N_G4X)
+ #define PIPE_LINK_M_G4X(pipe) _PIPE(pipe, _PIPEA_LINK_M_G4X, _PIPEB_LINK_=
M_G4X)
+ #define PIPE_LINK_N_G4X(pipe) _PIPE(pipe, _PIPEA_LINK_N_G4X, _PIPEB_LINK_=
N_G4X)
 =20
  /* Display & cursor control */
 =20

--Signature=_Tue__7_May_2013_11_27_51_+1000_meC2q0M63deuTFfJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRiFiXAAoJEECxmPOUX5FEZAAP/jKr5kgDLK1fXLL0MM7Ukypp
Yakz3SZACrf8VQ5nrtLjPweH3dfpnIiJ5I0M3u6zaQsNosxDtZUKWgo9oiRg7i8g
pJQpqwu4vpDMPyirrsxbkbudz2MGemSilHlPL3stLc8C5rLE2WNrKN91p7KGgXuX
RXoZtJUkl9i0pQbZELPsp13HHiabk+akAxP5Y3mKRt+q3fbNN+0UitTIEB1YpMcR
2AKgy6bAYwno+1fSpn6HwhemL3YmQguL6KL0LO2XB+oqBnYb1LLSEreGfuvhq+bn
XMaHiJgSwrD45EXhN9gTivWL3L4SGyTf+TXcfe/aSdDQRjiPTRFtIqpZOdkmuqbM
xz91NWJKnI0NLd71g37rIzsDZgewvs2RUiRsAPFZuxei11G+FXwena8LA7TaK1aE
dGJZPXsFpyNubyRiIa1AovZs4W9D4szQ+mlVy4VCfQfb8CNfpmUaPbF4Y2pOpxRq
ljHq+zH8DfE95IC8oLqJBF73Ltp2+/iQrXLYM4EbLSgpFUUIE7qfZY6eHR9axNn8
M+uR6fYzZL09i1G1x6EnL2sNI+crtZmOJYb2Hg/5lPOssOYAV/qNUn9WlMFR2JSK
LmeFAjWYnDLuYjZrBISJN0QvTSUwh/Xbq5maU3yUpNVjt9RTVyAZkzlzW8YWvxHV
TsYC6GCW2cDojeHujPOG
=GewW
-----END PGP SIGNATURE-----

--Signature=_Tue__7_May_2013_11_27_51_+1000_meC2q0M63deuTFfJ--
