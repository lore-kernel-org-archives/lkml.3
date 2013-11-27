Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab3K0GZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:25:20 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:37529 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab3K0GZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:25:14 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>, Jason Baron <jbaron@akamai.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v4 1/2] panic: setup panic_timeout early
Date: Wed, 27 Nov 2013 00:17:49 -0600
Message-Id: <1385533070-7604-2-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.2+fc1
In-Reply-To: <1385533070-7604-1-git-send-email-felipe.contreras@gmail.com>
References: <1385533070-7604-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we might not reboot when the user needs it the most (early
on).

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 kernel/panic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index b6c482c..3456652 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -468,9 +468,14 @@ EXPORT_SYMBOL(__stack_chk_fail);
 
 #endif
 
-core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
 
+static int __init set_panic_timeout(char *val)
+{
+	return kstrtoint(val, 0, &panic_timeout);
+}
+early_param("panic_timeout", set_panic_timeout);
+
 static int __init oops_setup(char *s)
 {
 	if (!s)
-- 
1.8.4.2+fc1

