Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaIJPuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:50:32 -0400
Received: from mail-we0-f202.google.com ([74.125.82.202]:51362 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaIJPua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:50:30 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH 2/2] usb: f_fs: replace BUG in dead-code with less serious WARN_ON
Date: Wed, 10 Sep 2014 17:50:25 +0200
Message-Id: <1410364225-6087-2-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410364225-6087-1-git-send-email-mina86@mina86.com>
References: <1410364225-6087-1-git-send-email-mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though the BUG() in __ffs_event_add is a dead-code, it is still
better to warn rather then crash the system if that code ever gets
executed.

Suggested-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 This has been compile tested only.

 drivers/usb/gadget/function/f_fs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index ec50e0d..74d48b3 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2321,7 +2321,9 @@ static void __ffs_event_add(struct ffs_data *ffs,
 		break;
 
 	default:
-		BUG();
+		pr_vdebug("%d: unknown event, this should not happen\n", type);
+		WARN_ON(1);
+		return;
 	}
 
 	{
-- 
2.1.0.rc2.206.gedb03e5

