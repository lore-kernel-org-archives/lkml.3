Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab3KSLMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:12:46 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:46703 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3KSLMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:12:43 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 2/9] arc: Use NULL as the default DTB
Date: Tue, 19 Nov 2013 12:12:27 +0100
Message-Id: <1384859554-27268-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384859554-27268-1-git-send-email-geert@linux-m68k.org>
References: <5283A000.8090007@gmail.com>
 <1384859554-27268-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_init_dt_scan() now takes care of falling back to the built-in DTB.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index ef705d0f50f5..481e11240e12 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -314,7 +314,7 @@ void setup_processor(void)
 void __init setup_arch(char **cmdline_p)
 {
 	/* This also populates @boot_command_line from /bootargs */
-	machine_desc = setup_machine_fdt(&__dtb_start);
+	machine_desc = setup_machine_fdt(NULL);
 	if (!machine_desc)
 		panic("Embedded DT invalid\n");
 
-- 
1.7.9.5

