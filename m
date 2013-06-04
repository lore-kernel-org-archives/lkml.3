Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3FDPg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:36:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43715 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3FDPgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:36:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/2] ARM: ux500: Silence compiler warnings due to missing ux500_read_asicid() __init
Date: Tue,  4 Jun 2013 16:36:47 +0100
Message-Id: <1370360208-6500-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.text.unlikely+0x1e8): Section mismatch in reference from\
 the function ux500_read_asicid() to the function .init.text:iotable_init()
The function ux500_read_asicid() references
the function __init iotable_init().
This is often because ux500_read_asicid lacks a __init

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/id.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/id.c b/arch/arm/mach-ux500/id.c
index 0d33d1a..b16e7c1 100644
--- a/arch/arm/mach-ux500/id.c
+++ b/arch/arm/mach-ux500/id.c
@@ -21,7 +21,7 @@
 
 struct dbx500_asic_id dbx500_id;
 
-static unsigned int ux500_read_asicid(phys_addr_t addr)
+static unsigned int __init ux500_read_asicid(phys_addr_t addr)
 {
 	phys_addr_t base = addr & ~0xfff;
 	struct map_desc desc = {
-- 
1.7.10.4

