Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaCAMwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 07:52:45 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:40196 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbaCAMwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 07:52:43 -0500
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: <linville@tuxdriver.com>
Cc: will.deacon@arm.com, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [PATCH] wl1251: use skb_trim to make skb shorter
Date: Sat,  1 Mar 2014 14:52:06 +0200
Message-Id: <1393678326-23535-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20140225105756.GB22279@mudshark.cambridge.arm.com>
References: <20140225105756.GB22279@mudshark.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the current code is directly setting skb->len, which is not correct and
brings problems with HAVE_EFFICIENT_UNALIGNED_ACCESS enabled in config

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 drivers/net/wireless/ti/wl1251/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/rx.c b/drivers/net/wireless/ti/wl1251/rx.c
index 123c4bb..cde0eaf 100644
--- a/drivers/net/wireless/ti/wl1251/rx.c
+++ b/drivers/net/wireless/ti/wl1251/rx.c
@@ -180,7 +180,7 @@ static void wl1251_rx_body(struct wl1251 *wl,
 	wl1251_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);
 
 	/* The actual length doesn't include the target's alignment */
-	skb->len = desc->length  - PLCP_HEADER_LENGTH;
+	skb_trim(skb, desc->length - PLCP_HEADER_LENGTH);
 
 	fc = (u16 *)skb->data;
 
-- 
1.7.9.5

