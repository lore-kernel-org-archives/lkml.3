Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaFEEUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:20:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaFEEUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Shilovsky <pshilovsky@etersoft.ru>,
        Steve French <smfrench@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 076/214] CIFS: Fix error handling in cifs_push_mandatory_locks
Date: Wed,  4 Jun 2014 21:17:19 -0700
Message-Id: <20140605041649.768797657@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@etersoft.ru>

commit e2f2886a824ff0a56da1eaa13019fde86aa89fa6 upstream.

Signed-off-by: Pavel Shilovsky <pshilovsky@etersoft.ru>
Signed-off-by: Steve French <smfrench@gmail.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -882,7 +882,7 @@ cifs_push_mandatory_locks(struct cifsFil
 	if (!buf) {
 		mutex_unlock(&cinode->lock_mutex);
 		FreeXid(xid);
-		return rc;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < 2; i++) {


