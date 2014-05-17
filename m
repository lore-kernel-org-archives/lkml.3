Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964927AbaEQRS5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:18:57 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:37098 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856AbaEQRS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:18:56 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Karsten Keil <isdn@linux-pingi.de>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] isdn: hisax: l3ni1.c:  Fix for possible null pointer dereference
Date: Sat, 17 May 2014 19:19:40 +0200
Message-Id: <1400347180-25553-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/isdn/hisax/l3ni1.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hisax/l3ni1.c b/drivers/isdn/hisax/l3ni1.c
index 0df6691..367b9d6 100644
--- a/drivers/isdn/hisax/l3ni1.c
+++ b/drivers/isdn/hisax/l3ni1.c
@@ -2064,8 +2064,12 @@ static int l3ni1_cmd_global(struct PStack *st, isdn_ctrl *ic)
 				{ free_invoke_id(st, id);
 					return (-2);
 				}
-			pc->prot.ni1.ll_id = ic->parm.ni1_io.ll_id; /* remember id */
-			pc->prot.ni1.proc = ic->parm.ni1_io.proc; /* and procedure */
+
+			if (pc)
+			{
+				pc->prot.ni1.ll_id = ic->parm.ni1_io.ll_id; /* remember id */
+				pc->prot.ni1.proc = ic->parm.ni1_io.proc; /* and procedure */
+			}
 
 			if (!(skb = l3_alloc_skb(l)))
 			{ free_invoke_id(st, id);
-- 
1.7.10.4

