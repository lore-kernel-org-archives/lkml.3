Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaBGEfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 23:35:55 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6652 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaBGEfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 23:35:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 06 Feb 2014 20:34:17 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>
CC: Olof Johansson <olof@lixom.net>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2 4/6] ARM: firmware: add prepare_idle() operation
Date: Fri, 7 Feb 2014 13:35:04 +0900
Message-ID: <1391747706-1847-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391747706-1847-1-git-send-email-acourbot@nvidia.com>
References: <1391747706-1847-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some firmwares do not put the CPU into idle mode themselves, but still
need to be informed that the CPU is about to enter idle mode before this
happens. Add a prepare_idle() operation to the firmware_ops structure to
handle such cases.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/include/asm/firmware.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/include/asm/firmware.h b/arch/arm/include/asm/firmware.h
index 15631300c238..2c9f10df7568 100644
--- a/arch/arm/include/asm/firmware.h
+++ b/arch/arm/include/asm/firmware.h
@@ -22,6 +22,10 @@
  */
 struct firmware_ops {
 	/*
+	 * Inform the firmware we intend to enter CPU idle mode
+	 */
+	int (*prepare_idle)(void);
+	/*
 	 * Enters CPU idle mode
 	 */
 	int (*do_idle)(void);
-- 
1.8.5.3

