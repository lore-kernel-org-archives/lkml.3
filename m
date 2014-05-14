Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbaENQu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:50:29 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:59789 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753279AbaENQu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:50:27 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuUNAE6ec1NXQ68k/2dsb2JhbABZgwasaQQBAQEBAQEFAZodgSMXdIJTExwjGIECJBOIRQHRMoVUiHqERwEDjyqKJgGLDYgHgzg7
Date: Wed, 14 May 2014 18:50:25 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christine Caulfield <ccaulfie@redhat.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/dlm/lockspace.c: convert simple_str to kstr
Message-Id: <20140514185025.3af4646f295377857fe0d1c4@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace obsolete functions.

Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/dlm/lockspace.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 04d6398..f3e7278 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -35,8 +35,11 @@ static struct task_struct *	scand_task;
 static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
 	ssize_t ret = len;
-	int n = simple_strtol(buf, NULL, 0);
+	int n;
+	int rc = kstrtoint(buf, 0, &n);
 
+	if (rc)
+		return rc;
 	ls = dlm_find_lockspace_local(ls->ls_local_handle);
 	if (!ls)
 		return -EINVAL;
@@ -57,7 +60,10 @@ static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
 
 static ssize_t dlm_event_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
-	ls->ls_uevent_result = simple_strtol(buf, NULL, 0);
+	int rc = kstrtoint(buf, 0, &ls->ls_uevent_result);
+
+	if (rc)
+		return rc;
 	set_bit(LSFL_UEVENT_WAIT, &ls->ls_flags);
 	wake_up(&ls->ls_uevent_wait);
 	return len;
@@ -70,7 +76,10 @@ static ssize_t dlm_id_show(struct dlm_ls *ls, char *buf)
 
 static ssize_t dlm_id_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
-	ls->ls_global_id = simple_strtoul(buf, NULL, 0);
+	int rc = kstrtouint(buf, 0, &ls->ls_global_id);
+
+	if (rc)
+		return rc;
 	return len;
 }
 
@@ -81,7 +90,11 @@ static ssize_t dlm_nodir_show(struct dlm_ls *ls, char *buf)
 
 static ssize_t dlm_nodir_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
-	int val = simple_strtoul(buf, NULL, 0);
+	int val;
+	int rc = kstrtoint(buf, 0, &val);
+
+	if (rc)
+		return rc;
 	if (val == 1)
 		set_bit(LSFL_NODIR, &ls->ls_flags);
 	return len;
-- 
1.9.1
