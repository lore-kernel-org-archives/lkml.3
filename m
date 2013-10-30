Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3J3Mqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 08:46:34 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:41582 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab3J3Mqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 08:46:33 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org,
        monstr@monstr.eu, Nicolas Pitre <nico@linaro.org>,
        Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: mm: Fix ECC mem policy printk
Date: Wed, 30 Oct 2013 13:46:18 +0100
Message-Id: <8986e8f1a3761e45a7927bdb0e54393c9155e6bf.1383137171.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-26653-1383137179-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-26653-1383137179-0001

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
Russell, Will: We discussed this at KS that will be good
to rephrase it or have different logic around this.
I am not sure if we can also test that this bit is
implemented by particular SoC or not.

Maybe logic should be that if SoC uses this bit
that message is shown in origin format to declare
that ECC is enabled or disabled.
When SoC doesn't implement it then do not show this message.

---
 arch/arm/mm/mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index b1d17ee..1b88ce3 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -556,8 +556,9 @@ static void __init build_mem_type_table(void)
 		mem_types[MT_CACHECLEAN].prot_sect |= PMD_SECT_WB;
 		break;
 	}
-	printk("Memory policy: ECC %sabled, Data cache %s\n",
-		ecc_mask ? "en" : "dis", cp->policy);
+	if (ecc_mask)
+		pr_info("Memory policy: ECC enabled, Data cache %s\n",
+			cp->policy);

 	for (i = 0; i < ARRAY_SIZE(mem_types); i++) {
 		struct mem_type *t = &mem_types[i];
--
1.8.2.3


--=_mimegpg-monstr-desktop-26653-1383137179-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJw/5sACgkQykllyylKDCH83wCgkVHiPc+UPdIavStsBw/uvH+S
yCgAoI833Cxbi5qF2tv82LkcOslFfImQ
=9zOk
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-26653-1383137179-0001--
