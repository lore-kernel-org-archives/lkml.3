Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaAFNmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 08:42:22 -0500
Received: from mout.gmx.net ([212.227.15.18]:55101 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbaAFNmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:42:20 -0500
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: James Morris <jmorris@namei.org>
Subject: [GIT PULL]TPM Changes for 3.14
Date: Mon, 6 Jan 2014 14:44:37 +0100
User-Agent: KMail/1.13.7 (Linux/3.12.6+; KDE/4.10.5; x86_64; ; )
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
References: <201401040335.04980.PeterHuewe@gmx.de> <201401060424.50738.PeterHuewe@gmx.de> <alpine.LRH.2.02.1401062227080.4512@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1401062227080.4512@tundra.namei.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1809225.oza6CIR56N";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201401061444.48889.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:BjfCkKLWbI3fwdLJhK428j/0Tw3yHbNYBGBA8H6FFNC0Wyy5PvJ
 VUrqdW3xxoDS1XQZtE/xanwu+7kVsYeEkTygVltQ159dSWD1I65yE5BOw4aU4fCE5H7PVdd
 o7B32cES9KEJWzJrCa1qJC9ZJKPyHDmnwlRFxDNJ0Y6pVV5SORSPahCZNB3NO6d4xwxPiDQ
 Jp7+/TX9lKp491Voboggw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1809225.oza6CIR56N
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi James,

The following changes since commit 38fd2c202a3d82bc12430bce5789fa2c2a406f71:

  Merge to v3.13-rc7 for prerequisite changes in the Xen code for TPM (2014-01-06 22:23:01 +1100)

are available in the git repository at:


  https://github.com/PeterHuewe/linux-tpmdd for-james

for you to fetch changes up to 5f64822d63efa20cee9efe8766b3a62ab6a1f6c3:

  tpm/tpm-sysfs: active_show() can be static (2014-01-06 14:37:25 +0100)

----------------------------------------------------------------
Fengguang Wu (2):
      tpm/tpm_i2c_atmel: fix coccinelle warnings
      tpm/tpm-sysfs: active_show() can be static

Jason Gunthorpe (7):
      tpm: Pull everything related to /dev/tpmX into tpm-dev.c
      tpm: Move sysfs functions from tpm-interface to tpm-sysfs
      tpm: Pull all driver sysfs code into tpm-sysfs.c
      tpm: Create a tpm_class_ops structure and use it in the drivers
      tpm: Use the ops structure instead of a copy in tpm_vendor_specific
      tpm: Make tpm-dev allocate a per-file structure
      tpm: tpm_tis: Fix compile problems with CONFIG_PM_SLEEP/CONFIG_PNP

Michal Nazarewicz (1):
      char: tpm: nuvoton: remove unused variable

Peter Huewe (5):
      tpm/tpm_ppi: Do not compare strcmp(a,b) == -1
      tpm/tpm_ppi: Check return value of acpi_get_name
      tpm/tpm_i2c_stm_st33: Check return code of get_burstcount
      tpm/tpm_ibmvtpm: fix unreachable code warning (smatch warning)
      tpm: MAINTAINERS: Cleanup TPM Maintainers file

 MAINTAINERS                         |   8 +-
 drivers/char/tpm/Makefile           |   2 +-
 drivers/char/tpm/tpm-dev.c          | 213 ++++++++++++++++
 drivers/char/tpm/tpm-interface.c    | 488 +++---------------------------------
 drivers/char/tpm/tpm-sysfs.c        | 318 +++++++++++++++++++++++
 drivers/char/tpm/tpm.h              |  83 +++---
 drivers/char/tpm/tpm_atmel.c        |  28 +--
 drivers/char/tpm/tpm_i2c_atmel.c    |  44 +---
 drivers/char/tpm/tpm_i2c_infineon.c |  42 +---
 drivers/char/tpm/tpm_i2c_nuvoton.c  |  43 +---
 drivers/char/tpm/tpm_i2c_stm_st33.c |  48 +---
 drivers/char/tpm/tpm_ibmvtpm.c      |  41 +--
 drivers/char/tpm/tpm_infineon.c     |  28 +--
 drivers/char/tpm/tpm_nsc.c          |  28 +--
 drivers/char/tpm/tpm_ppi.c          |  11 +-
 drivers/char/tpm/tpm_tis.c          |  49 +---
 drivers/char/tpm/xen-tpmfront.c     |  45 +---
 include/linux/tpm.h                 |  12 +
 18 files changed, 640 insertions(+), 891 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-dev.c
 create mode 100644 drivers/char/tpm/tpm-sysfs.c


Thanks,
Peter

--nextPart1809225.oza6CIR56N
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAABAgAGBQJSyrNQAAoJEEAiHBCPCedzU58P/3twKTRxCkogjtFMzx8k8CnW
a9o4uLKw3mBvFoOjOe5rBW/SWsX13kYeE1QdlDVLElhvBQooVFArxf1VMu6zyEIl
k70sR4SlYCjNSYegqTTbhZCOZzEQb8b4eQ43PPPbQ1oYFDA3eino845faIwmBBKn
zOpyYxF1S0SLpoCKd0+1+ZfhP8OLT7mm2PhIwS1VWWk/DgNIUoc6wJLMeKGKPon6
ajZi3p7PivOQKCXIO9EVapkesIQiK48Wppww/t+UPOtwEShajQWueSO7cq/gUg1Q
336s3wjb2KiiJaPkihZRhF3EeeX8NRdWmepLxYpjObUuRQqYCbl+YzCOU731kN/H
22HgyQKccFvOWvqQ0wABX0qcQxDy2WNRMpAPFywfrvdHS4ZYW2FJQCFR1BKWhYL2
TkRqRpxwk/6SOdvfratv71mwCdK1Y10H2+ML/v01XfBi7Zo/co3liYRYqvH3PAmd
ZSCFvfL6HKxpD7UIVA++OTdWXYiOcGS06W7cYa4VOljdswaRscSRBM0HEa+vPSnD
xl1YV1fOda983P9dP0e/kzTDjeSK/Ek5BR+yAODL5O7cDBtGr6IxQd4aq1qDaslz
/5tWa8pILlWhZNd6+tq1EL3gFHjouGUKhCaLSXve9WgQo6yLVElpy9SHd71nI03u
J7vMYfW45hiMSN8SQj8G
=/q4J
-----END PGP SIGNATURE-----

--nextPart1809225.oza6CIR56N--
