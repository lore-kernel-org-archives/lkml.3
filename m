Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbbATWIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 17:08:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbbATWIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 17:08:00 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] livepatch: fix uninitialized return value
Date: Tue, 20 Jan 2015 16:07:55 -0600
Message-Id: <cf6bea3288dabedfc62ef602720f97e2fa1573ab.1421791634.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a potentially uninitialized return value.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 kernel/livepatch/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index bc05d39..9adf86b 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -410,7 +410,7 @@ static int klp_enable_func(struct klp_func *func)
 
 	func->state = KLP_ENABLED;
 
-	return ret;
+	return 0;
 
 err:
 	list_del_rcu(&func->stack_node);
-- 
2.1.0

