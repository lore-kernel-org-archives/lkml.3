Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030301AbaEQRRj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:17:39 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:38118 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030284AbaEQRRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:17:37 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Karsten Keil <isdn@linux-pingi.de>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] isdn: hisax: l3dss1.c:  Fix for possible null pointer dereference
Date: Sat, 17 May 2014 19:18:21 +0200
Message-Id: <1400347101-25476-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/isdn/hisax/l3dss1.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hisax/l3dss1.c b/drivers/isdn/hisax/l3dss1.c
index cda7006..3ea6257 100644
--- a/drivers/isdn/hisax/l3dss1.c
+++ b/drivers/isdn/hisax/l3dss1.c
@@ -2208,8 +2208,12 @@ static int l3dss1_cmd_global(struct PStack *st, isdn_ctrl *ic)
 				{ free_invoke_id(st, id);
 					return (-2);
 				}
-			pc->prot.dss1.ll_id = ic->parm.dss1_io.ll_id; /* remember id */
-			pc->prot.dss1.proc = ic->parm.dss1_io.proc; /* and procedure */
+
+			if (pc)
+			{
+				pc->prot.dss1.ll_id = ic->parm.dss1_io.ll_id; /* remember id */
+				pc->prot.dss1.proc = ic->parm.dss1_io.proc; /* and procedure */
+			}
 
 			if (!(skb = l3_alloc_skb(l)))
 			{ free_invoke_id(st, id);
-- 
1.7.10.4

