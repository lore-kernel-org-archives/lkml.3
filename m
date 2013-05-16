Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3EPUFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:05:13 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:14762 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab3EPUFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:05:10 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 May 2013 16:05:08 EDT
From: Corey Minyard <cminyard@mvista.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 1/4] drivers: char: ipmi: Replaced kmalloc and strcpy with
 kstrdup
Date: Thu, 16 May 2013 14:04:24 -0500
Message-id: <1368731067-31404-2-git-send-email-cminyard@mvista.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1368731067-31404-1-git-send-email-cminyard@mvista.com>
References: <1368731067-31404-1-git-send-email-cminyard@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>

Replaced calls to kmalloc followed by strcpy with a sincle call to kstrdup.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_msghandler.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 4d439d2..4445fa1 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -2037,12 +2037,11 @@ int ipmi_smi_add_proc_entry(ipmi_smi_t smi, char *name,
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return -ENOMEM;
-	entry->name = kmalloc(strlen(name)+1, GFP_KERNEL);
+	entry->name = kstrdup(name, GFP_KERNEL);
 	if (!entry->name) {
 		kfree(entry);
 		return -ENOMEM;
 	}
-	strcpy(entry->name, name);
 
 	file = proc_create_data(name, 0, smi->proc_dir, proc_ops, data);
 	if (!file) {
-- 
1.7.9.5

