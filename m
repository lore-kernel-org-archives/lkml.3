Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab3D0KO6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 06:14:58 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39544 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab3D0KO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 06:14:57 -0400
MIME-Version: 1.0
Date: Sat, 27 Apr 2013 18:14:56 +0800
Message-ID: <CAPgLHd8Jf7qp=Ob5B5OOsfxuXndAs9a9JYqyEBz=VnjOHi_tVQ@mail.gmail.com>
Subject: [PATCH] TTY: ehv_bytechan: add missing platform_driver_unregister()
 when module exit
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz, grant.likely@linaro.org,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

We have registered platform driver when module init, and
need unregister it when module exit.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
no compile test.
---
 drivers/tty/ehv_bytechan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
index 6d0c27c..9bffcec 100644
--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -859,6 +859,7 @@ error:
  */
 static void __exit ehv_bc_exit(void)
 {
+	platform_driver_unregister(&ehv_bc_tty_driver);
 	tty_unregister_driver(ehv_bc_driver);
 	put_tty_driver(ehv_bc_driver);
 	kfree(bcs);

