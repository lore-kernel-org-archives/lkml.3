Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab3FZBad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:30:33 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:49260 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3FZBab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:30:31 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] ARM: ux500: check platform in ux500_l2x0_init
Date: Tue, 25 Jun 2013 18:30:31 -0700
Message-Id: <1372210231-22900-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add compatible checks for ux500. This should probably be moved to generic
DT-based probing whenever DT is populated instead, but until then at
least don't panic all non-ux500 multiplatform machines.

Signed-off-by: Olof Johansson <olof@lixom.net>
---

Linus, I'll apply this directly if you ack it, let me know.


-Olof

 arch/arm/mach-ux500/cache-l2x0.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/mach-ux500/cache-l2x0.c b/arch/arm/mach-ux500/cache-l2x0.c
index f58615b..3facc1e 100644
--- a/arch/arm/mach-ux500/cache-l2x0.c
+++ b/arch/arm/mach-ux500/cache-l2x0.c
@@ -39,6 +39,15 @@ static int __init ux500_l2x0_init(void)
 {
 	u32 aux_val = 0x3e000000;
 
+	/* Ick. I wish there was a single compatible value to compare for,
+	 * but there isn't.
+	 */
+	if (!of_machine_is_compatible("st-ericsson,u8500") &&
+	    !of_machine_is_compatible("st-ericsson,u8540") &&
+	    !of_machine_is_compatible("st-ericsson,u9500") &&
+	    !of_machine_is_compatible("st-ericsson,u8540"))
+		return -ENODEV;
+
 	if (cpu_is_u8500_family() || cpu_is_ux540_family())
 		l2x0_base = __io_address(U8500_L2CC_BASE);
 	else
-- 
1.8.1.192.gc4361b8

