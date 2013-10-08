Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab3JHCQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:16:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab3JHCQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:16:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>, <linux-spi@vger.kernel.org>
Subject: [PATCH 4/8] spi: convert bus code to use dev_groups
Date: Mon,  7 Oct 2013 18:27:38 -0700
Message-Id: <1381195662-28009-5-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
References: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the spi bus code to use the
correct field.

Cc: Mark Brown <broonie@kernel.org>
Cc: <linux-spi@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Mark, I can take this through my driver-core tree if you don't want to
take it through yours, just let me know what works best for you.

 drivers/spi/spi.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 9e039c6..541c93a 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -58,11 +58,13 @@ modalias_show(struct device *dev, struct device_attribute *a, char *buf)
 
 	return sprintf(buf, "%s%s\n", SPI_MODULE_PREFIX, spi->modalias);
 }
+static DEVICE_ATTR_RO(modalias);
 
-static struct device_attribute spi_dev_attrs[] = {
-	__ATTR_RO(modalias),
-	__ATTR_NULL,
+static struct attribute *spi_dev_attrs[] = {
+	&dev_attr_modalias.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(spi_dev);
 
 /* modalias support makes "modprobe $MODALIAS" new-style hotplug work,
  * and the sysfs version makes coldplug work too.
@@ -229,7 +231,7 @@ static const struct dev_pm_ops spi_pm = {
 
 struct bus_type spi_bus_type = {
 	.name		= "spi",
-	.dev_attrs	= spi_dev_attrs,
+	.dev_groups	= spi_dev_groups,
 	.match		= spi_match_device,
 	.uevent		= spi_uevent,
 	.pm		= &spi_pm,
-- 
1.8.4.6.g82e253f.dirty

