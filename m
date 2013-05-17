Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab3EQLTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:19:36 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:48874 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab3EQLTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:19:08 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/3] h8300: Mark H83002 and H83048 CPU support broken
Date: Fri, 17 May 2013 13:19:01 +0200
Message-Id: <1368789541-3869-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368789541-3869-1-git-send-email-geert@linux-m68k.org>
References: <1368789541-3869-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/h8300/include/asm/io.h supports only H83007 (H8/3006,3007), H83068
(H8/3065,3066,3067,3068,3069), and H8S2678 (H8S/2670,2673,2674R,2675,2676)
CPU types.

Hence disable H83002 (H8/3001,3002,3003) and H83048
(H8/3044,3045,3046,3047,3048,3052) CPU support at the Kconfig level.

This fixes build failures in allmodconfig/allyesconfig builds, as these
always choose the first CPU type (H83002), which was unsupported:

arch/h8300/include/asm/io.h:13:2: error: #error UNKNOWN CPU TYPE

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/h8300/Kconfig.cpu |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/h8300/Kconfig.cpu b/arch/h8300/Kconfig.cpu
index c8ea74a..cdee771 100644
--- a/arch/h8300/Kconfig.cpu
+++ b/arch/h8300/Kconfig.cpu
@@ -64,6 +64,7 @@ choice
 
 config H83002
 	bool "H8/3001,3002,3003"
+	depends on BROKEN
 	select CPU_H8300H
 
 config H83007
@@ -72,6 +73,7 @@ config H83007
 
 config H83048
 	bool "H8/3044,3045,3046,3047,3048,3052"
+	depends on BROKEN
 	select CPU_H8300H
 
 config H83068
-- 
1.7.0.4

