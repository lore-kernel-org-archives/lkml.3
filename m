Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163221Ab3DFDwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 23:52:10 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:55694 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab3DFDwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 23:52:09 -0400
MIME-Version: 1.0
Date: Sat, 6 Apr 2013 11:52:07 +0800
Message-ID: <CAPgLHd8ffGFuLdAFnx=bDmBS5U0FrH-fqCeneOHeWQQSE+v4wg@mail.gmail.com>
Subject: [PATCH -next] virtio_console: make local symbols static
From: Wei Yongjun <weiyj.lk@gmail.com>
To: amit.shah@redhat.com, arnd@arndb.de, rusty@rustcorp.com.au,
        gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Those symbols only used within this file, and should be static.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/char/virtio_console.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 13ad9b1..f73ad64 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -78,8 +78,8 @@ struct ports_driver_data {
 };
 static struct ports_driver_data pdrvdata;
 
-DEFINE_SPINLOCK(pdrvdata_lock);
-DECLARE_COMPLETION(early_console_added);
+static DEFINE_SPINLOCK(pdrvdata_lock);
+static DECLARE_COMPLETION(early_console_added);
 
 /* This struct holds information that's relevant only for console ports */
 struct console {
@@ -1202,7 +1202,7 @@ int __init virtio_cons_early_init(int (*put_chars)(u32, const char *, int))
 	return hvc_instantiate(0, 0, &hv_ops);
 }
 
-int init_port_console(struct port *port)
+static int init_port_console(struct port *port)
 {
 	int ret;
 

