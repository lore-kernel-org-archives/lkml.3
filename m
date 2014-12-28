Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaL1QHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 11:07:49 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59794 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaL1QHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 11:07:47 -0500
From: Aniroop Mathur <aniroop.mathur@gmail.com>
To: <jkosina@suse.cz>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: <aniroop.mathur@gmail.com>, <a.mathur@samsung.com>
Subject: [PATCH] hid: Initialize battery_no to -1 & correct its format string
Date: Sun, 28 Dec 2014 21:37:52 +0530
Message-Id: <1419782872-2991-1-git-send-email-aniroop.mathur@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aniroop Mathur <a.mathur@samsung.com>

This patch initializes battery_no to -1 to avoid extra subtraction
operation performed everytime wacom battery is initialized and
correct format string of unsigned long from %ld to %lu.

Signed-off-by: Aniroop Mathur <a.mathur@samsung.com>
---
 drivers/hid/wacom_sys.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 129fd33..4b5ff84 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -919,17 +919,17 @@ static int wacom_ac_get_property(struct power_supply *psy,
 
 static int wacom_initialize_battery(struct wacom *wacom)
 {
-	static atomic_t battery_no = ATOMIC_INIT(0);
+	static atomic_t battery_no = ATOMIC_INIT(-1);
 	int error;
 	unsigned long n;
 
 	if (wacom->wacom_wac.features.quirks & WACOM_QUIRK_BATTERY) {
-		n = atomic_inc_return(&battery_no) - 1;
+		n = atomic_inc_return(&battery_no);
 
 		wacom->battery.properties = wacom_battery_props;
 		wacom->battery.num_properties = ARRAY_SIZE(wacom_battery_props);
 		wacom->battery.get_property = wacom_battery_get_property;
-		sprintf(wacom->wacom_wac.bat_name, "wacom_battery_%ld", n);
+		sprintf(wacom->wacom_wac.bat_name, "wacom_battery_%lu", n);
 		wacom->battery.name = wacom->wacom_wac.bat_name;
 		wacom->battery.type = POWER_SUPPLY_TYPE_BATTERY;
 		wacom->battery.use_for_apm = 0;
@@ -937,7 +937,7 @@ static int wacom_initialize_battery(struct wacom *wacom)
 		wacom->ac.properties = wacom_ac_props;
 		wacom->ac.num_properties = ARRAY_SIZE(wacom_ac_props);
 		wacom->ac.get_property = wacom_ac_get_property;
-		sprintf(wacom->wacom_wac.ac_name, "wacom_ac_%ld", n);
+		sprintf(wacom->wacom_wac.ac_name, "wacom_ac_%lu", n);
 		wacom->ac.name = wacom->wacom_wac.ac_name;
 		wacom->ac.type = POWER_SUPPLY_TYPE_MAINS;
 		wacom->ac.use_for_apm = 0;
-- 
1.9.1

