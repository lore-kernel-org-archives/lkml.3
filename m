Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaCaCzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 22:55:07 -0400
Received: from ozlabs.org ([203.10.76.45]:39766 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbaCaCzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 22:55:05 -0400
Date: Mon, 31 Mar 2014 13:54:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Widawsky <benjamin.widawsky@intel.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20140331135459.d00ea1ef9ed6aee65cf0f602@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__31_Mar_2014_13_54_59_+1100_kiHwhg87a0HBZjoA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__31_Mar_2014_13_54_59_+1100_kiHwhg87a0HBZjoA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/i915_gem_gtt.c between commit 8ee661b50561
("drm/i915: Undo gtt scratch pte unmapping again") from Linus' tree and
commit 782f149523d3 ("drm/i915: Make clear/insert vfuncs args absolute")
from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_gem_gtt.c
index d278be110805,63a6dc7a6bb6..000000000000
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@@ -840,9 -1337,9 +1337,9 @@@ void i915_gem_suspend_gtt_mappings(stru
  	i915_check_and_clear_faults(dev);
 =20
  	dev_priv->gtt.base.clear_range(&dev_priv->gtt.base,
- 				       dev_priv->gtt.base.start / PAGE_SIZE,
- 				       dev_priv->gtt.base.total / PAGE_SIZE,
+ 				       dev_priv->gtt.base.start,
+ 				       dev_priv->gtt.base.total,
 -				       false);
 +				       true);
  }
 =20
  void i915_gem_restore_gtt_mappings(struct drm_device *dev)

--Signature=_Mon__31_Mar_2014_13_54_59_+1100_kiHwhg87a0HBZjoA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTONkHAAoJEMDTa8Ir7ZwVCq8P/2L98Cp0gawckAbWsr1zBFwS
KCFu3MkJbNZ1ZG7R1Nac3qYTUvkrdCF9Va2thxtM40+ZCOO8+qnajadetw2BxjQX
x+ovEi8NYyo8G1QPGBzaVY7alUgc8WL3uaGyAUKOkDG4uvRKYqodIlijvaSR/oLK
0x+9J47yRifvIpy6/EgMPs6lU9Cb1ia3cYyhIzeU9DjvulYYji6SypWRUBErxpfQ
cmt7s8ZROGYVBvd9DsltF00sab8SSvxcmYtVw7sqav39zCrjGHEGTB71cawLvlac
zawBT/dzgOPgshje8Q9WT8VEOLv1K78ES/501wYkHsMnDs+MgbYOIQDEOrsYRJbU
Fm8+1jzF8Z8eN1nwepzY6+gh+WMLFiy1lDPh/fJ211V3qxBehGhm2TNcKcUJU80u
JOICbl6bpxRqi4vqlYomWrMVhYSyql+IEAxiHNr3GBozO5qyDWSokNCjJG5z6/B0
crhlu6nLYVuqjlfF1bB06OUrUaQMJdE28v1rSoAUN8kKkwfcXJI51bZXro1I1svK
a10GerhM/hMdHm7jDmYZadsBd5UtCkynDo8Fi5U05/7WHpKmpKUxtFOLAJFNL7vV
E0fgTTLQchq21YURsJLm3k3GvTcm1y0R+2dVpSAIfBLBtMiFNRQPIo+tKInVpHaB
D/GDAr9aavAFIl1DcpuL
=T2dX
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Mar_2014_13_54_59_+1100_kiHwhg87a0HBZjoA--
