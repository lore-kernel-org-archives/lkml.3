Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbaHCC4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 22:56:22 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:54762 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbaHCC4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 22:56:20 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Subject: [PATCH] scatterlist.h: Change CONFIG_DEBUG_SG for ifdef statement in sg_set_bf
Date: Sat,  2 Aug 2014 22:56:13 -0400
Message-Id: <1407034573-14358-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the ifdef statement in sg_set_bg to !CONFIG_DEBUG_SG in order
to avoid a bug with xhci dequence/enquence functions.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 include/linux/scatterlist.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index adae88f..62de7b3 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -111,7 +111,7 @@ static inline struct page *sg_page(struct scatterlist *sg)
 static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
 			      unsigned int buflen)
 {
-#ifdef CONFIG_DEBUG_SG
+#ifdef !CONFIG_DEBUG_SG
 	BUG_ON(!virt_addr_valid(buf));
 #endif
 	sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
--
1.9.1

