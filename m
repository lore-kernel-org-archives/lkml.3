Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaHNDKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 23:10:45 -0400
Received: from ozlabs.org ([103.22.144.67]:46304 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbaHNDKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 23:10:43 -0400
Date: Thu, 14 Aug 2014 13:10:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benoit Taine <benoit.taine@lip6.fr>
Subject: linux-next: manual merge of the tip tree with the pci-current tree
Message-ID: <20140814131031.4ecce959@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/D92XPimoKdfNBjc6LdfI_gd"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/D92XPimoKdfNBjc6LdfI_gd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/kernel/cpu/perf_event_intel_uncore.c between commit
9baa3c34ac4e ("PCI: Remove DEFINE_PCI_DEVICE_TABLE macro use") from the
pci-current tree and commits 92807ffdf32c ("perf/x86/uncore: Move
NHM/SNB/IVB specific code to seperate file") and 8268fdfc45b7
("perf/x86/uncore: Move SNB/IVB-EP specific code to seperate file")
from the tip tree.

I fixed it up (I used the latter version of this file and applied the
following merge fix patch) and can carry the fix as necessary (no
action is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 14 Aug 2014 13:07:52 +1000
Subject: [PATCH] perf/x86/uncore: fix for DEFINE_PCI_DEVICE_TABLE removal

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore_snb.c   | 6 +++---
 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snb.c b/arch/x86/k=
ernel/cpu/perf_event_intel_uncore_snb.c
index 6e7811f3ea73..e0e934c8ee77 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snb.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snb.c
@@ -447,7 +447,7 @@ static struct intel_uncore_type *snb_pci_uncores[] =3D {
 	NULL,
 };
=20
-static DEFINE_PCI_DEVICE_TABLE(snb_uncore_pci_ids) =3D {
+static const struct pci_device_id snb_uncore_pci_ids[] =3D {
 	{ /* IMC */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SNB_IMC),
 		.driver_data =3D UNCORE_PCI_DEV_DATA(SNB_PCI_UNCORE_IMC, 0),
@@ -455,7 +455,7 @@ static DEFINE_PCI_DEVICE_TABLE(snb_uncore_pci_ids) =3D {
 	{ /* end: all zeroes */ },
 };
=20
-static DEFINE_PCI_DEVICE_TABLE(ivb_uncore_pci_ids) =3D {
+static const struct pci_device_id ivb_uncore_pci_ids[] =3D {
 	{ /* IMC */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IVB_IMC),
 		.driver_data =3D UNCORE_PCI_DEV_DATA(SNB_PCI_UNCORE_IMC, 0),
@@ -463,7 +463,7 @@ static DEFINE_PCI_DEVICE_TABLE(ivb_uncore_pci_ids) =3D {
 	{ /* end: all zeroes */ },
 };
=20
-static DEFINE_PCI_DEVICE_TABLE(hsw_uncore_pci_ids) =3D {
+static const struct pci_device_id hsw_uncore_pci_ids[] =3D {
 	{ /* IMC */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_HSW_IMC),
 		.driver_data =3D UNCORE_PCI_DEV_DATA(SNB_PCI_UNCORE_IMC, 0),
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86=
/kernel/cpu/perf_event_intel_uncore_snbep.c
index d3e9c55d984a..6606ed05d311 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -960,7 +960,7 @@ static struct intel_uncore_type *snbep_pci_uncores[] =
=3D {
 	NULL,
 };
=20
-static DEFINE_PCI_DEVICE_TABLE(snbep_uncore_pci_ids) =3D {
+static const struct pci_device_id snbep_uncore_pci_ids[] =3D {
 	{ /* Home Agent */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_HA),
 		.driver_data =3D UNCORE_PCI_DEV_DATA(SNBEP_PCI_UNCORE_HA, 0),
@@ -1542,7 +1542,7 @@ static struct intel_uncore_type *ivbep_pci_uncores[] =
=3D {
 	NULL,
 };
=20
-static DEFINE_PCI_DEVICE_TABLE(ivbep_uncore_pci_ids) =3D {
+static const struct pci_device_id ivbep_uncore_pci_ids[] =3D {
 	{ /* Home Agent 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe30),
 		.driver_data =3D UNCORE_PCI_DEV_DATA(IVBEP_PCI_UNCORE_HA, 0),
--=20
2.1.0.rc1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/D92XPimoKdfNBjc6LdfI_gd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT7CiwAAoJEMDTa8Ir7ZwVVhYP/izK/t5JbbRzBhnjpqIoen3L
BpezsWxfYTkje3B1ikUMy5jh1jK6WRgHoiC8jq6tp61AuOV8NbvXiXNHMTR4TAZT
2EiRXn/b6kX3k+k/BDcjMuk9BNDf3TPno3kiUEFhr7Fh/MzhMHrg+roXLCX16lqX
VX9L61HBjZL+G9c7CP/uomZSQjZMyFT65W66/q08sWnPHwyNC0KXW/iQEWJOvjUO
Wzy3VP6RtPZNwLW7rFMoljQc+x96gnB+VF2hqgXuoNxOasJNK5MLo5yerqSUKiKp
k5ueY7clh4aK6lZ2ChcQpZpYrkcRhLi/D49D94eMM1cjTBxkC2dAOLlhtdQROqXz
gkx9y9KUl6IOAgO0kiRDomVjNTRi5nsXsik13LMJcMU4MopX4R2fTRW8cnaT7QSX
EisPRaIr8h3WNloAvEqGmNHfosy5AxOV3GJcp3Y+dZifMIRw2CKWajtkKISbFqcx
iMYRl/tGKsSYuJEH5QIg4CNmct1HoFf64f+ukb1mPn6K8+qmV9swiw0+jt7AaOV3
RL8ijCtiMlE2zZr5NTN0Hssk3Am0WgbOzHdxPzQ5wvGX5V15AyzlbJeBIYoYnbn4
NRF8yav039hVKLdxBKz3bkdnAucVDc7st033VGwMibBOx/zG/iI2fpJp7/7JnZ6u
4aV/K8eqZYTEGaS3aj6K
=49KJ
-----END PGP SIGNATURE-----

--Sig_/D92XPimoKdfNBjc6LdfI_gd--
