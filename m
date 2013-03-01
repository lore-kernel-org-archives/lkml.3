Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab3CAK6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 05:58:51 -0500
Received: from mx2.promwad.com ([91.149.128.90]:9045 "EHLO mx2.promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab3CAK6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 05:58:51 -0500
From: Michail Kurachkin <michail.kurachkin@promwad.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>,
        Dmitriy Gorokh <dmitriy.gorokh@promwad.com>,
        Oliver Neukum <oneukum@suse.de>, Ryan Mallon <rmallon@gmail.com>
CC: Michail Kurachkin <michail.kurachkin@promwad.com>
Subject: [PATCH v2 06/11] staging: remove device_attribute
Date: Fri, 1 Mar 2013 13:58:39 +0300
Message-ID: <6573ab87fa11f244dcda6a53a303eb447768a82a.1362133319.git.michail.kurachkin@promwad.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1362133319.git.michail.kurachkin@promwad.com>
References: <cover.1362133319.git.michail.kurachkin@promwad.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michail Kurachkin <michail.kurachkin@promwad.com>
---
 drivers/staging/tdm/tdm_core.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/tdm/tdm_core.c b/drivers/staging/tdm/tdm_core.c
index f3ac6fc..cf8c26a 100644
--- a/drivers/staging/tdm/tdm_core.c
+++ b/drivers/staging/tdm/tdm_core.c
@@ -50,20 +50,6 @@ static void tdmdev_release(struct device *dev)
         kfree(tdm_dev);
 }
 
-static ssize_t
-modalias_show(struct device *dev, struct device_attribute *a, char *buf)
-{
-        const struct tdm_device *tdm_dev = to_tdm_device(dev);
-
-        return sprintf(buf, "%s\n", tdm_dev->modalias);
-}
-
-static struct device_attribute tdm_dev_attrs[] = {
-        __ATTR_RO(modalias),
-        __ATTR_NULL,
-};
-
-
 static int tdm_match_device(struct device *dev, struct device_driver *drv)
 {
         const struct tdm_device *tdm_dev = to_tdm_device(dev);
@@ -104,7 +90,7 @@ static struct class tdm_class = {
  */
 struct bus_type tdm_bus_type = {
         .name           = "tdm",
-        .dev_attrs      = tdm_dev_attrs,
+        .dev_attrs      = NULL,
         .match          = tdm_match_device,
         .uevent         = tdm_uevent,
         .suspend        = NULL,
-- 
1.7.5.4

