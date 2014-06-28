Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaF1NWG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 09:22:06 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:64244 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434AbaF1NWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 09:22:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkcHAAvBrlNbsk2v/2dsb2JhbABYgw2regUBAQEBAQEFAW0BkUKHQIEIF3WECwIkLyOBCRE3iEYBxRwXhWSJIR2ELQWXc4Jqiz+IPIIAgUQ7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 1/1] drivers/gpu/drm/drm_buffer.c: remove unnecessary null test before kfree
Date: Sat, 28 Jun 2014 15:20:43 +0200
Message-Id: <1403961643-6826-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes special case of last element and loops from idx to 0.

Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---

This is untested.

 drivers/gpu/drm/drm_buffer.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_buffer.c b/drivers/gpu/drm/drm_buffer.c
index 0406110..86a4a4a 100644
--- a/drivers/gpu/drm/drm_buffer.c
+++ b/drivers/gpu/drm/drm_buffer.c
@@ -80,11 +80,7 @@ int drm_buffer_alloc(struct drm_buffer **buf, int size)
 
 error_out:
 
-	/* Only last element can be null pointer so check for it first. */
-	if ((*buf)->data[idx])
-		kfree((*buf)->data[idx]);
-
-	for (--idx; idx >= 0; --idx)
+	for (; idx >= 0; --idx)
 		kfree((*buf)->data[idx]);
 
 	kfree(*buf);
-- 
1.8.4.5

