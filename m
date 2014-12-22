Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbaLVWSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:18:37 -0500
Received: from sauhun.de ([89.238.76.85]:53787 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbaLVWSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:18:36 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Corey Minyard <minyard@acm.org>,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH 1/2] char: ipmi: Remove obsolete cleanup for clientdata
Date: Mon, 22 Dec 2014 23:18:28 +0100
Message-Id: <1419286710-9991-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few new i2c-drivers came into the kernel which clear the clientdata-pointer
on exit or error. This is obsolete meanwhile, the core will do it.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/char/ipmi/ipmi_ssif.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index fd5a5e85d7dc..ba58734afaac 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1096,8 +1096,6 @@ static int ssif_remove(struct i2c_client *client)
 	if (!ssif_info)
 		return 0;
 
-	i2c_set_clientdata(client, NULL);
-
 	/*
 	 * After this point, we won't deliver anything asychronously
 	 * to the message handler.  We can unregister ourself.
-- 
2.1.3

