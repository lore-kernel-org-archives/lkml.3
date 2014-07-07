Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaGGQFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 12:05:52 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:59647 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaGGQFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 12:05:50 -0400
From: Pawel Lebioda <pawel.lebioda89@gmail.com>
To: Julian Andres Klode <jak@jak-linux.org>, Marc Dietrich <marvin24@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, ac100@lists.launchpad.net,
        linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: nvec: add missing blank line after declarations
Date: Mon,  7 Jul 2014 18:05:41 +0200
Message-Id: <1404749141-3943-1-git-send-email-pawel.lebioda89@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 'missing blank line after declaration' warnings reported by checkpatch.pl.
Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>
---
 drivers/staging/nvec/nvec_paz00.c | 1 +
 drivers/staging/nvec/nvec_power.c | 1 +
 drivers/staging/nvec/nvec_ps2.c   | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/drivers/staging/nvec/nvec_paz00.c b/drivers/staging/nvec/nvec_paz00.c
index 934b796..e2e675a 100644
--- a/drivers/staging/nvec/nvec_paz00.c
+++ b/drivers/staging/nvec/nvec_paz00.c
@@ -35,6 +35,7 @@ static void nvec_led_brightness_set(struct led_classdev *led_cdev,
 {
 	struct nvec_led *led = to_nvec_led(led_cdev);
 	unsigned char buf[] = NVEC_LED_REQ;
+
 	buf[4] = value;
 
 	nvec_write_async(led->nvec, buf, sizeof(buf));
diff --git a/drivers/staging/nvec/nvec_power.c b/drivers/staging/nvec/nvec_power.c
index aacfcd6..6446e15 100644
--- a/drivers/staging/nvec/nvec_power.c
+++ b/drivers/staging/nvec/nvec_power.c
@@ -226,6 +226,7 @@ static int nvec_power_get_property(struct power_supply *psy,
 				   union power_supply_propval *val)
 {
 	struct nvec_power *power = dev_get_drvdata(psy->dev->parent);
+
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
 		val->intval = power->on;
diff --git a/drivers/staging/nvec/nvec_ps2.c b/drivers/staging/nvec/nvec_ps2.c
index 45b2f13..f56f1db 100644
--- a/drivers/staging/nvec/nvec_ps2.c
+++ b/drivers/staging/nvec/nvec_ps2.c
@@ -53,12 +53,14 @@ static struct nvec_ps2 ps2_dev;
 static int ps2_startstreaming(struct serio *ser_dev)
 {
 	unsigned char buf[] = { NVEC_PS2, AUTO_RECEIVE_N, PACKET_SIZE };
+
 	return nvec_write_async(ps2_dev.nvec, buf, sizeof(buf));
 }
 
 static void ps2_stopstreaming(struct serio *ser_dev)
 {
 	unsigned char buf[] = { NVEC_PS2, CANCEL_AUTO_RECEIVE };
+
 	nvec_write_async(ps2_dev.nvec, buf, sizeof(buf));
 }
 
-- 
1.8.3.2

