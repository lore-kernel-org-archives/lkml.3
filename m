Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaFYLJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:09:43 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41113 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756212AbaFYLHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:07:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH -repost 17/21] kgr: exercise non-present function
Date: Wed, 25 Jun 2014 13:07:11 +0200
Message-Id: <1403694435-3180-17-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to test the newly added functionality: non-fatal patching of
yet unknown functions.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 samples/kgraft/kgraft_patcher.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/samples/kgraft/kgraft_patcher.c b/samples/kgraft/kgraft_patcher.c
index 5d02a908bc26..e96eef840397 100644
--- a/samples/kgraft/kgraft_patcher.c
+++ b/samples/kgraft/kgraft_patcher.c
@@ -63,10 +63,17 @@ static bool new_capable(int cap)
 }
 KGR_PATCHED_FUNCTION(capable, new_capable, true);
 
+static void new_function(unsigned long data)
+{
+	pr_info("kgr-patcher: %s\n", __func__);
+}
+KGR_PATCHED_FUNCTION(unknown_function, new_function, false);
+
 static struct kgr_patch patch = {
 	.patches = {
 		KGR_PATCH(SyS_iopl),
 		KGR_PATCH(capable),
+		KGR_PATCH(unknown_function),
 		KGR_PATCH_END
 	}
 };
-- 
2.0.0

