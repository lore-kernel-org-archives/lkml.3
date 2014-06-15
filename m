Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaFOGpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 02:45:46 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:54748 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282AbaFOGpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 02:45:45 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEGADtAnVNXQzGY/2dsb2JhbABagw2rDgYBAwEGmSSBAxd1hDEvI4EaN4hGAc8LF4VjiC9kHYQtBJpDizCIKINCO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Yehuda Sadeh <yehuda@inktank.com>,
        Sage Weil <sage@inktank.com>
Subject: [PATCH 1/1 RESEND] drivers/block/rbd.c: use PTR_ERR_OR_ZERO
Date: Sun, 15 Jun 2014 08:44:24 +0200
Message-Id: <1402814664-3270-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace IS_ERR/PTR_ERR

Cc: Yehuda Sadeh <yehuda@inktank.com>
Cc: Sage Weil <sage@inktank.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 4c95b50..552a2ed 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4752,7 +4752,7 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
 
 		image_id = ceph_extract_encoded_string(&p, p + ret,
 						NULL, GFP_NOIO);
-		ret = IS_ERR(image_id) ? PTR_ERR(image_id) : 0;
+		ret = PTR_ERR_OR_ZERO(image_id);
 		if (!ret)
 			rbd_dev->image_format = 2;
 	} else {
-- 
1.8.4.5

