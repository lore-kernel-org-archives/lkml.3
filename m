Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab3CCNJz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 08:09:55 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:61948 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab3CCNJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 08:09:53 -0500
X-Greylist: delayed 62670 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Mar 2013 08:09:53 EST
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: netdev@vger.kernel.org
Cc: sjur.brandeland@stericsson.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] CAIF: fix sparse warning for caif_usb
Date: Sun,  3 Mar 2013 15:09:48 +0200
Message-Id: <1362316188-2927-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following sparse warning:
net/caif/caif_usb.c:84:16: warning: symbol 'cfusbl_create' was not
declared. Should it be static?

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 net/caif/caif_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
index 3ebc8cb..cbae9b0 100644
--- a/net/caif/caif_usb.c
+++ b/net/caif/caif_usb.c
@@ -81,7 +81,7 @@ static void cfusbl_ctrlcmd(struct cflayer *layr, enum caif_ctrlcmd ctrl,
 		layr->up->ctrlcmd(layr->up, ctrl, layr->id);
 }
 
-struct cflayer *cfusbl_create(int phyid, u8 ethaddr[ETH_ALEN],
+static struct cflayer *cfusbl_create(int phyid, u8 ethaddr[ETH_ALEN],
 					u8 braddr[ETH_ALEN])
 {
 	struct cfusbl *this = kmalloc(sizeof(struct cfusbl), GFP_ATOMIC);
-- 
1.7.9.5

