Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab3LERgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:36:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38068 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158Ab3LERga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:36:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 07/90] ARM: sa11x0/assabet: ensure CS2 is configured appropriately
Date: Thu,  5 Dec 2013 17:34:49 +0000
Message-Id: <1386264972-5399-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit f3964fe1c9d9a887d65faf594669852e4dec46e0 upstream.

The CS2 region contains the Assabet board configuration and status
registers, which are 32-bit.  Unfortunately, some boot loaders do not
configure this region correctly, leaving it setup as a 16-bit region.
Fix this.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-sa1100/assabet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-sa1100/assabet.c b/arch/arm/mach-sa1100/assabet.c
index d1dc7f1..3417058 100644
--- a/arch/arm/mach-sa1100/assabet.c
+++ b/arch/arm/mach-sa1100/assabet.c
@@ -509,6 +509,9 @@ static void __init assabet_map_io(void)
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

