Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaF3Gb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:31:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbaF3Gb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:31:26 -0400
From: Jason Wang <jasowang@redhat.com>
To: kys@microsoft.com, haiyangz@microsoft.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH] hyperv: remove meaningless pr_err() in vmbus_recvpacket_raw()
Date: Mon, 30 Jun 2014 14:14:48 +0800
Message-Id: <1404108888-1329-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All its callers depends on the return value of -ENOBUFS to reallocate a
bigger buffer and retry the receiving. So there's no need to call
pr_err() here since it was not a real issue, otherwise syslog will be
flooded by this false warning.

Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/hv/channel.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 284cf66..531a593 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -808,12 +808,8 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 
 	*buffer_actual_len = packetlen;
 
-	if (packetlen > bufferlen) {
-		pr_err("Buffer too small - needed %d bytes but "
-			"got space for only %d bytes\n",
-			packetlen, bufferlen);
+	if (packetlen > bufferlen)
 		return -ENOBUFS;
-	}
 
 	*requestid = desc.trans_id;
 
-- 
1.7.1

