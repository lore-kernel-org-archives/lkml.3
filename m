Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbaGRFTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 01:19:38 -0400
Received: from ozlabs.org ([103.22.144.67]:51000 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbaGRFTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:19:37 -0400
Date: Fri, 18 Jul 2014 15:19:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: linux-next: manual merge of the irqchip tree with the arm64 tree
Message-ID: <20140718151930.54d5347c@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/6SxFWciqwSaop==+iWfDZ9T"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6SxFWciqwSaop==+iWfDZ9T
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jason,

Today's linux-next merge of the irqchip tree got a conflict in
arch/arm64/Kconfig between commit 875cbf3e4614 ("arm64: Add audit
support") from the arm64 tree and commit 3e44358c12cc ("irqchip: gic:
Add support for ARM GICv2m MSI(-X)") from the irqchip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/Kconfig
index 27bbdb7a5b83,0f9b11de7816..000000000000
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@@ -11,7 -9,8 +11,9 @@@ config ARM6
  	select ARM_AMBA
  	select ARM_ARCH_TIMER
  	select ARM_GIC
+ 	select ARM_GIC_V2M if (PCI && PCI_MSI)
+ 	select ARM_GIC_V3
 +	select AUDIT_ARCH_COMPAT_GENERIC
  	select BUILDTIME_EXTABLE_SORT
  	select CLONE_BACKWARDS
  	select COMMON_CLK

--Sig_/6SxFWciqwSaop==+iWfDZ9T
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTyK5mAAoJEMDTa8Ir7ZwV8cMP/2hTO5jleE62Zq1mXdl9Xh0a
ZXzvrW1WO5GiFFo4NOQzl2cV7+ldutUT4+0Dx8ES2Cbc1yKs63sRi5P1Et0rZQdS
RVQjkDX5sV1cgKxB63+1OCB7RNx87sQRYsOD/UmkAWySygpliMFShrQnFH+k4mKl
U/7DScKqPOekVfSVwMjoZHMslL1AAMr2BD6+MLQghOgYkfgIFSTV2vI4cJ+j1geO
EdPAuoroWD+xoVmBri4KDJVRESaRSJIPvYuzdu/AAAjtkhpjiRQ6yYqJY6ylVQBD
9VGiPTQJHn+RdrOHvGBihBsxdU4SSRjjnWDu8p6hAcKMeIdUmBmSeRwDt73cfa5w
yEC/rCJGyclljHHOg3Gi84ElmXPD9hOhLYdk8ahm2VzBzyDCu4hoAA3LjHS766xV
cb/L42LQD8euygpCKgD/48mqgX4cv/sdmLcm9bm7JAzk/o9RrDZhRoqiIwBwTl+L
K8rt2Y6xPUHhpKC98ixuhoV4okMiIyVIFq14mBH30SGdvUOOkvhgmIuJxMLY0Gno
KrR5yD19zJ2I+7Mwuc3hTNC8WGaj77UCTjm/NxccrvnUXqF0uW9JLjdnxR/C5nFD
5WuWhYdOasKcbA7vBhL3DSCxIM2S3yceeZDzLr0NWCj9KH84cj7I0xEVsFd3Bmz3
CPjWWI1n0T5sdOUptFMo
=x42p
-----END PGP SIGNATURE-----

--Sig_/6SxFWciqwSaop==+iWfDZ9T--
