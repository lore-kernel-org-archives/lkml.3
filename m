Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3LNMqk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:46:40 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39638 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3LNMqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:46:39 -0500
Date: Sat, 14 Dec 2013 18:16:28 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>, josh@joshtriplett.org
Subject: [PATCH 1/3] drivers: rapidio: Include appropriate header file in
 rio-access.c
Message-ID: <8522e3b2fefdb6625e9d7ae651cfa2dfd4733293.1386926041.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes appropriate header file linux/rio_drv.h in
rio-access.c because functions __rio_local_read_config_8,
__rio_local_read_config_16, __rio_local_read_config_32,
__rio_local_write_config_8, __rio_local_write_config_16,
__rio_local_write_config_32, rio_mport_read_config_8,
rio_mport_read_config_16, rio_mport_read_config_32,
rio_mport_write_config_8, rio_mport_write_config_16,
rio_mport_write_config_32 and rio_mport_send_doorbell have their
prototype declaration in linux/rio_drv.h.

Thus, it also eliminates the following warning in rio-access.c:

drivers/rapidio/rio-access.c:79:1: warning: no previous prototype for ‘__rio_local_read_config_8’ [-Wmissing-prototypes]
drivers/rapidio/rio-access.c:80:1: warning: no previous prototype for ‘__rio_local_read_config_16’ [-Wmissing-prototypes]
drivers/rapidio/rio-access.c:81:1: warning: no previous prototype for ‘__rio_local_read_config_32’ [-Wmissing-prototypes]
drivers/rapidio/rio-access.c:82:1: warning: no previous prototype for ‘__rio_local_write_config_8’ [-Wmissing-prototypes]
drivers/rapidio/rio-access.c:83:1: warning: no previous prototype for ‘__rio_local_write_config_16’ [-Wmissing-prototypes]
drivers/rapidio/rio-access.c:84:1: warning: no previous prototype for ‘__rio_local_write_config_32’ [-Wmissing-prototypes]
drivers/rapidio/rio-access.c:139:1: warning: no previous prototype for ‘rio_mport_read_config_8’ [-Wmissing-prototypes]
drivers/rapidio/rio-access.c:140:1: warning: no previous prototype for ‘rio_mport_read_config_16’ [-Wmissing-prototypes]
drivers/rapidio/rio-access.c:141:1: warning: no previous prototype for ‘rio_mport_read_config_32’ [-Wmissing-prototypes]
drivers/rapidio/rio-access.c:142:1: warning: no previous prototype for ‘rio_mport_write_config_8’ [-Wmissing-prototypes]
drivers/rapidio/rio-access.c:143:1: warning: no previous prototype for ‘rio_mport_write_config_16’ [-Wmissing-prototypes]
drivers/rapidio/rio-access.c:144:1: warning: no previous prototype for ‘rio_mport_write_config_32’ [-Wmissing-prototypes]
drivers/rapidio/rio-access.c:163:5: warning: no previous prototype for ‘rio_mport_send_doorbell’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/rapidio/rio-access.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rapidio/rio-access.c b/drivers/rapidio/rio-access.c
index a3824ba..5e6c7eb 100644
--- a/drivers/rapidio/rio-access.c
+++ b/drivers/rapidio/rio-access.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/rio.h>
+#include <linux/rio_drv.h>
 #include <linux/module.h>
 
 /*
-- 
1.7.9.5

