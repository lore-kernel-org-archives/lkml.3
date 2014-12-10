Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbaLJSce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:32:34 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:44352
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932479AbaLJScd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:32:33 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, mcb30@ipxe.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in vmbus_establish_gpadl()
Date: Wed, 10 Dec 2014 11:42:43 -0800
Message-Id: <1418240563-6590-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug in vmbus_establish_gpadl(). I would like to
thank Michael Brown <mcb30@ipxe.org> for seeing this bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/channel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 433f72a..c76ffbe 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -366,8 +366,8 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	unsigned long flags;
 	int ret = 0;
 
-	next_gpadl_handle = atomic_read(&vmbus_connection.next_gpadl_handle);
-	atomic_inc(&vmbus_connection.next_gpadl_handle);
+	next_gpadl_handle =
+		(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
 
 	ret = create_gpadl_header(kbuffer, size, &msginfo, &msgcount);
 	if (ret)
-- 
1.7.4.1

