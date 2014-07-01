Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbaGAVsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:48:00 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:63933 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbaGAVrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:47:39 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 16/50] mars: add new file drivers/block/mars/lib_timing.c
Date: Tue,  1 Jul 2014 23:46:56 +0200
Message-Id: <1404251250-22992-17-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 drivers/block/mars/lib_timing.c | 51 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 drivers/block/mars/lib_timing.c

diff --git a/drivers/block/mars/lib_timing.c b/drivers/block/mars/lib_timing.c
new file mode 100644
index 0000000..9221c0b
--- /dev/null
+++ b/drivers/block/mars/lib_timing.c
@@ -0,0 +1,51 @@
+/*  (c) 2012 Thomas Schoebel-Theuer / 1&1 Internet AG */
+
+#include <linux/brick/lib_timing.h>
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#ifdef CONFIG_MARS_DEBUG
+
+int report_timing(struct timing_stats *tim, char *str, int maxlen)
+{
+	int len = 0;
+	int time = 1;
+	int resol = 1;
+
+	static const char * const units[] = {
+		"us",
+		"ms",
+		"s",
+		"ERROR"
+	};
+	const char *unit = units[0];
+	int unit_index = 0;
+	int i;
+
+	for (i = 0; i < TIMING_MAX; i++) {
+		int this_len = scnprintf(str,
+
+			maxlen,
+			"<%d%s = %d (%lld) ",
+			resol,
+			unit,
+			tim->tim_count[i],
+			(long long)tim->tim_count[i] * time);
+		str += this_len;
+		len += this_len;
+		maxlen -= this_len;
+		if (maxlen <= 1)
+			break;
+		resol <<= 1;
+		time <<= 1;
+		if (resol >= 1000) {
+			resol = 1;
+			unit = units[++unit_index];
+		}
+	}
+	return len;
+}
+EXPORT_SYMBOL_GPL(report_timing);
+
+#endif
-- 
2.0.0

