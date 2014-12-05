Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaLELUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:20:06 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:38545 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaLELUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:20:04 -0500
From: Sanjay Singh Rawat <snjsrwt@gmail.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, andrzej.p@samsung.com, mina86@mina86.com,
        Sanjay Singh Rawat <snjsrwt@gmail.com>
Subject: [PATCH] usb: gadget: f_mass_storage: restore address range on exit
Date: Fri,  5 Dec 2014 16:51:30 +0530
Message-Id: <1417778490-20723-1-git-send-email-snjsrwt@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the start of the thread we are changing the address limit, restoring it
to the default while exiting.

Signed-off-by: Sanjay Singh Rawat <snjsrwt@gmail.com>
---
 drivers/usb/gadget/function/f_mass_storage.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index 811929c..c4a2ded 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2489,6 +2489,7 @@ static void handle_exception(struct fsg_common *common)
 static int fsg_main_thread(void *common_)
 {
 	struct fsg_common	*common = common_;
+	mm_segment_t fs = get_fs();
 
 	/*
 	 * Allow the thread to be killed by a signal, but set the signal mask
@@ -2567,6 +2568,7 @@ static int fsg_main_thread(void *common_)
 		up_write(&common->filesem);
 	}
 
+	set_fs(fs);
 	/* Let fsg_unbind() know the thread has exited */
 	complete_and_exit(&common->thread_notifier, 0);
 }
-- 
1.8.3.2

