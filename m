Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaF1Kh5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 06:37:57 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:7242 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754AbaF1Kh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 06:37:56 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkUHAFearlNbsk2v/2dsb2JhbABagw2regUBAQEBAQEFAW0BmQKBCBd1hDEvI4EaN4hGAcUXF4VkiSEdhC0FhGOVepN7ggCBRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org
Subject: [PATCH 1/1] drivers/net/hyperv/netvsc.c: remove unnecessary null test before kfree
Date: Sat, 28 Jun 2014 12:36:33 +0200
Message-Id: <1403951793-31069-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: devel@linuxdriverproject.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/hyperv/netvsc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 4ed38ea..f13e0ac 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1094,9 +1094,7 @@ close:
 	vmbus_close(device->channel);
 
 cleanup:
-
-	if (net_device)
-		kfree(net_device);
+	kfree(net_device);
 
 	return ret;
 }
-- 
1.8.4.5

