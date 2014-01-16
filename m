Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaAPM4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 07:56:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:60559 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaAPM4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 07:56:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,667,1384329600"; 
   d="scan'208";a="467638794"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serial: 8250_dw: fix compilation warning when !CONFIG_PM_SLEEP
Date: Thu, 16 Jan 2014 14:55:57 +0200
Message-Id: <1389876957-6052-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_PM will be set if either or both CONFIG_PM_SLEEP and
CONFIG_PM_RUNTIME is set. Compiling the driver with !CONFIG_PM_SLEEP causes
following compilation warnings:

drivers/tty/serial/8250/8250_dw.c:404:12: warning: ‘dw8250_suspend’ defined but not used [-Wunused-function]
drivers/tty/serial/8250/8250_dw.c:413:12: warning: ‘dw8250_resume’ defined but not used [-Wunused-function]

Fix this by using CONFIG_PM_SLEEP instead.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 06525f10e364..47e6c57de3a6 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -400,7 +400,7 @@ static int dw8250_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int dw8250_suspend(struct device *dev)
 {
 	struct dw8250_data *data = dev_get_drvdata(dev);
@@ -418,7 +418,7 @@ static int dw8250_resume(struct device *dev)
 
 	return 0;
 }
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_PM_RUNTIME
 static int dw8250_runtime_suspend(struct device *dev)
-- 
1.8.5.2

