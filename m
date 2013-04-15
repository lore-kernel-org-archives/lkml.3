Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3DOOnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:43:10 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:65309 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab3DOOm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:42:59 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Federico Vaga <federico.vaga@gmail.com>
Subject: [RFC PATCH] sparc/kernel/vio.c: add put_device() after device_find_child()
Date: Mon, 15 Apr 2013 16:42:52 +0200
Message-Id: <1366036972-9240-1-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vio_remove() function uses device_find_child() but it does not drop
the reference of the retrieved child.

Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
---

I do not have a SPARC system (and I do not know it), so I cannot test this
patch. Please test it.
If I'm right, the device_unregister() does not work properly because,
device_find_child() did get_device() on dev. In essence, the release method
associated to the device will never be invoked because there is a reference
to the device that is not dropped.

 arch/sparc/kernel/vio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/kernel/vio.c b/arch/sparc/kernel/vio.c
index 3e244f3..8647fcc 100644
--- a/arch/sparc/kernel/vio.c
+++ b/arch/sparc/kernel/vio.c
@@ -342,6 +342,7 @@ static void vio_remove(struct mdesc_handle *hp, u64 node)
 		printk(KERN_INFO "VIO: Removing device %s\n", dev_name(dev));
 
 		device_unregister(dev);
+		put_device(dev);
 	}
 }
 
-- 
1.8.1.4

