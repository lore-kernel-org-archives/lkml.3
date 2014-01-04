Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbaADCct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 21:32:49 -0500
Received: from mout.gmx.net ([212.227.17.21]:58653 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbaADCcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 21:32:45 -0500
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: James Morris <jmorris@namei.org>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: TPM Changes for 3.14
Date: Sat, 4 Jan 2014 03:34:47 +0100
User-Agent: KMail/1.13.7 (Linux/3.12.6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7591735.vaNFp83hQG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201401040335.04980.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:EMxb5JMXc1+SluFFTBhT0NQ2bnCM3LhHhGmtqTy+BzPHJfwF6I9
 620l6Wu7JbrWUiZJW21DhXMLQVocD//wYSbNqpy7em/49fQ0gAFeE4/Sidge6AcJwLPVQpn
 TlEL2ab4aehmsnQQZoB9OH+ufqWDT9+HtjDTejxaqV5vqU6gLmjLZ5YqWbK9AUYTWkv+iC4
 U/rLb3OGJqlbWXLJhbz/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7591735.vaNFp83hQG
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi James,

since the next merge window approaches, can you please pull the following TPM Changes for 3.14?
I'll send the patches as replies to this email.


The following changes since commit 802eee95bde72fd0cd0f3a5b2098375a487d1eda:

  Linux 3.13-rc6 (2013-12-29 16:01:33 -0800)

are available in the git repository at:

  https://github.com/PeterHuewe/linux-tpmdd for-james

for you to fetch changes up to 34b720f8577f62ef7d9d06b46b7e3ad1a466bae5:

  tpm/tpm-sysfs: active_show() can be static (2014-01-04 03:24:00 +0100)

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

--nextPart7591735.vaNFp83hQG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAABAgAGBQJSx3NYAAoJEEAiHBCPCedzy/sQAKMAWHuxykWeoczwPv8oV5Bo
KsB+LaDcHy9ocyGUWn7FNlnd73FRDxSjH6iiHmfhyposlN2NFPtdIFhR+fIhL9bF
12DVn3WPSU9B838vrDFfvNdGXjjdfXbdPDU3edSdHVPWQtl+dSMllgxACp9A7F+/
NremjBNQ7HmvPPfvABzn0xi1irElbtcq4KJ0IobSO7t0MMTt4xHSIhy1pn/sXPIR
6T7eY3bt/2qil5Rqoa2/0d67DfMU+YqNCYb1Nq6f6SYKM50gvVdYOLqSI09g6L8+
QS3/Or+jH7HEiOtgPxF2b/TAAkHf3DYdPnFoPubJ+UyUybn+Ei6wQLTYRf5PlYYI
Sf5hUyMWStJ02kPyeVdPiG2DxcQseHOCFFQkMSDusr4OVqUeN7mgeAjLGlhwb0T8
MLqrFkAGMv9OZjXoJJcmsyqJnUeNjtIrCs/DDitXNVhoBBwEP3t63lV7PEGNUWs8
56OW9aAdzdXGQxbHgiO+1eCgW48k673RXztSNC0LCw/Ix5rffOMjrw1yjiaYUR65
LgMT8d1htXAuHVNTcdmH5qruy8GxJD0iDKWbIXiCXtrdnG8y9GIDjuC94yR394Bg
mdh00Momek+vilpu9jsqCPfX2WtKjF0N0YPJo0ZpmiPtwnGW7H+UcMCZ15tjv63a
xaoDOZDmm3+AV5JapsLT
=jC/I
-----END PGP SIGNATURE-----

--nextPart7591735.vaNFp83hQG--
