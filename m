Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab3ECGhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:37:00 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:30216
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932264Ab3ECGfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:35:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH 2/4] mtd: add a new sys node to show the ecc step size
Date: Fri, 3 May 2013 14:21:42 +0800
Message-ID: <1367562104-8955-3-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367562104-8955-1-git-send-email-b32955@freescale.com>
References: <1367562104-8955-1-git-send-email-b32955@freescale.com>
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
index e513fc4..2ed2827 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -287,6 +287,16 @@ static DEVICE_ATTR(bitflip_threshold, S_IRUGO | S_IWUSR,
 		   mtd_bitflip_threshold_show,
 		   mtd_bitflip_threshold_store);
 
+static ssize_t mtd_ecc_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", (unsigned long)mtd->ecc_size);
+
+}
+static DEVICE_ATTR(ecc_size, S_IRUGO, mtd_ecc_size_show, NULL);
+
 static struct attribute *mtd_attrs[] = {
 	&dev_attr_type.attr,
 	&dev_attr_flags.attr,
@@ -298,6 +308,7 @@ static struct attribute *mtd_attrs[] = {
 	&dev_attr_numeraseregions.attr,
 	&dev_attr_name.attr,
 	&dev_attr_ecc_strength.attr,
+	&dev_attr_ecc_size.attr,
 	&dev_attr_bitflip_threshold.attr,
 	NULL,
 };
-- 
1.7.1


