Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644Ab3EAXgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 19:36:53 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:45566 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3EAXgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 19:36:51 -0400
X-rim-org-msg-ref-id: 258902731
Message-ID: <258902731-1367451404-cardhu_decombobulator_blackberry.rim.net-605780320-@b4.c4.bise6.blackberry>
Reply-To: paul.ferrari@gmail.com
X-Priority: Normal
References: <20130501212445.496FB660D7C@gitolite.kernel.org>
In-Reply-To: <20130501212445.496FB660D7C@gitolite.kernel.org>
Sensitivity: Normal
Importance: Normal
Subject: Re: NFC: llcp: Only keep raw sockets alive when the LLCP local leaves
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
From: paul.ferrari@gmail.com
Date: Wed, 1 May 2013 23:36:42 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r41NavFY000458

Dd0 ddddDDddD$

Sent from my Verizon Wireless BlackBerry

-----Original Message-----
From:	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Sender:	git-commits-head-owner@vger.kernel.org
Date:	Wed,  1 May 2013 21:24:45 
To: <git-commits-head@vger.kernel.org>
Subject: NFC: llcp: Only keep raw sockets alive when the LLCP local leaves

Gitweb:     http://git.kernel.org/linus/;a=commit;h=b436a13debec2b3d2c671d6bebcdb91dabcb0795
Commit:     b436a13debec2b3d2c671d6bebcdb91dabcb0795
Parent:     495af72e1434724559e756ba32d9040125ac506b
Author:     Samuel Ortiz <sameo@linux.intel.com>
AuthorDate: Wed Apr 3 16:34:19 2013 +0200
Committer:  Samuel Ortiz <sameo@linux.intel.com>
CommitDate: Thu Apr 11 16:29:09 2013 +0200

    NFC: llcp: Only keep raw sockets alive when the LLCP local leaves
    
    When the MAC goes down, connected and connection less sockets should be
    notified, but raw sockets should be kept alive.
    They will get notified only when the physical devices goes away.
    
    Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |   26 +++-----------------------
 1 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 83e788e..99ec39d 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -76,7 +76,7 @@ static void nfc_llcp_socket_purge(struct nfc_llcp_sock *sock)
 	}
 }
 
-static void nfc_llcp_socket_release(struct nfc_llcp_local *local, bool listen,
+static void nfc_llcp_socket_release(struct nfc_llcp_local *local, bool device,
 				    int err)
 {
 	struct sock *sk;
@@ -116,23 +116,6 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local, bool listen,
 
 				bh_unlock_sock(accept_sk);
 			}
-
-			if (listen == true) {
-				nfc_llcp_socket_remote_param_init(llcp_sock);
-				bh_unlock_sock(sk);
-				continue;
-			}
-		}
-
-		/*
-		 * If we have a connection less socket bound, we keep it alive
-		 * if the device is still present.
-		 */
-		if (sk->sk_state == LLCP_BOUND && sk->sk_type == SOCK_DGRAM &&
-		    listen == true) {
-			nfc_llcp_socket_remote_param_init(llcp_sock);
-			bh_unlock_sock(sk);
-			continue;
 		}
 
 		if (err)
@@ -147,11 +130,8 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local, bool listen,
 
 	write_unlock(&local->sockets.lock);
 
-	/*
-	 * If we want to keep the listening sockets alive,
-	 * we don't touch the RAW ones.
-	 */
-	if (listen == true)
+	/* If we still have a device, we keep the RAW sockets alive */
+	if (device == true)
 		return;
 
 	write_lock(&local->raw_sockets.lock);
--
To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
