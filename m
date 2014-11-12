Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaKLGkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 01:40:37 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55381 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaKLGkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 01:40:35 -0500
From: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Todd Poynor <toddpoynor@google.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Benoit Goby <benoit@android.com>,
        Kiran Raparthy <kiran.kumar@linaro.org>
Subject: [RFC v6 1/3] usb: phy: introduce usb_phy_set_event interface
Date: Wed, 12 Nov 2014 12:09:42 +0530
Message-Id: <1415774382-21719-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Todd Poynor <toddpoynor@google.com>

usb: phy: introduce usb_phy_set_event interface

PHY drivers require a generic interface to handle per-PHY events.

usb_phy_set_event interface sets event to phy event.
PHY drivers call this interface for each phy event.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Benoit Goby <benoit@android.com>
Signed-off-by: Todd Poynor <toddpoynor@google.com>
[kiran: Added context to commit message, squished build fixes
from Benoit Goby and Arve Hjønnevåg, changed wakelocks usage
to wakeupsource, merged Todd's refactoring logic and simplified
the structures and code and addressed community feedback]
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
---
 drivers/usb/phy/phy.c   | 12 ++++++++++++
 include/linux/usb/phy.h |  5 +++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index 045cd30..2b1039e 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -444,3 +444,15 @@ int usb_bind_phy(const char *dev_name, u8 index,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(usb_bind_phy);
+
+/**
+ * usb_phy_set_event - set event to phy event
+ * @x: the phy returned by usb_get_phy();
+ *
+ * This sets event to phy event
+ */
+void usb_phy_set_event(struct usb_phy *x, unsigned long event)
+{
+	x->last_event = event;
+}
+EXPORT_SYMBOL_GPL(usb_phy_set_event);
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index 353053a..3c713ff 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -210,6 +210,7 @@ extern void usb_put_phy(struct usb_phy *);
 extern void devm_usb_put_phy(struct device *dev, struct usb_phy *x);
 extern int usb_bind_phy(const char *dev_name, u8 index,
 				const char *phy_dev_name);
+extern void usb_phy_set_event(struct usb_phy *x, unsigned long event);
 #else
 static inline struct usb_phy *usb_get_phy(enum usb_phy_type type)
 {
@@ -251,6 +252,10 @@ static inline int usb_bind_phy(const char *dev_name, u8 index,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline void usb_phy_set_event(struct usb_phy *x, unsigned long event)
+{
+}
 #endif
 
 static inline int
-- 
1.8.2.1

