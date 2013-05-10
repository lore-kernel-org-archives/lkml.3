Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3EJNij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:38:39 -0400
Received: from relay-s04-hub003.domainlocalhost.com ([74.115.207.102]:20942
	"EHLO relay-S04-HUB003.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707Ab3EJNih convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:38:37 -0400
From: Ferruh Yigit <fery@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <ttdrivers@cypress.com>, Ferruh Yigit <fery@cypress.com>,
        "Javier Martinez Canillas" <javier@dowhile0.org>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] Input: cyttsp - fix memcpy size param
Date: Fri, 10 May 2013 16:32:48 +0300
Message-ID: <1368192769-24067-1-git-send-email-fery@cypress.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memcpy param is wrong because of offset in bl_cmd, this may corrupt the
stack which may cause a crash.

Tested-by: Ferruh Yigit <fery@cypress.com> on TMA300-DVK
Signed-off-by: Ferruh Yigit <fery@cypress.com>
---
 drivers/input/touchscreen/cyttsp_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/cyttsp_core.c b/drivers/input/touchscreen/cyttsp_core.c
index 8e60437..97ba891 100644
--- a/drivers/input/touchscreen/cyttsp_core.c
+++ b/drivers/input/touchscreen/cyttsp_core.c
@@ -133,7 +133,7 @@ static int cyttsp_exit_bl_mode(struct cyttsp *ts)
        memcpy(bl_cmd, bl_command, sizeof(bl_command));
        if (ts->pdata->bl_keys)
                memcpy(&bl_cmd[sizeof(bl_command) - CY_NUM_BL_KEYS],
-                       ts->pdata->bl_keys, sizeof(bl_command));
+                       ts->pdata->bl_keys, CY_NUM_BL_KEYS);

        error = ttsp_write_block_data(ts, CY_REG_BASE,
                                      sizeof(bl_cmd), bl_cmd);
--
1.7.9.5

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
