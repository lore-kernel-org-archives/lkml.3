Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaJUOxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:53:43 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:49651 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbaJUOxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:53:41 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Sekhar Nori <nsekhar@ti.com>, Russell King <linux@arm.linux.org.uk>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] ARM: davinci: Remove redundant casts
Date: Tue, 21 Oct 2014 16:53:31 +0200
Message-Id: <1413903211-3143-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These casts to char* are unnecessary and slightly confusing, since
both operands actually have type const char*.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 arch/arm/mach-davinci/board-da850-evm.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index fa11415..6b5a97d 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -452,8 +452,7 @@ static void da850_evm_ui_keys_init(unsigned gpio)
 	for (i = 0; i < DA850_N_UI_PB; i++) {
 		button = &da850_evm_ui_keys[i];
 		button->code = KEY_F8 - i;
-		button->desc = (char *)
-				da850_evm_ui_exp[DA850_EVM_UI_EXP_PB8 + i];
+		button->desc = da850_evm_ui_exp[DA850_EVM_UI_EXP_PB8 + i];
 		button->gpio = gpio + DA850_EVM_UI_EXP_PB8 + i;
 	}
 }
@@ -628,15 +627,13 @@ static void da850_evm_bb_keys_init(unsigned gpio)
 	struct gpio_keys_button *button;
 
 	button = &da850_evm_bb_keys[0];
-	button->desc = (char *)
-		da850_evm_bb_exp[DA850_EVM_BB_EXP_USER_PB1];
+	button->desc = da850_evm_bb_exp[DA850_EVM_BB_EXP_USER_PB1];
 	button->gpio = gpio + DA850_EVM_BB_EXP_USER_PB1;
 
 	for (i = 0; i < DA850_N_BB_USER_SW; i++) {
 		button = &da850_evm_bb_keys[i + 1];
 		button->code = SW_LID + i;
-		button->desc = (char *)
-				da850_evm_bb_exp[DA850_EVM_BB_EXP_USER_SW1 + i];
+		button->desc = da850_evm_bb_exp[DA850_EVM_BB_EXP_USER_SW1 + i];
 		button->gpio = gpio + DA850_EVM_BB_EXP_USER_SW1 + i;
 	}
 }
-- 
2.0.4

