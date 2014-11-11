Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaKKCVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 21:21:54 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:53240 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaKKCVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 21:21:53 -0500
From: David Fries <David@Fries.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/2] w1: avoid potential u16 overflow
Date: Mon, 10 Nov 2014 20:19:37 -0600
Message-Id: <1415672377-18758-3-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415672377-18758-1-git-send-email-David@Fries.net>
References: <18541415578350@web5g.yandex.ru>
 <1415672377-18758-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Mon, 10 Nov 2014 20:21:42 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: David Fries <David@Fries.net>
---
 drivers/w1/w1_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index dd96562..881597a 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -598,7 +598,7 @@ static void w1_cn_callback(struct cn_msg *cn, struct netlink_skb_parms *nsp)
 	msg = (struct w1_netlink_msg *)(cn + 1);
 	if (node_count) {
 		int size;
-		u16 reply_size = sizeof(*cn) + cn->len + slave_len;
+		int reply_size = sizeof(*cn) + cn->len + slave_len;
 		if (cn->flags & W1_CN_BUNDLE) {
 			/* bundling duplicats some of the messages */
 			reply_size += 2 * cmd_count * (sizeof(struct cn_msg) +
-- 
1.7.10.4

