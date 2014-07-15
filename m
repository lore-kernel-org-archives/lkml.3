Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934137AbaGOVlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:41:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55169 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934103AbaGOVjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:39:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 071/198] hv: use correct order when freeing monitor_pages
Date: Tue, 15 Jul 2014 14:29:01 -0700
Message-Id: <1405459868-15089-72-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>

commit a100d88df1e924e5c9678fabf054d1bae7ab74fb upstream.

We try to free two pages when only one has been allocated.
Cleanup path is unlikely, so I haven't found any trace that would fit,
but I hope that free_pages_prepare() does catch it.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Reviewed-by: Amos Kong <akong@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hv/connection.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 2e7801a..05827ec 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -224,8 +224,8 @@ cleanup:
 		vmbus_connection.int_page = NULL;
 	}
 
-	free_pages((unsigned long)vmbus_connection.monitor_pages[0], 1);
-	free_pages((unsigned long)vmbus_connection.monitor_pages[1], 1);
+	free_pages((unsigned long)vmbus_connection.monitor_pages[0], 0);
+	free_pages((unsigned long)vmbus_connection.monitor_pages[1], 0);
 	vmbus_connection.monitor_pages[0] = NULL;
 	vmbus_connection.monitor_pages[1] = NULL;
 
-- 
1.9.1

