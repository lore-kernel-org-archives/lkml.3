Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaA0AFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 19:05:38 -0500
Received: from mail-gg0-f175.google.com ([209.85.161.175]:42801 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaA0AFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 19:05:36 -0500
From: Thiago Farina <tfarina@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sbkim73@samsung.com
Subject: [PATCH] regulator: Make use of rdev_get_id() function where possible.
Date: Sun, 26 Jan 2014 21:57:12 -0200
Message-Id: <1390780632-12798-1-git-send-email-tfarina@chromium.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thiago Farina <tfarina@chromium.org>
---
 drivers/regulator/pfuze100-regulator.c |    2 +-
 drivers/regulator/s2mps11.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 8b5e4c7..6a839a2 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -92,7 +92,7 @@ MODULE_DEVICE_TABLE(of, pfuze_dt_ids);
 static int pfuze100_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 {
 	struct pfuze_chip *pfuze100 = rdev_get_drvdata(rdev);
-	int id = rdev->desc->id;
+	int id = rdev_get_id(rdev);
 	unsigned int ramp_bits;
 	int ret;
 
diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 9e61922..0d9eac5 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -65,7 +65,7 @@ static int s2mps11_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 	unsigned int ramp_delay = 0;
 	int old_volt, new_volt;
 
-	switch (rdev->desc->id) {
+	switch (rdev_get_id(rdev)) {
 	case S2MPS11_BUCK2:
 		ramp_delay = s2mps11->ramp_delay2;
 		break;
@@ -107,7 +107,7 @@ static int s2mps11_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 	unsigned int ramp_enable = 1, enable_shift = 0;
 	int ret;
 
-	switch (rdev->desc->id) {
+	switch (rdev_get_id(rdev)) {
 	case S2MPS11_BUCK1:
 		if (ramp_delay > s2mps11->ramp_delay16)
 			s2mps11->ramp_delay16 = ramp_delay;
-- 
1.7.9.5

