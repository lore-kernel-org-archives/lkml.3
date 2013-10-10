Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab3JJKMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:12:31 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:49612 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab3JJKMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:12:30 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, monstr@monstr.eu,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: mm: Fix ECC mem policy printk
Date: Thu, 10 Oct 2013 12:12:08 +0200
Message-Id: <ef807d1f329e54c42fdaca8d97cf58ac7c4dc1ed.1381399914.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-20514-1381399929-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-20514-1381399929-0001

ECC policy is just connected to L1 cache
(IMP - bit 9 - in L1 page table entry format)
and has no connection to other ECC capable devices
in the system. That's why declaring connection with
L1 cache make sense.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
IRC printk without KERN_ facility level is just INFO.
Please correct me if I am wrong.

---
 arch/arm/mm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index b1d17ee..e9899dc 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -556,7 +556,7 @@ static void __init build_mem_type_table(void)
 		mem_types[MT_CACHECLEAN].prot_sect |= PMD_SECT_WB;
 		break;
 	}
-	printk("Memory policy: ECC %sabled, Data cache %s\n",
+	pr_info("Memory policy: L1 ECC %sabled, Data cache %s\n",
 		ecc_mask ? "en" : "dis", cp->policy);

 	for (i = 0; i < ARRAY_SIZE(mem_types); i++) {
--
1.8.2.3


--=_mimegpg-monstr-desktop-20514-1381399929-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJWfXoACgkQykllyylKDCGBqwCdGpX56eX5iIFNf8a2r3wSHzNz
w08An0Mq1ecCI/ia4LtI0EyhJC3jYktK
=vQZJ
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-20514-1381399929-0001--
