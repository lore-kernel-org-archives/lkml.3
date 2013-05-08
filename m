Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3EHNaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:30:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40904 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab3EHNaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:30:06 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 2/9] mfd: ab8500-core: Use the correct driver name when enabling gpio/pinctrl
Date: Wed,  8 May 2013 14:29:02 +0100
Message-Id: <1368019749-19455-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we're using Device Tree to enable GPIO drivers we're forced to be
OS agnostic, thus we are forbidden use names like pinctrl as they are
specific only to Linux. However, when we are registering devices using
internal systems such as MFD or platform registration, we can use such
terminology. In this case we can and should use the platform device ID
mechanism to specify which device we wish to utilise by detailing
pinctrl-<device_name>.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 42abd3a..2047485 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1106,7 +1106,7 @@ static struct mfd_cell ab8500_devs[] = {
 		.of_compatible = "stericsson,ab8500-denc",
 	},
 	{
-		.name = "ab8500-gpio",
+		.name = "pinctrl-ab8500",
 		.of_compatible = "stericsson,ab8500-gpio",
 	},
 	{
@@ -1243,7 +1243,7 @@ static struct mfd_cell ab8505_devs[] = {
 		.name = "ab8500-leds",
 	},
 	{
-		.name = "ab8500-gpio",
+		.name = "pinctrl-ab8505",
 	},
 	{
 		.name = "ab8500-usb",
@@ -1311,7 +1311,7 @@ static struct mfd_cell ab8540_devs[] = {
 		.resources = ab8500_temp_resources,
 	},
 	{
-		.name = "ab8500-gpio",
+		.name = "pinctrl-ab8540",
 	},
 	{
 		.name = "ab8540-usb",
-- 
1.7.10.4

