Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbaGAV5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:57:33 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:43838 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758881AbaGAVxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:53:52 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 17/50] mars: add new file include/linux/brick/lib_limiter.h
Date: Tue,  1 Jul 2014 23:46:57 +0200
Message-Id: <1404251250-22992-18-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 include/linux/brick/lib_limiter.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 include/linux/brick/lib_limiter.h

diff --git a/include/linux/brick/lib_limiter.h b/include/linux/brick/lib_limiter.h
new file mode 100644
index 0000000..87db968
--- /dev/null
+++ b/include/linux/brick/lib_limiter.h
@@ -0,0 +1,33 @@
+/*  (c) 2012 Thomas Schoebel-Theuer / 1&1 Internet AG */
+#ifndef BRICK_LIB_LIMITER_H
+#define BRICK_LIB_LIMITER_H
+
+#include <linux/brick/brick.h>
+
+#include <linux/utsname.h>
+
+struct xio_limiter {
+	/* hierarchy tree */
+	struct xio_limiter *lim_father;
+
+	/* tunables */
+	int lim_max_rate;
+	int lim_max_delay;
+	int lim_min_window;
+	int lim_max_window;
+
+	/* readable */
+	int lim_rate;
+	int lim_cumul;
+	int lim_count;
+	long long lim_stamp;
+
+	/* internal */
+	long long lim_accu;
+};
+
+extern int xio_limit(struct xio_limiter *lim, int amount);
+
+extern void xio_limit_sleep(struct xio_limiter *lim, int amount);
+
+#endif
-- 
2.0.0

