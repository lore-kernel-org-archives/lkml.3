Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3KSLNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:13:36 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:42773 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab3KSLMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:12:45 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH 9/9] xtensa: Use NULL as the default DTB
Date: Tue, 19 Nov 2013 12:12:34 +0100
Message-Id: <1384859554-27268-9-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384859554-27268-1-git-send-email-geert@linux-m68k.org>
References: <5283A000.8090007@gmail.com>
 <1384859554-27268-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_init_dt_scan() now takes care of falling back to the built-in DTB.
Also make dtb_start static while we're at it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org
---
 arch/xtensa/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index d96cf8f3fe70..dd440deb137d 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -68,7 +68,7 @@ extern int initrd_below_start_ok;
 #endif
 
 #ifdef CONFIG_OF
-void *dtb_start = &__dtb_start;
+static void *dtb_start;
 #endif
 
 unsigned char aux_device_present;
-- 
1.7.9.5

