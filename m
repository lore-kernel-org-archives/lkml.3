Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3KANm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:42:59 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:57132 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3KANm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:42:57 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org,
        monstr@monstr.eu, Nicolas Pitre <nico@linaro.org>,
        Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] ARM: mm: Fix ECC mem policy printk
Date: Fri,  1 Nov 2013 14:42:40 +0100
Message-Id: <a485e15ece42ac9a9e1361ec849b4f1eb05748df.1383313334.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-12376-1383313360-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-12376-1383313360-0001

ECC policy can be applied to the whole system
when this bit is implemented by SoC vendor
(IMP - bit 9 - in L1 page table entry format).
When this bit is not implemented by SoC vendor
it doesn't mean that system has no other way
how to do ECC.
This patch ensures to show this message only when ECC
is requested via cmd line ecc=on and runs on
appropriate ARM core.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v2:
 - Show message all the time but show ECC enabled just for cases
   where IMP bit is used.

---
 arch/arm/mm/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index b1d17ee..324fc85 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -556,8 +556,8 @@ static void __init build_mem_type_table(void)
 		mem_types[MT_CACHECLEAN].prot_sect |= PMD_SECT_WB;
 		break;
 	}
-	printk("Memory policy: ECC %sabled, Data cache %s\n",
-		ecc_mask ? "en" : "dis", cp->policy);
+	pr_info("Memory policy: %sData cache %s\n",
+		ecc_mask ? "ECC enabled, " : "", cp->policy);

 	for (i = 0; i < ARRAY_SIZE(mem_types); i++) {
 		struct mem_type *t = &mem_types[i];
--
1.8.2.3


--=_mimegpg-monstr-desktop-12376-1383313360-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJzr9AACgkQykllyylKDCGkEACfeN0akS2OSeS9HpnBQBdAZWUU
bSAAn3FhHpuLCYg8oqzBhNLAHfNal4Y2
=7/QA
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-12376-1383313360-0001--
