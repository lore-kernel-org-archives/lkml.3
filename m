Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab3K0GZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:25:26 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:58970 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab3K0GZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:25:17 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>, Jason Baron <jbaron@akamai.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v4 2/2] panic: setup panic_on_oops early
Date: Wed, 27 Nov 2013 00:17:50 -0600
Message-Id: <1385533070-7604-3-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.2+fc1
In-Reply-To: <1385533070-7604-1-git-send-email-felipe.contreras@gmail.com>
References: <1385533070-7604-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For consistency.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 kernel/panic.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 3456652..2256838 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -468,7 +468,11 @@ EXPORT_SYMBOL(__stack_chk_fail);
 
 #endif
 
-core_param(pause_on_oops, pause_on_oops, int, 0644);
+static int __init set_panic_on_oops(char *val)
+{
+	return kstrtoint(val, 0, &panic_on_oops);
+}
+early_param("panic_on_oops", set_panic_on_oops);
 
 static int __init set_panic_timeout(char *val)
 {
-- 
1.8.4.2+fc1

