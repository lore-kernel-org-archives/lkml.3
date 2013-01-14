Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab3ANRUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:20:49 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:62137 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757202Ab3ANRUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:20:48 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] block: swim3.c: fix null pointer dereference
Date: Mon, 14 Jan 2013 17:20:38 +0000
Message-Id: <1358184042-29628-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the use if pointer fs should be after the null check.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/block/swim3.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index d889f95..deb722d 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -1090,10 +1090,13 @@ static const struct block_device_operations floppy_fops = {
 static void swim3_mb_event(struct macio_dev* mdev, int mb_state)
 {
 	struct floppy_state *fs = macio_get_drvdata(mdev);
-	struct swim3 __iomem *sw = fs->swim3;
+	struct swim3 __iomem *sw;
 
 	if (!fs)
 		return;
+
+	sw = fs->swim3;
+
 	if (mb_state != MB_FD)
 		return;
 
-- 
1.7.9.5

