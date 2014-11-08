Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaKHXC2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 18:02:28 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:37587 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbaKHXBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 18:01:54 -0500
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: nefelim4ag@gmail.com, marco.antonio.780@gmail.com
Subject: [PATCH v2 3/3] KSM: Add config to control mark_new_vma
Date: Sun,  9 Nov 2014 02:01:43 +0300
Message-Id: <1415487703-1824-4-git-send-email-nefelim4ag@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415487703-1824-1-git-send-email-nefelim4ag@gmail.com>
References: <1415487703-1824-1-git-send-email-nefelim4ag@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allowing to control mark_new_vma default value
Allowing work ksm on early allocated vmas

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 mm/Kconfig | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index 1d1ae6b..90f40a6 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -340,6 +340,13 @@ config KSM
 	  until a program has madvised that an area is MADV_MERGEABLE, and
 	  root has set /sys/kernel/mm/ksm/run to 1 (if CONFIG_SYSFS is set).
 
+config KSM_MARK_NEW_VMA
+	int "Marking new vma pages as VM_MERGEABLE"
+	depends on KSM
+	default 0
+	range 0 1
+	help
+
 config DEFAULT_MMAP_MIN_ADDR
         int "Low address space to protect from user allocation"
 	depends on MMU
-- 
2.1.3

