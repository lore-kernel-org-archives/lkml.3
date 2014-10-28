Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbaJ1L2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:28:36 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:61263 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbaJ1L1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:27:35 -0400
From: Qais Yousef <qais.yousef@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Qais Yousef <qais.yousef@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <alsa-devel@alsa-project.org>
Subject: [PATCH 10/11] drivers: char: axd: add ts interface file
Date: Tue, 28 Oct 2014 11:26:28 +0000
Message-ID: <1414495589-8579-11-git-send-email-qais.yousef@imgtec.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ts (time stamp) interface is required when axd is to perform synchronisation.
since the time stamp hardware is SoC dependent, this file provides the
interface that can be implemented by a different driver to do the necessary
time stamp translation to perform synchronisation inside AXD

Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <alsa-devel@alsa-project.org>
---
 drivers/char/axd/axd_ts_driver.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 drivers/char/axd/axd_ts_driver.h

diff --git a/drivers/char/axd/axd_ts_driver.h b/drivers/char/axd/axd_ts_driver.h
new file mode 100644
index 000000000000..2b99ad4a7adc
--- /dev/null
+++ b/drivers/char/axd/axd_ts_driver.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * AXD timestamp driver interface.
+ */
+#include <linux/types.h>
+
+/*
+ * Called at the beginning of a stream to set the fixed reference point in time
+ * for the stream. This should not be implemented if the reference point should
+ * not be altered in this way, and is managed through other means.
+ */
+void __attribute__((weak)) axd_ts_reset(void);
+
+/*
+ * Adjusts the provided timestamp from the source to destination formats.
+ * @return Non-zero for failure.
+ */
+int __attribute__((weak)) axd_ts_adjust(u64 *ts);
-- 
2.1.0

