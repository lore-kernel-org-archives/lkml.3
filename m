Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaAVFnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 00:43:01 -0500
Received: from ozlabs.org ([203.10.76.45]:45394 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbaAVFm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 00:42:59 -0500
Date: Wed, 22 Jan 2014 16:42:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Lv Zheng <lv.zheng@intel.com>
Subject: linux-next: manual merge of the drivers-x86 tree with the pm tree
Message-Id: <20140122164254.6880efb8506ed4636768d935@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_Jan_2014_16_42_54_+1100_5fOYg=WRj_5TDjTc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Jan_2014_16_42_54_+1100_5fOYg=WRj_5TDjTc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

Today's linux-next merge of the drivers-x86 tree got a conflict in
drivers/platform/x86/mxm-wmi.c between commit 8b48463f8942 ("ACPI: Clean
up inclusions of ACPI header files") from the pm tree and commit
475879d65123 ("drivers: platform: Include appropriate header file in
mxm-wmi.c") from the drivers-x86 tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/platform/x86/mxm-wmi.c
index 3c59c0a3ee0f,7503d2b9b073..000000000000
--- a/drivers/platform/x86/mxm-wmi.c
+++ b/drivers/platform/x86/mxm-wmi.c
@@@ -20,7 -20,9 +20,8 @@@
  #include <linux/kernel.h>
  #include <linux/module.h>
  #include <linux/init.h>
+ #include <linux/mxm-wmi.h>
 -#include <acpi/acpi_bus.h>
 -#include <acpi/acpi_drivers.h>
 +#include <linux/acpi.h>
 =20
  MODULE_AUTHOR("Dave Airlie");
  MODULE_DESCRIPTION("MXM WMI Driver");

--Signature=_Wed__22_Jan_2014_16_42_54_+1100_5fOYg=WRj_5TDjTc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS31phAAoJEMDTa8Ir7ZwVASAP+wdqGFeFQuslrJ5JRIQ4dmB2
1Nw1I1xjTsXGgb5uYNJ/bnz4uaRF84qkKWfSHt3nx2hhDUjjVL6uS6QnGUz2L8hV
VbrlbaGgFtjDE47E3fB8DmJsDkKtq8d68RsMs0+sDCP9AYcsaOWJVwFvS6rL1E+t
LWbavw9wA2cJGz0r2dtgAM2vf0N6VO0dEQ9f9lYGy8PuWaEyp+NiE1ojz6v+xh3R
0HekmLqnsAyzuhe1rBFIihQZtwWxxbsctVZ2OSGvATkDr5/PKwUERZYGDIfi4R3V
n9wj+DpZTUHNrhy1dblIHiKbICT5OF0VNBLWViialoS9KEezhpkj0hLMb+1wWiYG
Nr20XbHUzhfidAzJEgjRA1RNZj4pSiGfJbnotCRWcQ+hCMtGEfT1+TUM/24VbqD2
yP/smhQZU+9Wbu61o/RFJHFQalXTS+NNR86M3EM8zULpxraqTH4/vvj+EYvcXzgB
cphASuTRoYeddzpzlL4Wi27IONsVCmjPDPfii90xtawq3Oev5d/nXj2/QVyERiFE
o7cHjCkz5s770zUN886Qcc5E8Q9c157JSs7RGojDB/7sEAcXUsqq+XKIvjoUlcm7
9YAwAWlUj8/g63wAsmtS4q8pSZepOFg1KcjnFpgBnn4Cg97hg33KPEZJ+fzTYuXo
MBcN+SVYrswrr9nvYSbW
=7v3M
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Jan_2014_16_42_54_+1100_5fOYg=WRj_5TDjTc--
