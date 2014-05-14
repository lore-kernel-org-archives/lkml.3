Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaENOmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:42:36 -0400
Received: from mail-yk0-f171.google.com ([209.85.160.171]:46967 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaENOmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:42:35 -0400
From: Jinqiang Zeng <jinqiangzeng@gmail.com>
To: Lidza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jinqiang Zeng <jinqiangzeng@gmail.com>
Subject: [PATCH] dgap: fix sparse warnings
Date: Wed, 14 May 2014 22:41:28 +0800
Message-Id: <1400078488-22391-1-git-send-email-jinqiangzeng@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix the sparse warnings
drivers/staging/dgap/dgap.c:689:28: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/dgap/dgap.c:689:28:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/dgap/dgap.c:689:28:    got unsigned char [usertype] *re_map_port
drivers/staging/dgap/dgap.c:695:28: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/dgap/dgap.c:695:28:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/dgap/dgap.c:695:28:    got unsigned char [usertype] *re_map_membase


Signed-off-by: Jinqiang Zeng <jinqiangzeng@gmail.com>
---
 drivers/staging/dgap/dgap.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgap/dgap.h b/drivers/staging/dgap/dgap.h
index 6b8f5f8..bceff7d 100644
--- a/drivers/staging/dgap/dgap.h
+++ b/drivers/staging/dgap/dgap.h
@@ -578,8 +578,8 @@ struct board_t {
 	ulong		membase;	/* Start of base memory of the card */
 	ulong		membase_end;	/* End of base memory of the card */
 
-	uchar 		*re_map_port;	/* Remapped io port of the card */
-	uchar		*re_map_membase;/* Remapped memory of the card */
+	uchar __iomem   *re_map_port;	/* Remapped io port of the card */
+	uchar __iomem	*re_map_membase;/* Remapped memory of the card */
 
 	uchar		runwait;	/* # Processes waiting for FEP  */
 	uchar		inhibit_poller; /* Tells  the poller to leave us alone */
-- 
1.7.7.6

