Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab3A1QnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:43:00 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34030 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab3A1Qmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:42:51 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 01/15] Secure boot: Add new capability
Date: Mon, 28 Jan 2013 11:42:25 -0500
Message-Id: <1359391359-25783-2-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Secure boot adds certain policy requirements, including that root must not
be able to do anything that could cause the kernel to execute arbitrary code.
The simplest way to handle this would seem to be to add a new capability
and gate various functionality on that. We'll then strip it from the initial
capability set if required.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 include/uapi/linux/capability.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index ba478fa..7109e650 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -343,7 +343,11 @@ struct vfs_cap_data {
 
 #define CAP_BLOCK_SUSPEND    36
 
-#define CAP_LAST_CAP         CAP_BLOCK_SUSPEND
+/* Allow things that trivially permit root to modify the running kernel */
+
+#define CAP_COMPROMISE_KERNEL  37
+
+#define CAP_LAST_CAP         CAP_COMPROMISE_KERNEL
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
-- 
1.8.0.2

