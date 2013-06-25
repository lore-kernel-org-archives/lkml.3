Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3FYRmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:42:00 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53619 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3FYRl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:41:57 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, nico@linaro.org,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 1/2] Documentation: arm: early_ioremap
Date: Tue, 25 Jun 2013 18:46:40 +0100
Message-Id: <1372182401-11029-2-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372182401-11029-1-git-send-email-leif.lindholm@linaro.org>
References: <1372182401-11029-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides documentation of the early_ioremap() functionality,
including its implementation and usage instructions.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 Documentation/arm/00-INDEX          |    2 ++
 Documentation/arm/early_ioremap.txt |   12 ++++++++++++
 2 files changed, 14 insertions(+)
 create mode 100644 Documentation/arm/early_ioremap.txt

diff --git a/Documentation/arm/00-INDEX b/Documentation/arm/00-INDEX
index 36420e1..4978456 100644
--- a/Documentation/arm/00-INDEX
+++ b/Documentation/arm/00-INDEX
@@ -24,6 +24,8 @@ SPEAr
 	- ST SPEAr platform Linux Overview
 VFP/
 	- Release notes for Linux Kernel Vector Floating Point support code
+early_ioremap.txt
+	- documentation of the early_ioremap() functionality
 empeg/
 	- Ltd's Empeg MP3 Car Audio Player
 mem_alignment
diff --git a/Documentation/arm/early_ioremap.txt b/Documentation/arm/early_ioremap.txt
new file mode 100644
index 0000000..178f791
--- /dev/null
+++ b/Documentation/arm/early_ioremap.txt
@@ -0,0 +1,12 @@
+early_ioremap() and early_iounmap() rovide a mechanism for temporarily mapping
+in small blocks of memory, identified by their physical address, into the
+fixmap virtual address block before paging_init() has been called and more
+flexible mapping functions are available.
+
+Due to its direct method, it also gets around potential need for special
+handling of regions that end up in highmem.
+
+It supports up to 7 simultaneously mapped regions of up to 128KB each.
+All regions are mapped as non-shareable device memory.
+
+Specify 'early_ioremap_debug' on the kernel commandline for verbose output.
-- 
1.7.10.4

