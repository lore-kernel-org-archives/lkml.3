Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab3KPIPg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 03:15:36 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:56282 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3KPIP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 03:15:29 -0500
Message-ID: <1384589723.7840.1.camel@phoenix>
Subject: [PATCH] devtmpfs: Calling delete_path() only when necessary
From: Axel Lin <axel.lin@ingics.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Date: Sat, 16 Nov 2013 16:15:23 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The deleted variable is always 1 in current code.
Initialize deleted variable to be 0, so delete_path() will be called only when
necessary.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/base/devtmpfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 0f38201..25798db 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -299,7 +299,7 @@ static int handle_remove(const char *nodename, struct device *dev)
 {
 	struct path parent;
 	struct dentry *dentry;
-	int deleted = 1;
+	int deleted = 0;
 	int err;
 
 	dentry = kern_path_locked(nodename, &parent);
-- 
1.8.1.2



