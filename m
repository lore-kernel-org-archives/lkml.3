Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbbA2CjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:39:08 -0500
Received: from ozlabs.org ([103.22.144.67]:42268 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762477AbbA2CjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:39:04 -0500
Date: Thu, 29 Jan 2015 13:38:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oded Gabbay <oded.gabbay@amd.com>, Ben Goz <ben.goz@amd.com>
Subject: linux-next: build failure after merge of the drm tree
Message-ID: <20150129133857.2bdbb86d@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/fL0GHk8.12z8rVJko.HN3BN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fL0GHk8.12z8rVJko.HN3BN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/gpu/drm/amd/amdkfd/kfd_device.c: In function 'kgd2kfd_device_init':
drivers/gpu/drm/amd/amdkfd/kfd_device.c:193:11: error: 'max_num_of_processe=
s' undeclared (first use in this function)
  size +=3D (max_num_of_processes * sizeof(struct pm4_map_process) +
           ^
drivers/gpu/drm/amd/amdkfd/kfd_device.c:193:11: note: each undeclared ident=
ifier is reported only once for each function it appears in
drivers/gpu/drm/amd/amdkfd/kfd_device.c:194:26: error: 'max_num_of_queues_p=
er_process' undeclared (first use in this function)
   max_num_of_processes * max_num_of_queues_per_process *
                          ^

Caused by commit b8cbab042cd6 ("drm/amdkfd: Allow user to limit only
queues per device") from Linus' tree interacting with commit
e18e794e6ba0 ("drm/amdkfd: Fixed calculation of gart buffer size") from
the drm tree.

I couldn't easily figure out how to fix this, so I just disabled the
driver using the patch below.  Please let me know when it is fixed, or
provide me with a merge fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 29 Jan 2015 13:34:22 +1100
Subject: [PATCH] drm/amdkfd: disable driver due to interaction with a bug f=
ix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/gpu/drm/amd/amdkfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/Kconfig b/drivers/gpu/drm/amd/amdkf=
d/Kconfig
index 8dfac37ff327..e96b4d6e3567 100644
--- a/drivers/gpu/drm/amd/amdkfd/Kconfig
+++ b/drivers/gpu/drm/amd/amdkfd/Kconfig
@@ -5,5 +5,6 @@
 config HSA_AMD
 	tristate "HSA kernel driver for AMD GPU devices"
 	depends on DRM_RADEON && AMD_IOMMU_V2 && X86_64
+	depends on BROKEN
 	help
 	  Enable this if you want to use HSA features on AMD GPU devices.
--=20
2.1.4

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/fL0GHk8.12z8rVJko.HN3BN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUyZ1GAAoJEMDTa8Ir7ZwVXg8QAIOzeGlgHHY38I6BqAdgjbNo
Io6OJiRInFtaK2/Cz5L44BX/trkD4DCrltp3NbQx4+umBeZDhU9dd+kbOMTIHNMc
pQ2S1TosoiieMkH4zdxWd86vdR5AxmDocakfgcQ3oF41oyGJnP9anM6kAvAlthE6
OD09cXf+byMTrgeghnBK9W2sGAVfbwWHH6Gnnyy4zlwH8dDKfbrJE/62pzPTv4Dq
1APXmJwWhHdDUaW3eBIu+YTXZj88OhgCSz1pTOUl/1QpA8Jq7QWvu5lqKgpHEI6u
LvAZ7UjpViCILRaP4gAHPrO3Gk1C719LjhPDSOB576axWP8fr/dMyq0dg4YfH8aL
z89SEJBSohaVaxZr0NhdmEeCCxfvCxEXAyGAUiPxLx9TX8Pp/LNeStHWrxIYpm3Z
tx/BWpyj426fH9CcpyAmTW/TgLk7U1pbTJMETMmHDymtolwAkov7Ti2lTlPdZm9H
gk2ptrUu9qFZYOiTXL0gkxo8s8xo4lEY0zV10ApSb6wCJ5OP3ZcHzItJJw1/myDp
NmX7evrIe4dDk48w0LB0Q22QJz30AxhQjNdIh+otK0CxqZx3RxYNckbm94rqXKyY
ci3VztxnOE8y5GqNXMeSn9afmputxpU/T8WvGS/tXdAd5f3kkDwQLBMu6hSUi6P9
+ocBQF6bsHUW1OLVyKYw
=Ey+L
-----END PGP SIGNATURE-----

--Sig_/fL0GHk8.12z8rVJko.HN3BN--
