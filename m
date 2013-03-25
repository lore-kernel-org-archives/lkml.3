Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab3CYELI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 00:11:08 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44180 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab3CYEKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 00:10:38 -0400
X-AuditID: 9c930197-b7c9dae000006959-77-514fce3b89ef
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [RFC PATCH 6/6] ARM, mm: enable NO_BOOTMEM for default ARM build
Date: Mon, 25 Mar 2013 13:11:14 +0900
Message-Id: <1364184674-13798-7-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364184674-13798-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364184674-13798-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we use NO_BOOTMEM, we don't need to initialize a bitmap and
we don't need to do bitmap operation, so we can boot slightly faster.

Additionaly advantage of enabling NO_BOOTMEM is saving more memory.
bootmem allocator manage memories as page unit, so if we request
4 bytes area to bootmem, it actually give us PAGE_SIZE area.
nobootmem manage memory as byte unit, so there is no waste.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 13b7394..8b73417 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -58,6 +58,7 @@ config ARM
 	select CLONE_BACKWARDS
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
+	select NO_BOOTMEM
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
-- 
1.7.9.5

