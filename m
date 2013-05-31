Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3EaPJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:09:23 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:63342 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3EaPJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:09:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] ARM: ux500: Enable HIGHMEM in the u8540 defconfig
Date: Fri, 31 May 2013 16:09:06 +0100
Message-Id: <1370012946-7374-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to utilise all of the memory located on ux500 based devices
we have to enable HIGHMEM. Without it the kernel truncates memory down
to what's left after the PAGE_OFFSET has been applied, which doesn't
leave an awful lot, especially if we're running large rootfs' such
as full Linux desktop distributions or Android.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/configs/u8500_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index 2d322d2..38d633a 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -1,3 +1,4 @@
+CONFIG_HIGHMEM=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_NO_HZ=y
-- 
1.7.10.4

