Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab3BOTfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:35:47 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:48558 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab3BOTfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:35:45 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak+fANmMHlFV5qjOPGdsb2JhbABEgwKDAAGEfa4Lhmt8FwMBAQEBODSCTS8TAQ8YgQIKGhOIFr0+FY8Wg0cDnCiNXQ
X-IronPort-AV: E=Sophos;i="4.84,675,1355094000"; 
   d="scan'208";a="498706291"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/2] Input: MT - do not apply filtering on emulated events
Date: Fri, 15 Feb 2013 20:36:20 +0100
Message-Id: <1360956981-1112-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pointer emulation events are derived from contact values that
have already been filtered, so send the emulated events as is.

Reported-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input-mt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index 1abbc17..1b7f4d4 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -18,6 +18,7 @@ static void copy_abs(struct input_dev *dev, unsigned int dst, unsigned int src)
 {
 	if (dev->absinfo && test_bit(src, dev->absbit)) {
 		dev->absinfo[dst] = dev->absinfo[src];
+		dev->absinfo[dst].fuzz = 0;
 		dev->absbit[BIT_WORD(dst)] |= BIT_MASK(dst);
 	}
 }
-- 
1.8.1.2

