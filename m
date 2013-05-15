Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab3EOJCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:02:47 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:25501
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699Ab3EOJCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:02:45 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH v2 2/4] mtd: add a new sys node to show the ecc step size
Date: Wed, 15 May 2013 16:46:44 +0800
Message-ID: <1368607606-4344-3-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368607606-4344-1-git-send-email-b32955@freescale.com>
References: <1368607606-4344-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new sys node to show the ecc step size.
The application then can uses this node to get the ecc step
size.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/mtdcore.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index c400c57..63903b9 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -285,6 +285,16 @@ static DEVICE_ATTR(bitflip_threshold, S_IRUGO | S_IWUSR,
 		   mtd_bitflip_threshold_show,
 		   mtd_bitflip_threshold_store);
 
+static ssize_t mtd_ecc_step_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", (unsigned long)mtd->ecc_step);
+
+}
+static DEVICE_ATTR(ecc_step, S_IRUGO, mtd_ecc_step_show, NULL);
+
 static struct attribute *mtd_attrs[] = {
 	&dev_attr_type.attr,
 	&dev_attr_flags.attr,
@@ -296,6 +306,7 @@ static struct attribute *mtd_attrs[] = {
 	&dev_attr_numeraseregions.attr,
 	&dev_attr_name.attr,
 	&dev_attr_ecc_strength.attr,
+	&dev_attr_ecc_step.attr,
 	&dev_attr_bitflip_threshold.attr,
 	NULL,
 };
-- 
1.7.1


