Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3KHAxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:53:32 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:61716 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab3KHAx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:53:29 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 1/3] panic: setup panic_timeout early
Date: Thu,  7 Nov 2013 18:46:38 -0600
Message-Id: <1383871600-3831-2-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.2+fc1
In-Reply-To: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
References: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we might not reboot when the user needs it the most (early
on).

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 kernel/panic.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index b6c482c..46e37ff 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -468,9 +468,21 @@ EXPORT_SYMBOL(__stack_chk_fail);
 
 #endif
 
-core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
 
+static int __init set_panic_timeout(char *str)
+{
+	int timeout;
+
+	if (!get_option(&str, &timeout))
+		return -EINVAL;
+
+	panic_timeout = timeout;
+	return 0;
+}
+
+early_param("panic_timeout", set_panic_timeout);
+
 static int __init oops_setup(char *s)
 {
 	if (!s)
-- 
1.8.4.2+fc1

