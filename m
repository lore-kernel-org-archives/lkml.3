Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3LSPE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:04:28 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:54486 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab3LSPEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:04:22 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 09/38] arm: mach-imx: add missing put_device calls
Date: Thu, 19 Dec 2013 16:03:20 +0100
Message-Id: <1387465429-3568-10-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 arch/arm/mach-imx/devices/devices.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/devices/devices.c b/arch/arm/mach-imx/devices/devices.c
index 1b4366a..0b17c89 100644
--- a/arch/arm/mach-imx/devices/devices.c
+++ b/arch/arm/mach-imx/devices/devices.c
@@ -37,11 +37,14 @@ int __init mxc_device_init(void)
 	int ret;
 
 	ret = device_register(&mxc_aips_bus);
-	if (ret < 0)
+	if (ret < 0) {
+		put_device(&mxc_aips_bus);
 		goto done;
+	}
 
 	ret = device_register(&mxc_ahb_bus);
-
+	if(ret < 0)
+		put_device(&mxc_ahb_bus);
 done:
 	return ret;
 }
-- 
1.8.3.1

