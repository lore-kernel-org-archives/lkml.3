Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3KDRI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:08:27 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:44504 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3KDRIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:08:25 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com
Subject: [PATCH 8/9] GenWQE: Simplify sysfs buffer printouts
Date: Mon,  4 Nov 2013 18:08:08 +0100
Message-Id: <1383584889-21594-9-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
References: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110417-2966-0000-0000-0000093F31AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework code which was inteneded to print out multiple lines via sysfs
attributes. This is not needed anymore. We just print one item.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/card_sysfs.c |   59 +++++++++-----------------------------
 1 files changed, 14 insertions(+), 45 deletions(-)

diff --git a/drivers/misc/genwqe/card_sysfs.c b/drivers/misc/genwqe/card_sysfs.c
index 6a51ad7..f29ce55 100644
--- a/drivers/misc/genwqe/card_sysfs.c
+++ b/drivers/misc/genwqe/card_sysfs.c
@@ -48,82 +48,65 @@ static const char * const genwqe_types[] = {
 static ssize_t status_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
-	ssize_t len = 0;
 	struct genwqe_dev *cd = dev_get_drvdata(dev);
 	const char *cs[GENWQE_CARD_STATE_MAX] = { "unused", "used", "error" };
 
-	len += scnprintf(&buf[len], PAGE_SIZE - len,
-			 "%s\n", cs[cd->card_state]);
-	return len;
+	return scnprintf(buf, PAGE_SIZE, "%s\n", cs[cd->card_state]);
 }
 static DEVICE_ATTR_RO(status);
 
 static ssize_t appid_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
-	ssize_t len = 0;
 	char app_name[5];
 	struct genwqe_dev *cd = dev_get_drvdata(dev);
 
 	genwqe_read_app_id(cd, app_name, sizeof(app_name));
-	len += scnprintf(&buf[len], PAGE_SIZE - len,
-			 "%s\n", app_name);
-	return len;
+	return scnprintf(buf, PAGE_SIZE, "%s\n", app_name);
 }
 static DEVICE_ATTR_RO(appid);
 
 static ssize_t version_show(struct device *dev, struct device_attribute *attr,
 			    char *buf)
 {
-	ssize_t len = 0;
 	u64 slu_id, app_id;
 	struct genwqe_dev *cd = dev_get_drvdata(dev);
 
 	slu_id = __genwqe_readq(cd, IO_SLU_UNITCFG);
 	app_id = __genwqe_readq(cd, IO_APP_UNITCFG);
 
-	len += scnprintf(&buf[len], PAGE_SIZE - len,
-			 "%016llx.%016llx\n", slu_id, app_id);
-	return len;
+	return scnprintf(buf, PAGE_SIZE, "%016llx.%016llx\n", slu_id, app_id);
 }
 static DEVICE_ATTR_RO(version);
 
 static ssize_t type_show(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
-	ssize_t len = 0;
 	u8 card_type;
 	struct genwqe_dev *cd = dev_get_drvdata(dev);
 
 	card_type = genwqe_card_type(cd);
-	len += scnprintf(&buf[len], PAGE_SIZE - len,
-			 "%s\n", (card_type >= ARRAY_SIZE(genwqe_types)) ?
+	return scnprintf(buf, PAGE_SIZE, "%s\n",
+			 (card_type >= ARRAY_SIZE(genwqe_types)) ?
 			 "invalid" : genwqe_types[card_type]);
-	return len;
 }
 static DEVICE_ATTR_RO(type);
 
 static ssize_t driver_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
-	ssize_t len = 0;
-	len += scnprintf(&buf[len], PAGE_SIZE - len,
-			 "%s\n", DRV_VERS_STRING);
-	return len;
+	return scnprintf(buf, PAGE_SIZE, "%s\n", DRV_VERS_STRING);
 }
 static DEVICE_ATTR_RO(driver);
 
 static ssize_t tempsens_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
-	ssize_t len = 0;
 	u64 tempsens;
 	struct genwqe_dev *cd = dev_get_drvdata(dev);
 
 	tempsens = __genwqe_readq(cd, IO_SLU_TEMPERATURE_SENSOR);
-	len += scnprintf(&buf[len], PAGE_SIZE - len,
-			 "%016llx\n", tempsens);
-	return len;
+	return scnprintf(buf, PAGE_SIZE, "%016llx\n", tempsens);
 }
 static DEVICE_ATTR_RO(tempsens);
 
@@ -131,14 +114,11 @@ static ssize_t base_clock_show(struct device *dev,
 			       struct device_attribute *attr,
 			       char *buf)
 {
-	ssize_t len = 0;
 	u64 base_clock;
 	struct genwqe_dev *cd = dev_get_drvdata(dev);
 
 	base_clock = genwqe_base_clock_frequency(cd);
-	len += scnprintf(&buf[len], PAGE_SIZE - len,
-			 "%lld\n", base_clock);
-	return len;
+	return scnprintf(buf, PAGE_SIZE, "%lld\n", base_clock);
 }
 static DEVICE_ATTR_RO(base_clock);
 
@@ -160,17 +140,13 @@ static DEVICE_ATTR_RO(base_clock);
  * image.
  */
 static ssize_t curr_bitstream_show(struct device *dev,
-				   struct device_attribute *attr,
-				   char *buf)
+				   struct device_attribute *attr, char *buf)
 {
-	ssize_t len = 0;
 	int curr_bitstream;
 	struct genwqe_dev *cd = dev_get_drvdata(dev);
 
 	curr_bitstream = __genwqe_readq(cd, IO_SLU_BITSTREAM) & 0x1;
-	len += scnprintf(&buf[len], PAGE_SIZE - len,
-			 "%d\n", curr_bitstream);
-	return len;
+	return scnprintf(buf, PAGE_SIZE, "%d\n", curr_bitstream);
 }
 static DEVICE_ATTR_RO(curr_bitstream);
 
@@ -180,10 +156,8 @@ static DEVICE_ATTR_RO(curr_bitstream);
  * IO_SLC_CFGREG_SOFTRESET: This register can only be accessed by the PF.
  */
 static ssize_t next_bitstream_show(struct device *dev,
-				   struct device_attribute *attr,
-				   char *buf)
+				   struct device_attribute *attr, char *buf)
 {
-	ssize_t len = 0;
 	int next_bitstream;
 	struct genwqe_dev *cd = dev_get_drvdata(dev);
 
@@ -198,9 +172,7 @@ static ssize_t next_bitstream_show(struct device *dev,
 		next_bitstream = -1;
 		break;		/* error */
 	}
-	len += scnprintf(&buf[len], PAGE_SIZE - len,
-			 "%d\n", next_bitstream);
-	return len;
+	return scnprintf(buf, PAGE_SIZE, "%d\n", next_bitstream);
 }
 
 static ssize_t next_bitstream_store(struct device *dev,
@@ -233,12 +205,9 @@ static DEVICE_ATTR_RW(next_bitstream);
  * FIXME Implement me!
  */
 static ssize_t cpld_version_show(struct device *dev,
-				 struct device_attribute *attr,
-				 char *buf)
+				 struct device_attribute *attr, char *buf)
 {
-	ssize_t len = 0;
-	len += scnprintf(&buf[len], PAGE_SIZE - len, "unknown (FIXME)\n");
-	return len;
+	return scnprintf(buf, PAGE_SIZE, "unknown (FIXME)\n");
 }
 static DEVICE_ATTR_RO(cpld_version);
 
-- 
1.7.1

