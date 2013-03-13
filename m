Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3CMCRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 22:17:49 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:48021 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab3CMCRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 22:17:48 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: Print the correct information in debugfs pinconf-state file
Date: Wed, 13 Mar 2013 03:18:18 +0100
Message-Id: <1363141098-4974-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bad copy&paste resulted in the debugfs pinconf-state file printing the
pin name instead of the state name. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/pinctrl/pinconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 8aefd28..dae927f 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -622,7 +622,7 @@ static const struct file_operations pinconf_dbg_pinname_fops = {
 static int pinconf_dbg_state_print(struct seq_file *s, void *d)
 {
 	if (strlen(dbg_state_name))
-		seq_printf(s, "%s\n", dbg_pinname);
+		seq_printf(s, "%s\n", dbg_state_name);
 	else
 		seq_printf(s, "No pin state set\n");
 	return 0;
-- 
Regards,

Laurent Pinchart

