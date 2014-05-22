Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaEVFko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 01:40:44 -0400
Received: from ozlabs.org ([103.22.144.67]:48502 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaEVFkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 01:40:42 -0400
Date: Thu, 22 May 2014 15:40:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: linux-next: manual merge of the drm tree with the drm-intel-fixes
 tree
Message-ID: <20140522154035.76113672@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/MIvERoTDkxZ_aV0eaX2tfFd"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MIvERoTDkxZ_aV0eaX2tfFd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/i915_gem.c between commit f93e94efebbe ("drm/i915:
Fix dynamic allocation of physical handles") from the drm-intel-fixes
tree and commit c8725f3dc091 ("drm/i915: Do not call retire_requests
from wait_for_rendering") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_gem.c
index 3326770c9ed2,e1fa919017e2..000000000000
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@@ -43,7 -43,14 +43,9 @@@ static void i915_gem_object_flush_cpu_w
  static __must_check int
  i915_gem_object_wait_rendering(struct drm_i915_gem_object *obj,
  			       bool readonly);
+ static void
+ i915_gem_object_retire(struct drm_i915_gem_object *obj);
 =20
 -static int i915_gem_phys_pwrite(struct drm_device *dev,
 -				struct drm_i915_gem_object *obj,
 -				struct drm_i915_gem_pwrite *args,
 -				struct drm_file *file);
 -
  static void i915_gem_write_fence(struct drm_device *dev, int reg,
  				 struct drm_i915_gem_object *obj);
  static void i915_gem_object_update_fence(struct drm_i915_gem_object *obj,

--Sig_/MIvERoTDkxZ_aV0eaX2tfFd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfY3YAAoJEMDTa8Ir7ZwVGpUP/RbXhrHuvj79eAfSY44KnV6w
pZyeHeNk1ziSXBGf3rYynITEufrtbk5Zkdbf/4Ob5zcoqoD7wa9D3o7+/jIGu+wV
RcsMML2gbCa5RPT/B4VpLRnFvFc+eCjpWg3+r0tmSVCmSEorvMEKqQqwTz4LWlEa
aYGJjN19+Yp/EUX5TM+nIKSdLVmHoRd0XeLbI6BA4aNQqFUhiPwynSo8On6wStEb
ICM6tGlhu3MGAnY+FJjYEyB5S1cgSlFOKZl05IylBF3wLfRlIpnMCmsyVtlgR5QP
R81Swb/zqUxeoibhOt8i75KR2f5CjEqFMXJIf6PxDUh5gW5nyRLI+P9Jiph+N71r
IX1Zk50T849+HFN1n9ILBHbEkht4sP1qF1uzA82UzAl+4cQ1x8N9yFZHRv7LP458
7s1teilWcTSIPr+wrrznpGRt/kVktlD/WGabiepFpJDJBnWdto20d7u8iI+A0fc5
LvBrw1mEfZHr1dt+LlzFw9kn4dI2MOP3wbdgluOvqOe+NMHfq1VAK+zLzgwRSwyN
g9a7jjFjfYuf7I+v8ZLE2tqumdDMknDb5aBuOC1KgAyMebox9NvO7FWJecfMVlT9
+y75u//IlBgW+zczpqi0HjQrvy1mDk4YeTje+MpGciOFoT92MHgz+JArxb7BLpnb
tdMle/A3E2E/tdeR5Jj1
=SwwT
-----END PGP SIGNATURE-----

--Sig_/MIvERoTDkxZ_aV0eaX2tfFd--
