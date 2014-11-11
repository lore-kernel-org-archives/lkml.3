Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaKKMHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:07:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57217 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbaKKLJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vineet Gupta <vgupta@synopsys.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 027/170] ARC: [nsimosci] Allow "headless" models to boot
Date: Tue, 11 Nov 2014 11:06:26 +0000
Message-Id: <1415704129-12709-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@synopsys.com>

commit 5c05483e2db91890faa9a7be0a831701a3f442d6 upstream.

There are certain test configuration of virtual platform which don't
have any real console device (uart/pgu). So add tty0 as a fallback console
device to allow system to boot and be accessible via telnet

Otherwise with ttyS0 as only console, but 8250 disabled in kernel build,
init chokes.

Reported-by: Anton Kolesov <akolesov@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arc/boot/dts/nsimosci.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arc/boot/dts/nsimosci.dts b/arch/arc/boot/dts/nsimosci.dts
index 4f31b2eb5cdf..398064cef746 100644
--- a/arch/arc/boot/dts/nsimosci.dts
+++ b/arch/arc/boot/dts/nsimosci.dts
@@ -20,7 +20,7 @@
 		/* this is for console on PGU */
 		/* bootargs = "console=tty0 consoleblank=0"; */
 		/* this is for console on serial */
-		bootargs = "earlycon=uart8250,mmio32,0xc0000000,115200n8 console=ttyS0,115200n8 consoleblank=0 debug";
+		bootargs = "earlycon=uart8250,mmio32,0xc0000000,115200n8 console=tty0 console=ttyS0,115200n8 consoleblank=0 debug";
 	};
 
 	aliases {
-- 
2.1.0

