Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab3KLTXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:23:14 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:56212 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab3KLTXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:23:12 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] microblaze: Wire up defconfig to mmu_defconfig
Date: Tue, 12 Nov 2013 20:22:44 +0100
Message-Id: <1384284164-12777-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this, "make defconfig" fails with

*** Can't find default configuration "arch/microblaze/defconfig"!

All other architectures either set KBUILD_DEFCONFIG, or provide
arch/*/defconfig.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/microblaze/Makefile |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
index 40350a3c24e9..a69eaf2ab130 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -1,3 +1,5 @@
+KBUILD_DEFCONFIG := mmu_defconfig
+
 ifeq ($(CONFIG_MMU),y)
 UTS_SYSNAME = -DUTS_SYSNAME=\"Linux\"
 else
-- 
1.7.9.5

