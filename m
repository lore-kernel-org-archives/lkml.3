Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaEOUnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:43:49 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:47618 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaEOUns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:43:48 -0400
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH] staging/rtl8723au fix sparse warning in os_initfs.c
Date: Thu, 15 May 2014 22:43:34 +0200
Message-Id: <1400186614-5978-1-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes the following sparse warning:

drivers/staging/rtl8723au/os_dep/os_intfs.c:
    - 322:14: warning: restricted __be16 degrades to integer

Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
---
 drivers/staging/rtl8723au/os_dep/os_intfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/os_dep/os_intfs.c b/drivers/staging/rtl8723au/os_dep/os_intfs.c
index 57eca7a..31a70af 100644
--- a/drivers/staging/rtl8723au/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723au/os_dep/os_intfs.c
@@ -319,7 +319,7 @@ u16 rtw_recv_select_queue23a(struct sk_buff *skb)
 
 	memcpy(&eth_type, pdata + (ETH_ALEN << 1), 2);
 	switch (eth_type) {
-	case htons(ETH_P_IP):
+	case be16_to_cpu(htons(ETH_P_IP)):
 		piphdr = (struct iphdr *)(pdata + ETH_HLEN);
 		dscp = piphdr->tos & 0xfc;
 		priority = dscp >> 5;
-- 
1.8.1.2

