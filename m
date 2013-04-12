Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3DLMCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 08:02:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43489 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3DLMCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 08:02:13 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH] base/core.c: improve comment of the function device_find_child()
Date: Fri, 12 Apr 2013 13:59:32 +0200
Message-Id: <1365767972-23727-1-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
---
 drivers/base/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 016312437..eb0c6ea 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1372,6 +1372,10 @@ int device_for_each_child(struct device *parent, void *data,
  * if it does.  If the callback returns non-zero and a reference to the
  * current device can be obtained, this function will return to the caller
  * and not iterate over any more devices.
+ *
+ * NOTE: internally, the function does get_device() on the retrieved child.
+ * It is duty of the caller performing a put_device() on the retrieved
+ * child device when the caller finishes to work on it.
  */
 struct device *device_find_child(struct device *parent, void *data,
 				 int (*match)(struct device *dev, void *data))
-- 
1.8.1.4

