Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaCXDiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 23:38:54 -0400
Received: from ozlabs.org ([203.10.76.45]:53429 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbaCXDix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 23:38:53 -0400
Date: Mon, 24 Mar 2014 14:38:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: linux-next: manual merge of the tip tree with the drm tree
Message-Id: <20140324143846.39a09ca7ed3de2b089eef1c7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Mar_2014_14_38_46_+1100_YMBUzQQAECHUA+dH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Mar_2014_14_38_46_+1100_YMBUzQQAECHUA+dH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/gpu/drm/gma500/mmu.c between commit b219372dff81 ("drm/gma500:
Make SGX MMU driver actually do something") from the drm tree and commit
840d2830e6e5 ("x86, cpufeature: Rename X86_FEATURE_CLFLSH to
X86_FEATURE_CLFLUSH") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/gma500/mmu.c
index 3e14a9b35252,c3e67ba94446..000000000000
--- a/drivers/gpu/drm/gma500/mmu.c
+++ b/drivers/gpu/drm/gma500/mmu.c
@@@ -478,8 -520,7 +478,8 @@@ struct psb_mmu_driver *psb_mmu_driver_i
 =20
  	driver->has_clflush =3D 0;
 =20
 +#if defined(CONFIG_X86)
- 	if (boot_cpu_has(X86_FEATURE_CLFLSH)) {
+ 	if (boot_cpu_has(X86_FEATURE_CLFLUSH)) {
  		uint32_t tfms, misc, cap0, cap4, clflush_size;
 =20
  		/*

--Signature=_Mon__24_Mar_2014_14_38_46_+1100_YMBUzQQAECHUA+dH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTL6jKAAoJEMDTa8Ir7ZwV3lQP/i4i/TA2HoDQmEWmXW+18sS6
Ofg8Z4tcV9DZ15215s+iF7TAJ/YF5aJvfj0HJLmRpA48CCsHyFU4O2hFvrABjZ3A
mImUaXwB3PF64yAU7uGjLT9NKE8Sk18P77IQcydRSTs3byjPgj2r+RVvhlo7znWs
uMpXsmOH8vgvi504UUEsV+JuGoCH31ndcAve4S94eanRR8sRjSNuLqFNBOvPWNFy
O8lw6BKROiqLXcXFsTdAIVxCTXwnC5sSIeS7YFFfINYdz20YnrjrV294oDgMFkM2
UJTE1JKrSQ/EnHq78C5o7JkZXpmIpNBK6OwvFL/1Yol4+Sdf5Kxeo6fY4ekAQyTB
9Ge5wfGexqJAIf7PHL/4xO+om8TIaKvdyO71ro5OkgnzoSfRmSrRUZgA5Y8JA3pG
ymAT6578qvRRTKIW5Huics7dnTc4N1zS7aEaSVOR7i5NR6ua4HpfiRXU8KG7G4MC
QTb322bwRfRiRrz8EvG8BaWigU7PAujHnO0+W8HytC12Tg6VC2w88HNjtHjBFCGn
gf24dPLP3kFFBIVWZGL26VDvcK0k2/365fnXhV2A0S5ddXrTl9ObgdNQuwEE1yH1
9gs4s1QyoihYN9QIkiuwt6WMTgXmacIiiZccOTTONDD/CuQwoqpQH5sx2PaNyQCH
ePX6bFi1493mrZXxZWKx
=DtQb
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Mar_2014_14_38_46_+1100_YMBUzQQAECHUA+dH--
