Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaESVXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:23:36 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:34544 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaESVXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:23:33 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Karsten Keil <isdn@linux-pingi.de>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] isdn: hisax: l3dss1.c:  Fix for possible null pointer dereference
Date: Mon, 19 May 2014 23:24:22 +0200
Message-Id: <1400534662-5729-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/isdn/hisax/l3dss1.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/isdn/hisax/l3dss1.c b/drivers/isdn/hisax/l3dss1.c
index cda7006..9ea7377 100644
--- a/drivers/isdn/hisax/l3dss1.c
+++ b/drivers/isdn/hisax/l3dss1.c
@@ -2203,13 +2203,14 @@ static int l3dss1_cmd_global(struct PStack *st, isdn_ctrl *ic)
 			memcpy(p, ic->parm.dss1_io.data, ic->parm.dss1_io.datalen); /* copy data */
 			l = (p - temp) + ic->parm.dss1_io.datalen; /* total length */
 
-			if (ic->parm.dss1_io.timeout > 0)
-				if (!(pc = dss1_new_l3_process(st, -1)))
-				{ free_invoke_id(st, id);
+			if (ic->parm.dss1_io.timeout > 0) {
+				if (!(pc = dss1_new_l3_process(st, -1))) {
+					free_invoke_id(st, id);
 					return (-2);
 				}
-			pc->prot.dss1.ll_id = ic->parm.dss1_io.ll_id; /* remember id */
-			pc->prot.dss1.proc = ic->parm.dss1_io.proc; /* and procedure */
+				pc->prot.dss1.ll_id = ic->parm.dss1_io.ll_id; /* remember id */
+				pc->prot.dss1.proc = ic->parm.dss1_io.proc; /* and procedure */
+			}
 
 			if (!(skb = l3_alloc_skb(l)))
 			{ free_invoke_id(st, id);
-- 
1.7.10.4

