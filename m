Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbaJHUzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:55:08 -0400
Received: from relay05.alfahosting-server.de ([109.237.142.241]:46247 "EHLO
	relay05.alfahosting-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755170AbaJHUzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:55:06 -0400
X-Spam-DCC: : 
Date: Wed, 8 Oct 2014 22:42:45 +0200
From: Richard Leitner <me@g0hl1n.net>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        richard.leitner@skidata.com
Subject: [PATCH] input: avoid negative input device numbers
Message-ID: <20141008224245.601a1339@frodo>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Checker-Version: clamassassin 1.2.4 with ClamAV 0.97.3/19486/Wed Oct  8 18:37:03 2014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Leitner <richard.leitner@skidata.com>

Fix the format string for input device name generation to avoid negative
device numbers when the id exceeds the maximum signed integer value.

Signed-off-by: Richard Leitner <richard.leitner@skidata.com>
---
 drivers/input/input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 236bc56..6be6982 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1791,7 +1791,7 @@ struct input_dev *input_allocate_device(void)
 		INIT_LIST_HEAD(&dev->h_list);
 		INIT_LIST_HEAD(&dev->node);
 
-		dev_set_name(&dev->dev, "input%ld",
+		dev_set_name(&dev->dev, "input%lu",
 			     (unsigned long) atomic_inc_return(&input_no) - 1);
 
 		__module_get(THIS_MODULE);
-- 
2.1.1

