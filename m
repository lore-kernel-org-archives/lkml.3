Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaAOEUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 23:20:51 -0500
Received: from ozlabs.org ([203.10.76.45]:54144 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbaAOEUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 23:20:49 -0500
Date: Wed, 15 Jan 2014 15:20:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joerg Roedel <joro@8bytes.org>, Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>
Subject: linux-next: manual merge of the iommu tree with the drm tree
Message-Id: <20140115152041.2e80fe852696fd9cbaa6d21d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__15_Jan_2014_15_20_41_+1100_Aql5=/hIikivimkT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Jan_2014_15_20_41_+1100_Aql5=/hIikivimkT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joerg,

Today's linux-next merge of the iommu tree got a conflict in
drivers/gpu/drm/msm/Kconfig between commit 3083894f7f29 ("drm/msm:
COMPILE_TEST support") from the drm tree and commit 4c071c7b851b
("drm/msm: Fix link error with !MSM_IOMMU") from the iommu tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/msm/Kconfig
index bb103fb4519e,d3de8e1ae915..000000000000
--- a/drivers/gpu/drm/msm/Kconfig
+++ b/drivers/gpu/drm/msm/Kconfig
@@@ -2,7 -2,9 +2,8 @@@
  config DRM_MSM
  	tristate "MSM DRM"
  	depends on DRM
 -	depends on ARCH_MSM
 -	depends on ARCH_MSM8960
 +	depends on (ARCH_MSM && ARCH_MSM8960) || (ARM && COMPILE_TEST)
+ 	depends on MSM_IOMMU
  	select DRM_KMS_HELPER
  	select SHMEM
  	select TMPFS

--Signature=_Wed__15_Jan_2014_15_20_41_+1100_Aql5=/hIikivimkT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS1gyeAAoJEMDTa8Ir7ZwVixoP/j29Zrx47k59wIXonaoMy8Ub
yraXnWk/nRXp3sHCp5Q3UvlDcun3zdyCMvm1ag16MTPpy+xVCxmgH+FawStZO2a0
TGXVsfipjBtXfmsUtKEJpUKDInrT1XKdPXe8gjS9xy1aNFHuQM5SK8dyFfPdKKzi
7w248cg3x1KR1LH275qHHv0sDYFXzNsd421TRap6H7tLzjWoBnG9j/5mcvorNl0v
D8DNiqggpt+WmRl0OPjqygvoa6sl8UlT3DAmrLozMrVmvtpacr4KkFR2Ikt/Hjvj
5gT0L97TG/fGVfZlxnRzNp6qOCBX+VWe2oLysf9CxoUKxc6Pm151lpr8W2fy7qYF
7kqVsSZ5gSTZAODnlT7tL6PGtOGd1QWRviB/VWHSYLsY3adr+v0wtn0PUs9dBx1e
3eG9r4p3JVQF2YGOO0N4x4TA30VdHb6lesSyZs0qugSnCsfY0nzab02h4QzCGWhQ
dP2n1IqxaSra1j5xE+l26Cnhd46A2Qmlu2WWGFxFnog0WzefOKDy4g4h7YUC1RnP
zwGG+f3PITLyFBh13gTExQOl9tOptnB4C1dkIKYGnejJYpG+GEbyBGmfGyDv9IOa
dWJ777OVEhc2aZaJ80fK4muBy8x+NdsZWlL5ikkwoe2Km2/356DxFmIfPfaUAI+Q
H2vS9JqSv9tcV4yBca/5
=BBKT
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Jan_2014_15_20_41_+1100_Aql5=/hIikivimkT--
