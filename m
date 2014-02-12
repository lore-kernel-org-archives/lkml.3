Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaBLI2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:28:42 -0500
Received: from nm1.bullet.mail.gq1.yahoo.com ([98.136.218.75]:44693 "EHLO
	nm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041AbaBLI2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:28:40 -0500
X-Yahoo-Newman-Id: 236129.42767.bm@smtp229.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: p5VzswIVM1lVte56IfiStFHiuHoWEs77bNZW50Gv_YSoneJ
 ATMACgjs4NcxUjUE8.LyWUVwo99bx2xJL2QWaFMiTuzZ8N8K9cV1iEE2Y1Ww
 qutIZDbYuLYVKlPaVV1nC_bIbLiw1CRGyB6Zw4pa2HWNFmx90ryYadHFoiuJ
 UjO_lIZdiXcl6lKs_Jc.Wey43dDMkrQ7G4OU.cWTYBMPzgZJLMy1aWOfgsP_
 HvKZexReWn.BQwDUuJDMBNr6P_Yyq_gCuTmcDloPv8FoGAl2ZGiih7Ebyi8x
 rAuhlOD9YF4A2vGQW7MySwLvhQiOWo59bRsIu3Np8crxsli8.ZMyV932Acy8
 Q_NJ62JUns2L2U.hzOKwKkHm7lnb9eIIqe8oGjOfLzktwYLRuY8GlMglOSs6
 t6exqyP9EMbbj_B00ramOLihqN4NkvVoPQhGjVgJ2nj8KISUXU9HAXpWJl0u
 P5NHVrGaMnYaqD1IztEWjd0BKMdnrtRCNLLhpgLuKU950EQrgoAcJqBZkIpc
 5i5YEyHFVyN5kk5azk8J6Dn3Ivh0eWUCe.xGi4_gmr_wIv8uY
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.139.211.125])
        by smtp229.mail.gq1.yahoo.com with SMTP; 12 Feb 2014 08:28:40 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH] Staging: comedi: Correct a few printf format codes
Date: Wed, 12 Feb 2014 02:28:35 -0600
Message-Id: <1392193715-29467-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My static checker found some slightly inaccurate format codes in printf
calls in comedi_fops.c and drivers/comedi_bond.c.  It may be slightly
pedantic to change them, but using the correctly corresponding format
codes is probably a good idea.  All but one were unsigned ints that were
formatted with %i, change these to %u, and one was an int formatted with
%u, we want to format this with %d.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/comedi_fops.c         | 8 ++++----
 drivers/staging/comedi/drivers/comedi_bond.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index c22c617..b36b760 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -297,7 +297,7 @@ static ssize_t max_read_buffer_kb_show(struct device *csdev,
 	mutex_unlock(&dev->mutex);
 
 	comedi_dev_put(dev);
-	return snprintf(buf, PAGE_SIZE, "%i\n", size);
+	return snprintf(buf, PAGE_SIZE, "%u\n", size);
 }
 
 static ssize_t max_read_buffer_kb_store(struct device *csdev,
@@ -353,7 +353,7 @@ static ssize_t read_buffer_kb_show(struct device *csdev,
 	mutex_unlock(&dev->mutex);
 
 	comedi_dev_put(dev);
-	return snprintf(buf, PAGE_SIZE, "%i\n", size);
+	return snprintf(buf, PAGE_SIZE, "%u\n", size);
 }
 
 static ssize_t read_buffer_kb_store(struct device *csdev,
@@ -410,7 +410,7 @@ static ssize_t max_write_buffer_kb_show(struct device *csdev,
 	mutex_unlock(&dev->mutex);
 
 	comedi_dev_put(dev);
-	return snprintf(buf, PAGE_SIZE, "%i\n", size);
+	return snprintf(buf, PAGE_SIZE, "%u\n", size);
 }
 
 static ssize_t max_write_buffer_kb_store(struct device *csdev,
@@ -466,7 +466,7 @@ static ssize_t write_buffer_kb_show(struct device *csdev,
 	mutex_unlock(&dev->mutex);
 
 	comedi_dev_put(dev);
-	return snprintf(buf, PAGE_SIZE, "%i\n", size);
+	return snprintf(buf, PAGE_SIZE, "%u\n", size);
 }
 
 static ssize_t write_buffer_kb_store(struct device *csdev,
diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 406aedb..8450c99 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -211,7 +211,7 @@ static int do_dev_config(struct comedi_device *dev, struct comedi_devconfig *it)
 			return -EINVAL;
 		}
 
-		snprintf(file, sizeof(file), "/dev/comedi%u", minor);
+		snprintf(file, sizeof(file), "/dev/comedi%d", minor);
 		file[sizeof(file) - 1] = 0;
 
 		d = comedi_open(file);
@@ -264,7 +264,7 @@ static int do_dev_config(struct comedi_device *dev, struct comedi_devconfig *it)
 				char buf[20];
 				int left =
 				    MAX_BOARD_NAME - strlen(devpriv->name) - 1;
-				snprintf(buf, sizeof(buf), "%d:%d ",
+				snprintf(buf, sizeof(buf), "%u:%u ",
 					 bdev->minor, bdev->subdev);
 				buf[sizeof(buf) - 1] = 0;
 				strncat(devpriv->name, buf, left);
-- 
1.8.5.3

