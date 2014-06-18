Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaFRQyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:54:43 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41717 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaFRQym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:54:42 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Date: Wed, 18 Jun 2014 18:54:24 +0200
Message-Id: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Machine name from board description is some generic name on DT kernel.
DT provides machine name property which is specific for board, so use
it instead generic one when possible.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 arch/arm/kernel/setup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 8a16ee5..fbc7b4f 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -875,10 +875,13 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_processor();
 	mdesc = setup_machine_fdt(__atags_pointer);
-	if (!mdesc)
+	if (mdesc)
+		machine_name = of_flat_dt_get_machine_name();
+	else
 		mdesc = setup_machine_tags(__atags_pointer, __machine_arch_type);
 	machine_desc = mdesc;
-	machine_name = mdesc->name;
+	if (!machine_name)
+		machine_name = mdesc->name;
 
 	if (mdesc->reboot_mode != REBOOT_HARD)
 		reboot_mode = mdesc->reboot_mode;
-- 
1.7.9.5

