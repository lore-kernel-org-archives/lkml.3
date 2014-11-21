Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbaKUGEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 01:04:24 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:64200 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967AbaKUGEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 01:04:21 -0500
From: Kiran Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: balbi@ti.com, john.stultz@linaro.org, sumit.semwal@linaro.org,
        Kiran Raparthy <kiran.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Benoit Goby <benoit@android.com>, Todd Poynor <toddpoynor@google.com>
Subject: [PATCH v1 1/3] usb: phy: introduce usb_phy_set_event interface
Date: Fri, 21 Nov 2014 11:31:20 +0530
Message-Id: <8efd7b62ddb475cdac507387cbe25301818489c4.1416547297.git.kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1416547297.git.kiran.kumar@linaro.org>
References: <cover.1416547297.git.kiran.kumar@linaro.org>
In-Reply-To: <cover.1416547297.git.kiran.kumar@linaro.org>
References: <cover.1416547297.git.kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
[Original patch in Android from Todd]
Cc: Todd Poynor <toddpoynor@google.com>
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

