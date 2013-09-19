Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3ISJTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:19:20 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:42346 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3ISJTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:19:19 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: rt5640: Omit ACPI match table only if !ACPI
Date: Thu, 19 Sep 2013 11:18:06 +0200
Message-Id: <1379582286-10600-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI_PTR() macro evaluates to NULL if ACPI is disabled and hence the
ACPI match table won't be used, causing the compiler to complain. Avoid
this by protecting the table using an #ifdef CONFIG_ACPI.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 sound/soc/codecs/rt5640.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index 0bfb960..641eeeb 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2082,11 +2082,13 @@ static const struct i2c_device_id rt5640_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, rt5640_i2c_id);
 
+#ifdef CONFIG_ACPI
 static struct acpi_device_id rt5640_acpi_match[] = {
 	{ "INT33CA", 0 },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, rt5640_acpi_match);
+#endif
 
 static int rt5640_parse_dt(struct rt5640_priv *rt5640, struct device_node *np)
 {
-- 
1.8.4

