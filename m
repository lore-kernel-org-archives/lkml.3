Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab3FXGXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 02:23:17 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:57813 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3FXGXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 02:23:15 -0400
Subject: [PATCH 1/3] Retreive header size from pstore
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Mon, 24 Jun 2013 11:52:56 +0530
Message-ID: <20130624062255.12963.71137.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130624061936.12963.72529.stgit@aruna-ThinkPad-T420>
References: <20130624061936.12963.72529.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062406-5140-0000-0000-0000036B9066
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pstore_get_header_size will return the size of the header added by pstore
while logging messages to the registered buffer.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 fs/pstore/platform.c   |    7 ++++++-
 include/linux/pstore.h |    6 ++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 86d1038..e8260ea 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -49,6 +49,7 @@ MODULE_PARM_DESC(update_ms, "milliseconds before pstore updates its content "
 		 "corruption on Oopses)");
 
 static int pstore_new_entry;
+static int hsize;
 
 static void pstore_timefunc(unsigned long);
 static DEFINE_TIMER(pstore_timer, pstore_timefunc, 0, 0);
@@ -68,6 +69,11 @@ static char *backend;
 /* How much of the console log to snapshot */
 static unsigned long kmsg_bytes = 10240;
 
+int pstore_get_header_size(void)
+{
+	return hsize;
+}
+
 void pstore_set_kmsg_bytes(int bytes)
 {
 	kmsg_bytes = bytes;
@@ -147,7 +153,6 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	while (total < kmsg_bytes) {
 		char *dst;
 		unsigned long size;
-		int hsize;
 		size_t len;
 
 		dst = psinfo->buf;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 656699f..f43b64f 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -73,6 +73,7 @@ struct pstore_info {
 #ifdef CONFIG_PSTORE
 extern int pstore_register(struct pstore_info *);
 extern bool pstore_cannot_block_path(enum kmsg_dump_reason reason);
+extern int pstore_get_header_size(void);
 #else
 static inline int
 pstore_register(struct pstore_info *psi)
@@ -84,6 +85,11 @@ pstore_cannot_block_path(enum kmsg_dump_reason reason)
 {
 	return false;
 }
+static inline int
+pstore_get_header_size(void)
+{
+	return 0;
+}
 #endif
 
 #endif /*_LINUX_PSTORE_H*/

