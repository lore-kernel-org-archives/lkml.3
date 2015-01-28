Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391AbbA1EPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:15:05 -0500
Received: from mail.kernel.org ([198.145.29.136]:37221 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933344AbbA1EO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:14:57 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 019/177] Drivers: hv: vmbus: Fix a bug in vmbus_open()
Date: Wed, 28 Jan 2015 12:06:44 +0800
Message-Id: <1422418236-12852-37-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 45d727cee9e200f5b351528b9fb063b69cf702c8 upstream.

Fix a bug in vmbus_open() and properly propagate the error. I would
like to thank Dexuan Cui <decui@microsoft.com> for identifying the
issue.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/hv/channel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 1211d38..7bbbb95 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -207,8 +207,10 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	ret = vmbus_post_msg(open_msg,
 			       sizeof(struct vmbus_channel_open_channel));
 
-	if (ret != 0)
+	if (ret != 0) {
+		err = ret;
 		goto error1;
+	}
 
 	t = wait_for_completion_timeout(&open_info->waitevent, 5*HZ);
 	if (t == 0) {
-- 
1.9.1

