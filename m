Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3CDGwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 01:52:07 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:34875 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3CDGwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 01:52:05 -0500
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: netdev@vger.kernel.org
Cc: sjur.brandeland@stericsson.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] CAIF: fix sparse warning for caif_usb
Date: Mon,  4 Mar 2013 08:52:00 +0200
Message-Id: <1362379920-26126-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following sparse warning:
net/caif/caif_usb.c:84:16: warning: symbol 'cfusbl_create' was not
declared. Should it be static?

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 net/caif/caif_usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
index 3ebc8cb..1c6ded9 100644
--- a/net/caif/caif_usb.c
+++ b/net/caif/caif_usb.c
@@ -81,8 +81,8 @@ static void cfusbl_ctrlcmd(struct cflayer *layr, enum caif_ctrlcmd ctrl,
 		layr->up->ctrlcmd(layr->up, ctrl, layr->id);
 }
 
-struct cflayer *cfusbl_create(int phyid, u8 ethaddr[ETH_ALEN],
-					u8 braddr[ETH_ALEN])
+static struct cflayer *cfusbl_create(int phyid, u8 ethaddr[ETH_ALEN],
+							u8 braddr[ETH_ALEN])
 {
 	struct cfusbl *this = kmalloc(sizeof(struct cfusbl), GFP_ATOMIC);
 
-- 
1.7.9.5

