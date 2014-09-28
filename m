Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaI1Cu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 22:50:58 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:57383 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaI1Cu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 22:50:57 -0400
From: Nicholas Krause <yocto6@gmail.com>
To: linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm: Remove read of issue in sa1111.c in sa1111_resume
Date: Sat, 27 Sep 2014 22:50:52 -0400
Message-Id: <1411872652-16207-1-git-send-email-yocto6@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the FIXME message and issue with reading in this driver before resuming
in the function, sa1111_resume.

Signed-off-by: Nicholas Krause <yocto6@gmail.com>
---
 arch/arm/common/sa1111.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index e57d7e5..0c4b9a9 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -950,9 +950,7 @@ static int sa1111_resume(struct platform_device *dev)
 
 	/*
 	 * Ensure that the SA1111 is still here.
-	 * FIXME: shouldn't do this here.
 	 */
-	id = sa1111_readl(sachip->base + SA1111_SKID);
 	if ((id & SKID_ID_MASK) != SKID_SA1111_ID) {
 		__sa1111_remove(sachip);
 		platform_set_drvdata(dev, NULL);
-- 
1.9.1

