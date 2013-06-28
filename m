Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab3F1S4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:56:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41797 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3F1S4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:56:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ferruh Yigit <fery@cypress.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 040/105] Input: cyttsp - fix memcpy size param
Date: Fri, 28 Jun 2013 11:51:02 -0700
Message-Id: <1372445527-24414-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ferruh Yigit <fery@cypress.com>

commit d2983cdb480157f637df07723f28aaa657b1080d upstream.

memcpy param is wrong because of offset in bl_cmd, this may corrupt the
stack which may cause a crash.

Tested-by: Ferruh Yigit <fery@cypress.com> on TMA300-DVK
Signed-off-by: Ferruh Yigit <fery@cypress.com>
Acked-by: Javier Martinez Canillas <javier@dowhile0.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/touchscreen/cyttsp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/cyttsp_core.c b/drivers/input/touchscreen/cyttsp_core.c
index 8e60437..97ba891 100644
--- a/drivers/input/touchscreen/cyttsp_core.c
+++ b/drivers/input/touchscreen/cyttsp_core.c
@@ -133,7 +133,7 @@ static int cyttsp_exit_bl_mode(struct cyttsp *ts)
 	memcpy(bl_cmd, bl_command, sizeof(bl_command));
 	if (ts->pdata->bl_keys)
 		memcpy(&bl_cmd[sizeof(bl_command) - CY_NUM_BL_KEYS],
-			ts->pdata->bl_keys, sizeof(bl_command));
+			ts->pdata->bl_keys, CY_NUM_BL_KEYS);
 
 	error = ttsp_write_block_data(ts, CY_REG_BASE,
 				      sizeof(bl_cmd), bl_cmd);
-- 
1.8.1.2

