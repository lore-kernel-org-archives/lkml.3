Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab3EHNaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:30:25 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50388 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3EHNaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:30:22 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 9/9] mfd: ab8500-core: Pass GPADC compatible string to MFD core
Date: Wed,  8 May 2013 14:29:09 +0100
Message-Id: <1368019749-19455-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting with Device Tree enabled the MFD core uses each device's
compatible string to find and allocate its associated of_node pointer,
which in turn is passed to the driver via the platform_device struct.
Without it, the driver won't be able to interrogate the Device Tree or
locate suitable regulators and will most likely fail to probe.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 2047485..983eb1e 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1060,6 +1060,7 @@ static struct mfd_cell ab8500_devs[] = {
 	},
 	{
 		.name = "ab8500-gpadc",
+		.of_compatible = "stericsson,ab8500-gpadc",
 		.num_resources = ARRAY_SIZE(ab8500_gpadc_resources),
 		.resources = ab8500_gpadc_resources,
 	},
@@ -1217,6 +1218,7 @@ static struct mfd_cell ab8505_devs[] = {
 	},
 	{
 		.name = "ab8500-gpadc",
+		.of_compatible = "stericsson,ab8500-gpadc",
 		.num_resources = ARRAY_SIZE(ab8505_gpadc_resources),
 		.resources = ab8505_gpadc_resources,
 	},
@@ -1280,6 +1282,7 @@ static struct mfd_cell ab8540_devs[] = {
 	},
 	{
 		.name = "ab8500-gpadc",
+		.of_compatible = "stericsson,ab8500-gpadc",
 		.num_resources = ARRAY_SIZE(ab8505_gpadc_resources),
 		.resources = ab8505_gpadc_resources,
 	},
-- 
1.7.10.4

