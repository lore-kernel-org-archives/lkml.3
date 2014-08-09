Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaHIAg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 20:36:26 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:33352 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405AbaHIAgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 20:36:23 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, dheitmueller@kernellabs.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] au0828: add au0828_rc_*() stubs for VIDEO_AU0828_RC disabled case
Date: Fri,  8 Aug 2014 18:36:18 -0600
Message-Id: <28002d678a82fe2865e712196bd83c7531e35fa4.1407544065.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1407544065.git.shuah.kh@samsung.com>
References: <cover.1407544065.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1407544065.git.shuah.kh@samsung.com>
References: <cover.1407544065.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define au0828_rc_*() stubs to avoid compile errors when
VIDEO_AU0828_RC is disabled and avoid the need to enclose
au0828_rc_*() in ifdef CONFIG_VIDEO_AU0828_RC in .c files.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/au0828/au0828.h |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 96bec05..fd0916e 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -326,7 +326,14 @@ extern struct videobuf_queue_ops au0828_vbi_qops;
 	} while (0)
 
 /* au0828-input.c */
-int au0828_rc_register(struct au0828_dev *dev);
-void au0828_rc_unregister(struct au0828_dev *dev);
-int au0828_rc_suspend(struct au0828_dev *dev);
-int au0828_rc_resume(struct au0828_dev *dev);
+#ifdef CONFIG_VIDEO_AU0828_RC
+extern int au0828_rc_register(struct au0828_dev *dev);
+extern void au0828_rc_unregister(struct au0828_dev *dev);
+extern int au0828_rc_suspend(struct au0828_dev *dev);
+extern int au0828_rc_resume(struct au0828_dev *dev);
+#else
+static inline int au0828_rc_register(struct au0828_dev *dev) { return 0; }
+static inline void au0828_rc_unregister(struct au0828_dev *dev) { }
+static inline int au0828_rc_suspend(struct au0828_dev *dev) { return 0; }
+static inline int au0828_rc_resume(struct au0828_dev *dev) { return 0; }
+#endif
-- 
1.7.10.4

