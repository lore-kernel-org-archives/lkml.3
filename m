Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3EPQSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:18:01 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58816 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752812Ab3EPQPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:15:02 -0400
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Russ Anderson <rja@sgi.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -v11 resend 03/11] Remove -stable friendly PF_THREAD_BOUND define
Date: Thu, 16 May 2013 11:14:42 -0500
Message-Id: <1368720890-57711-4-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368720890-57711-1-git-send-email-holt@sgi.com>
References: <1368720890-57711-1-git-send-email-holt@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the prior patch's #define for easier backporting to the stable
releases.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>
---
 kernel/sys.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 2bbd9a7..17bb8d3 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -362,11 +362,6 @@ int unregister_reboot_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
-/* Add backwards compatibility for stable trees. */
-#ifndef PF_NO_SETAFFINITY
-#define PF_NO_SETAFFINITY		PF_THREAD_BOUND
-#endif
-
 static void migrate_to_reboot_cpu(void)
 {
 	/* The boot cpu is always logical cpu 0 */
-- 
1.8.2.1

