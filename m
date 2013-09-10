Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab3IJWAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:00:03 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60185 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954Ab3IJWAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:00:01 -0400
X-Sasl-enc: L6bzrMNheBjeexiQFRWPDtRMd7p35m2XWlyVRKbW/j+v 1378850400
From: Jon Bernard <jbernard@tuxion.com>
To: gregkh@linuxfoundation.org, peter@hurleysoftware.com,
        stefanr@s5r6.in-berlin.de, jslaby@suse.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jon Bernard <jbernard@tuxion.com>
Subject: [PATCH] Staging: fwserial: wrap a line that exceeds 80 characters
Date: Tue, 10 Sep 2013 18:00:01 -0400
Message-Id: <1378850401-23402-1-git-send-email-jbernard@tuxion.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to fwserial.c that wraps a line which previously exceeded the 80
character limit warning found by checkpatch.pl.  This driver is now warning and
error free, according to checkpatch.pl

Signed-off-by: Jon Bernard <jbernard@tuxion.com>
---
 drivers/staging/fwserial/fwserial.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index ff92f34..62df009 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -2394,7 +2394,8 @@ static int fwserial_create(struct fw_unit *unit)
 
 	list_del_rcu(&serial->list);
 	if (create_loop_dev)
-		tty_unregister_device(fwloop_driver, loop_idx(serial->ports[j]));
+		tty_unregister_device(fwloop_driver,
+				      loop_idx(serial->ports[j]));
 unregister_ttys:
 	for (--j; j >= 0; --j)
 		tty_unregister_device(fwtty_driver, serial->ports[j]->index);
-- 
1.8.4

