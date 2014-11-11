Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbaKKLRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:17:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57894 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbaKKLLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andriy Skulysh <askulysh@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 155/170] sh: fix sh770x SCIF memory regions
Date: Tue, 11 Nov 2014 11:08:34 +0000
Message-Id: <1415704129-12709-156-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andriy Skulysh <askulysh@gmail.com>

commit 5417421b270229bfce0795ccc99a4b481e4954ca upstream.

Resources scif1_resources & scif2_resources overlap.  Actual SCIF region
size is 0x10.

This is regression from commit d850acf975be ("sh: Declare SCIF register
base and IRQ as resources")

Signed-off-by: Andriy Skulysh <askulysh@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sh/kernel/cpu/sh3/setup-sh770x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sh/kernel/cpu/sh3/setup-sh770x.c b/arch/sh/kernel/cpu/sh3/setup-sh770x.c
index 9139d14b9c53..538c10db3537 100644
--- a/arch/sh/kernel/cpu/sh3/setup-sh770x.c
+++ b/arch/sh/kernel/cpu/sh3/setup-sh770x.c
@@ -118,7 +118,7 @@ static struct plat_sci_port scif0_platform_data = {
 };
 
 static struct resource scif0_resources[] = {
-	DEFINE_RES_MEM(0xfffffe80, 0x100),
+	DEFINE_RES_MEM(0xfffffe80, 0x10),
 	DEFINE_RES_IRQ(evt2irq(0x4e0)),
 };
 
@@ -143,7 +143,7 @@ static struct plat_sci_port scif1_platform_data = {
 };
 
 static struct resource scif1_resources[] = {
-	DEFINE_RES_MEM(0xa4000150, 0x100),
+	DEFINE_RES_MEM(0xa4000150, 0x10),
 	DEFINE_RES_IRQ(evt2irq(0x900)),
 };
 
@@ -169,7 +169,7 @@ static struct plat_sci_port scif2_platform_data = {
 };
 
 static struct resource scif2_resources[] = {
-	DEFINE_RES_MEM(0xa4000140, 0x100),
+	DEFINE_RES_MEM(0xa4000140, 0x10),
 	DEFINE_RES_IRQ(evt2irq(0x880)),
 };
 
-- 
2.1.0

