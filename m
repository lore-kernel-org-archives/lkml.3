Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbaDBH4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:56:38 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49294 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaDBH4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:56:36 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: davem@davemloft.net, lauro.venancio@openbossa.org
Cc: aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        linux-wireless@vger.kernel.org, linux-nfc@ml01.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] nfc: remove unneeded nfc_put_device() calls
Date: Wed, 02 Apr 2014 16:56:31 +0900
Message-ID: <31741678.fEkJSmnf5n@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If local is NULL, nfs_put_device() is called twice.
So nfs_put_device() in "if (!local)" is removed.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 net/nfc/netlink.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index b2ad570..3e0a676 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1038,7 +1038,6 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
 
 	local = nfc_llcp_find_local(dev);
 	if (!local) {
-		nfc_put_device(dev);
 		rc = -ENODEV;
 		goto exit;
 	}
-- 
1.7.4.4


