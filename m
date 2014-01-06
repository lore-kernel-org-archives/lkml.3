Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaAFDWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 22:22:24 -0500
Received: from mout.gmx.net ([212.227.15.15]:61747 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbaAFDWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 22:22:23 -0500
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: James Morris <jmorris@namei.org>
Subject: Re: TPM Changes for 3.14
Date: Mon, 6 Jan 2014 04:24:36 +0100
User-Agent: KMail/1.13.7 (Linux/3.12.6+; KDE/4.10.5; x86_64; ; )
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <201401040335.04980.PeterHuewe@gmx.de> <alpine.LRH.2.02.1401061321510.31564@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1401061321510.31564@tundra.namei.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart17591780.WaNo69HBxh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201401060424.50738.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:RvDmN9o2hZ1t5KvAyhOaDw1vYXvuA+rwPEXOCf+5yR4o6+ojoZL
 iDEkmn+078g4diOybjakpLydnlzfxwxf/7FccdNiO/Wm/h/80925a1I8Oz3KJ/0FaLAJ/no
 WPfRuDdTQSjiQnDdeassjiUe4JycGQLWBCDmStyNyeZUKO8U25V+4l8qFrQ8oeeIsOjlB4T
 KQx39xjczcGU3aFWspEsA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart17591780.WaNo69HBxh
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi James,

> Please generate this against my next branch.
Here it is - note:
I cherry-picked the changes that went through the xen tree before applying my changes.

The following changes since commit dcf4e392867bf98d50ad108ed7c2bfb941e8c33d:

  ima: remove unneeded size_limit argument from ima_eventdigest_init_common() (2014-01-03 07:43:00 -0500)

are available in the git repository at:

  https://github.com/PeterHuewe/linux-tpmdd for-james

for you to fetch changes up to 7c39ec23f227d1da8e54907e83873bf912886fb5:

  tpm/tpm-sysfs: active_show() can be static (2014-01-06 04:01:48 +0100)

----------------------------------------------------------------
Fengguang Wu (2):
      tpm/tpm_i2c_atmel: fix coccinelle warnings
      tpm/tpm-sysfs: active_show() can be static

Jason Gunthorpe (9):
      tpm: xen-tpmfront: Fix default durations
      tpm: xen-tpmfront: Remove the locality sysfs attribute
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

Rob Herring (1):
      tpm: xen-tpmfront: fix missing declaration of xen_domain

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
 drivers/char/tpm/xen-tpmfront.c     |  82 +-----
 include/linux/tpm.h                 |  12 +
 18 files changed, 641 insertions(+), 927 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-dev.c
 create mode 100644 drivers/char/tpm/tpm-sysfs.c


Thanks,
Peter

--nextPart17591780.WaNo69HBxh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAABAgAGBQJSyiICAAoJEEAiHBCPCedzNTsP/3yyA/fYYOmjhADaB0IPYR1B
IwJl+QQ1TUA0NHz7gUKy6kdAQ67ANcZLST2EKPxRS2No63BK8ct1RXhGLTkKZTRo
ryXVmO/Cia6Xk2qowCG8RMU9uNYICztu8tOOFWqe7R2Ivt8vqqdwQTr9KIxkAt07
QyhheUvGAHQJ1BMVm95TEl/8muisF1CVKXHULqkZvhQ+t1iN7jdHIvao/1rG2/iS
IeSIqjOGl3OKRFiN0xBRzwDSqtqi+faHSXcOnYSIbaOdkvF8engFyiLvnKJSZvoO
CzbAZae/yHJxkD517mqCDhEAk/MW0AdT3jmDsb2Lxu/JQ7cXDLcHhDlVoC9VraoN
nfSOzAglNs62QFpay8ob3NJWHOyw8YP1FgTEjxkUCuHT68ttrZI6rYZWiJccshGh
KEsNn6RtszxUT4zwJ7IISsVQlNI57Ymt6F0jw5QXlPOe+vwA5MecVSCGDohSrKbh
OEPkP1JfOH1Rtn7DpOOfmm09HmnmBvLjrQ/ZoEIaR06qneA3uafdUqtNQuk5nGq1
bAdoGb2wOBjVh1KkCHNvCqK58WAwARQIiV8a/taZbGvlqcC7gqFo3ikbVP4Ysaun
XjiJwKx+P5KH2PsjOkaqwLJwx9hSvyrC64pkhOw4OBwrIfiMBhola2KdFOy/4aoa
WBqRQ3j1Wbek+TNkLrGC
=Sc0m
-----END PGP SIGNATURE-----

--nextPart17591780.WaNo69HBxh--
