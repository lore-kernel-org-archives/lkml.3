Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3GBLIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:08:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36261 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab3GBLIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ferruh Yigit <fery@cypress.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 26/50] Input: cyttsp - fix memcpy size param
Date: Tue,  2 Jul 2013 12:07:14 +0100
Message-Id: <1372763258-20664-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ferruh Yigit <fery@cypress.com>

commit d2983cdb480157f637df07723f28aaa657b1080d upstream.

memcpy param is wrong because of offset in bl_cmd, this may corrupt the
stack which may cause a crash.

Tested-by: Ferruh Yigit <fery@cypress.com> on TMA300-DVK
Signed-off-by: Ferruh Yigit <fery@cypress.com>
Acked-by: Javier Martinez Canillas <javier@dowhile0.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/touchscreen/cyttsp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/cyttsp_core.c b/drivers/input/touchscreen/cyttsp_core.c
index f030d9e..3f505d5 100644
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

