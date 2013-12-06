Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121Ab3LFX0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:26:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49006 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759152Ab3LFXUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:47 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 030/152] ARM: sa11x0/assabet: ensure CS2 is configured appropriately
Date: Fri,  6 Dec 2013 15:09:14 -0800
Message-Id: <1386371476-2477-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit f3964fe1c9d9a887d65faf594669852e4dec46e0 upstream.

The CS2 region contains the Assabet board configuration and status
registers, which are 32-bit.  Unfortunately, some boot loaders do not
configure this region correctly, leaving it setup as a 16-bit region.
Fix this.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-sa1100/assabet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-sa1100/assabet.c b/arch/arm/mach-sa1100/assabet.c
index 9a23739..45628dd 100644
--- a/arch/arm/mach-sa1100/assabet.c
+++ b/arch/arm/mach-sa1100/assabet.c
@@ -511,6 +511,9 @@ static void __init assabet_map_io(void)
 	 * Its called GPCLKR0 in my SA1110 manual.
 	 */
 	Ser1SDCR0 |= SDCR0_SUS;
+	MSC1 = (MSC1 & ~0xffff) |
+		MSC_NonBrst | MSC_32BitStMem |
+		MSC_RdAcc(2) | MSC_WrAcc(2) | MSC_Rec(0);
 
 	if (!machine_has_neponset())
 		sa1100_register_uart_fns(&assabet_port_fns);
-- 
1.8.3.2

