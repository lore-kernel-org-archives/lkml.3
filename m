Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaGPTp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:45:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44923 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaGPTpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:45:55 -0400
Date: Wed, 16 Jul 2014 12:45:29 -0700
From: tip-bot for Vivien Didelot <tipbot@zytor.com>
Message-ID: <tip-1d2408754d2c1376d67c00852548758e1ec2a94c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vivien.didelot@savoirfairelinux.com,
        hpa@zytor.com, mingo@kernel.org, kernel@savoirfairelinux.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, vivien.didelot@savoirfairelinux.com,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com,
        tglx@linutronix.de
In-Reply-To: <1404860269-11837-2-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1404860269-11837-2-git-send-email-vivien.didelot@savoirfairelinux.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/platform/ts5500: Use the DEVICE_ATTR_RO()
  macro
Git-Commit-ID: 1d2408754d2c1376d67c00852548758e1ec2a94c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d2408754d2c1376d67c00852548758e1ec2a94c
Gitweb:     http://git.kernel.org/tip/1d2408754d2c1376d67c00852548758e1ec2a94c
Author:     Vivien Didelot <vivien.didelot@savoirfairelinux.com>
AuthorDate: Tue, 8 Jul 2014 18:57:47 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 21:17:40 +0200

x86/platform/ts5500: Use the DEVICE_ATTR_RO() macro

Use the DEVICE_ATTR_RO() helper macro to simplify the declaration
of read-only sysfs attributes in the TS5500 code..

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Savoir-faire Linux Inc. <kernel@savoirfairelinux.com>
Link: http://lkml.kernel.org/r/1404860269-11837-2-git-send-email-vivien.didelot@savoirfairelinux.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/ts5500/ts5500.c | 50 +++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

diff --git a/arch/x86/platform/ts5500/ts5500.c b/arch/x86/platform/ts5500/ts5500.c
index 9471b94..1bbf17b 100644
--- a/arch/x86/platform/ts5500/ts5500.c
+++ b/arch/x86/platform/ts5500/ts5500.c
@@ -147,45 +147,39 @@ cleanup:
 	return ret;
 }
 
-static ssize_t ts5500_show_id(struct device *dev,
-			      struct device_attribute *attr, char *buf)
+static ssize_t id_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
 {
 	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
 
 	return sprintf(buf, "0x%.2x\n", sbc->id);
 }
+static DEVICE_ATTR_RO(id);
 
-static ssize_t ts5500_show_jumpers(struct device *dev,
-				   struct device_attribute *attr,
-				   char *buf)
+static ssize_t jumpers_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
 {
 	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
 
 	return sprintf(buf, "0x%.2x\n", sbc->jumpers >> 1);
 }
-
-#define TS5500_SHOW(field)					\
-	static ssize_t ts5500_show_##field(struct device *dev,	\
-			struct device_attribute *attr,		\
-			char *buf)				\
-	{							\
-		struct ts5500_sbc *sbc = dev_get_drvdata(dev);	\
-		return sprintf(buf, "%d\n", sbc->field);	\
-	}
-
-TS5500_SHOW(sram)
-TS5500_SHOW(rs485)
-TS5500_SHOW(adc)
-TS5500_SHOW(ereset)
-TS5500_SHOW(itr)
-
-static DEVICE_ATTR(id, S_IRUGO, ts5500_show_id, NULL);
-static DEVICE_ATTR(jumpers, S_IRUGO, ts5500_show_jumpers, NULL);
-static DEVICE_ATTR(sram, S_IRUGO, ts5500_show_sram, NULL);
-static DEVICE_ATTR(rs485, S_IRUGO, ts5500_show_rs485, NULL);
-static DEVICE_ATTR(adc, S_IRUGO, ts5500_show_adc, NULL);
-static DEVICE_ATTR(ereset, S_IRUGO, ts5500_show_ereset, NULL);
-static DEVICE_ATTR(itr, S_IRUGO, ts5500_show_itr, NULL);
+static DEVICE_ATTR_RO(jumpers);
+
+#define TS5500_ATTR_BOOL(_field)					\
+	static ssize_t _field##_show(struct device *dev,		\
+			struct device_attribute *attr, char *buf)	\
+	{								\
+		struct ts5500_sbc *sbc = dev_get_drvdata(dev);		\
+									\
+		return sprintf(buf, "%d\n", sbc->_field);		\
+	}								\
+	static DEVICE_ATTR_RO(_field)
+
+TS5500_ATTR_BOOL(sram);
+TS5500_ATTR_BOOL(rs485);
+TS5500_ATTR_BOOL(adc);
+TS5500_ATTR_BOOL(ereset);
+TS5500_ATTR_BOOL(itr);
 
 static struct attribute *ts5500_attributes[] = {
 	&dev_attr_id.attr,
