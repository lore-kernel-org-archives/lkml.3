Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965167Ab3DHKuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:50:08 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:57445 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934591Ab3DHKuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:50:06 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: gregkh@linuxfoundation.org, peter@hurleysoftware.com, jslaby@suse.cz,
        stefanr@s5r6.in-berlin.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] staging/fwserial: Replace seq_printf with seq_puts
Date: Mon,  8 Apr 2013 13:49:21 +0300
Message-Id: <1365418162-7876-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning about seq_printf.

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 drivers/staging/fwserial/fwserial.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 5c64e3a..e5818a1 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -1521,7 +1521,7 @@ static void fwtty_debugfs_show_port(struct seq_file *m, struct fwtty_port *port)
 		   stats.watermark);
 
 	if (port->port.console) {
-		seq_printf(m, "\n    ");
+		seq_puts(m, "\n    ");
 		(*port->fwcon_ops->proc_show)(m, port->con_data);
 	}
 
@@ -1553,7 +1553,7 @@ static int fwtty_proc_show(struct seq_file *m, void *v)
 		if (capable(CAP_SYS_ADMIN))
 			fwtty_proc_show_port(m, port);
 		fwtty_port_put(port);
-		seq_printf(m, "\n");
+		seq_puts(m, "\n");
 	}
 	return 0;
 }
@@ -1571,7 +1571,7 @@ static int fwtty_debugfs_stats_show(struct seq_file *m, void *v)
 			fwtty_proc_show_port(m, port);
 			fwtty_debugfs_show_port(m, port);
 			fwtty_port_put(port);
-			seq_printf(m, "\n");
+			seq_puts(m, "\n");
 		}
 	}
 	return 0;
-- 
1.7.10.4

