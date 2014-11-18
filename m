Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbaKRPIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:08:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965AbaKROJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:39 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Richard Leitner <richard.leitner@skidata.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 044/206] Input: serio - avoid negative serio device numbers
Date: Tue, 18 Nov 2014 15:06:39 +0100
Message-Id: <336cc76cb08dd42fa6afc3e1d92b9bd547cc6aa9.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Leitner <richard.leitner@skidata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0224ec9e9f111b1c39ec00a10de4858061b4afea upstream.

Fix the format string for serio device name generation to avoid negative
device numbers when the id exceeds the maximum signed integer value.

Signed-off-by: Richard Leitner <richard.leitner@skidata.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/serio/serio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index 2b56855c2c77..de019ebb7e29 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -506,8 +506,8 @@ static void serio_init_port(struct serio *serio)
 	spin_lock_init(&serio->lock);
 	mutex_init(&serio->drv_mutex);
 	device_initialize(&serio->dev);
-	dev_set_name(&serio->dev, "serio%ld",
-			(long)atomic_inc_return(&serio_no) - 1);
+	dev_set_name(&serio->dev, "serio%lu",
+		     (unsigned long)atomic_inc_return(&serio_no) - 1);
 	serio->dev.bus = &serio_bus;
 	serio->dev.release = serio_release_port;
 	serio->dev.groups = serio_device_attr_groups;
-- 
2.1.3

