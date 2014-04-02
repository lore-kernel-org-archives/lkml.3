Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbaDBHzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:55:36 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40843 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaDBHzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:55:35 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: davem@davemloft.net, lauro.venancio@openbossa.org
Cc: aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        linux-wireless@vger.kernel.org, linux-nfc@ml01.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] nfc: fix NULL pointer dereference
Date: Wed, 02 Apr 2014 16:55:30 +0900
Message-ID: <20540404.Au0OUqzobS@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


dev is NULL when nfc_get_device() is failed but
dev is used for handling error.

coccicheck says:
 net/nfc/netlink.c:1092:21-24: ERROR:
dev is NULL but dereferenced.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 net/nfc/netlink.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 43cb1c1..b2ad570 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1026,10 +1026,8 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
 	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
 
 	dev = nfc_get_device(idx);
-	if (!dev) {
-		rc = -ENODEV;
-		goto exit;
-	}
+	if (!dev)
+		return -ENODEV;
 
 	device_lock(&dev->dev);
 
-- 
1.7.4.4


