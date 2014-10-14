Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaJNQkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:40:43 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:54835 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873AbaJNQkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:40:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AskNADpRPVRbtAZ+/2dsb2JhbABbgw6BK7h2BQFzmhaBFhcBfYQwLyOBGjeIQgG3UI8bLIYgiiUdhDUFnUuWEYFHgjI7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/1 linux-next] zd1201: replace kmalloc/memset by kzalloc
Date: Tue, 14 Oct 2014 18:40:31 +0200
Message-Id: <1413304831-7203-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/zd1201.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index 6f5c793..4630b26 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -525,7 +525,7 @@ static int zd1201_setconfig(struct zd1201 *zd, int rid, void *buf, int len, int
 	zd->rxdatas = 0;
 	zd->rxlen = 0;
 	for (seq=0; len > 0; seq++) {
-		request = kmalloc(16, gfp_mask);
+		request = kzalloc(16, gfp_mask);
 		if (!request)
 			return -ENOMEM;
 		urb = usb_alloc_urb(0, gfp_mask);
@@ -533,7 +533,6 @@ static int zd1201_setconfig(struct zd1201 *zd, int rid, void *buf, int len, int
 			kfree(request);
 			return -ENOMEM;
 		}
-		memset(request, 0, 16);
 		reqlen = len>12 ? 12 : len;
 		request[0] = ZD1201_USB_RESREQ;
 		request[1] = seq;
-- 
1.9.3

