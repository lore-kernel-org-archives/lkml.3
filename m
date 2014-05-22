Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaEVF6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 01:58:16 -0400
Received: from ozlabs.org ([103.22.144.67]:59265 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbaEVF6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 01:58:15 -0400
Date: Thu, 22 May 2014 15:58:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: linux-next: manual merge of the drm-intel tree with the
 drm-intel-fixes tree
Message-ID: <20140522155807.76d25b06@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/VMvGh.p+sU9_=Y+bMCTYE=2"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VMvGh.p+sU9_=Y+bMCTYE=2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/i915_drv.h between commit f93e94efebbe ("drm/i915:
Fix dynamic allocation of physical handles") from the drm-intel-fixes
tree and commit 5cc9ed4b9a7a ("drm/i915: Introduce mapping of user
pages into video memory (userptr) ioctl") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_drv.h
index d6dc54aa123a,d2da390b6b9f..000000000000
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@@ -1609,9 -1712,21 +1697,21 @@@ struct drm_i915_gem_object=20
  	struct drm_file *pin_filp;
 =20
  	/** for phy allocated objects */
 -	struct drm_i915_gem_phys_object *phys_obj;
 +	drm_dma_handle_t *phys_handle;
- };
 =20
+ 	union {
+ 		struct i915_gem_userptr {
+ 			uintptr_t ptr;
+ 			unsigned read_only :1;
+ 			unsigned workers :4;
+ #define I915_GEM_USERPTR_MAX_WORKERS 15
+=20
+ 			struct mm_struct *mm;
+ 			struct i915_mmu_object *mn;
+ 			struct work_struct *work;
+ 		} userptr;
+ 	};
+ };
  #define to_intel_bo(x) container_of(x, struct drm_i915_gem_object, base)
 =20
  /**

--Sig_/VMvGh.p+sU9_=Y+bMCTYE=2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfZH0AAoJEMDTa8Ir7ZwV4b4P/1gFvHIBuxY352xYV+0lywSJ
8kCduzT0e0Pul7BiXfZtlY6JYaSrrc+k7BmUOK/6T8uYD2Q+3HssB1/jNt03+TkV
oDYRIezMz5uQY9M8mYZjmvcyY9ir5xuKBykcAEi7hxzV1MYk8aa7R9he4Pd9n9aE
rfzEhTfG638LB2ItnDyba8sai9FdhOAV4zIYKhT+8N85ccbbueY4ikVrOYNCa3eG
YI8B5eE6ujPHJzM5R0UneecyOjiqkLNsn3ggTE8Jfa6zkYcNaAdW2P+GkYLPcWw3
qOblhbxlHGP33eOKDHjqhizwIDnJz111tXIw57Jkorn+JmPjO+gOEjb6+ok69TOg
U7p/D4RZx3TbkMzrlnRQaWr9i1IPlwTDETXl0dYSOtgaht+6Y1+16uar/ylzfVrT
CgbS4Ig+jurwgNLmwP+19Dn1HS1G59SKIM4AE9iPpR7Yq6CpoIcHG08O5lmisu8v
cHDt5xcQKmt3mdrXe0w3X/e9uiZDIzh6SUmaTeDwZMfG3Le9Nd40G+4nUltftG60
g2cvDDVTsUGdeIvxhyYYSYwoKHJo4MkMm7i5gXi2FpwUSy9OBbAYo8fOxQR8RJEY
9Tlo5uTviEMV++kYYFBvQEVZcNS9UuTAF8xH1kzOM/Ncqz/b/LECGsinB+0Gtvsh
u+Bov9kFr+rInwQBzpr5
=chum
-----END PGP SIGNATURE-----

--Sig_/VMvGh.p+sU9_=Y+bMCTYE=2--
