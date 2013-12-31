Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab3LaVwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 16:52:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52053 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab3LaVwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 16:52:38 -0500
Date: Tue, 31 Dec 2013 22:52:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kys@microsoft.com, haiyangz@microsoft.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Trivial cleanups for drivers/hv/connection.c
Message-ID: <20131231215236.GA18573@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__u32 is only useful for kernel-user interface, u32 should be enough
for kernel. Formatting was very confusing around __get_free_pages().

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 936093e..1387208 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -43,10 +43,10 @@ struct vmbus_connection vmbus_connection = {
 /*
  * Negotiated protocol version with the host.
  */
-__u32 vmbus_proto_version;
+u32 vmbus_proto_version;
 EXPORT_SYMBOL_GPL(vmbus_proto_version);
 
-static __u32 vmbus_get_next_version(__u32 current_version)
+static u32 vmbus_get_next_version(u32 current_version)
 {
 	switch (current_version) {
 	case (VERSION_WIN7):
@@ -62,7 +62,7 @@ static __u32 vmbus_get_next_version(__u32 current_version)
 }
 
 static int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo,
-					__u32 version)
+					u32 version)
 {
 	int ret = 0;
 	struct vmbus_channel_initiate_contact *msg;
@@ -133,7 +133,7 @@ int vmbus_connect(void)
 {
 	int ret = 0;
 	struct vmbus_channel_msginfo *msginfo = NULL;
-	__u32 version;
+	u32 version;
 
 	/* Initialize the vmbus connection */
 	vmbus_connection.conn_state = CONNECTING;
@@ -154,7 +154,7 @@ int vmbus_connect(void)
 	 * abstraction stuff
 	 */
 	vmbus_connection.int_page =
-	(void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO, 0);
+		(void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO, 0);
 	if (vmbus_connection.int_page == NULL) {
 		ret = -ENOMEM;
 		goto cleanup;
@@ -170,7 +170,7 @@ int vmbus_connect(void)
 	 * parent->child and the 2nd page for child->parent
 	 */
 	vmbus_connection.monitor_pages =
-	(void *)__get_free_pages((GFP_KERNEL|__GFP_ZERO), 1);
+		(void *)__get_free_pages((GFP_KERNEL|__GFP_ZERO), 1);
 	if (vmbus_connection.monitor_pages == NULL) {
 		ret = -ENOMEM;
 		goto cleanup;


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
