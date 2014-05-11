Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbaEKNAa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 09:00:30 -0400
Received: from we2-f167.wedos.net ([46.28.105.74]:55362 "EHLO
	we2-f167.wedos.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226AbaEKNA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 09:00:28 -0400
Date: Sun, 11 May 2014 15:00:23 +0200
From: Josef Gajdusek <atx@atx.name>
To: jdelvare@suse.de
Cc: linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/hwmon/emc1403.c: add support for emc1412
Message-ID: <20140511130023.GA501@dashie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for emc1412.

---
diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 90ec117..47a98a7 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -40,7 +40,7 @@
 
 struct thermal_data {
 	struct i2c_client *client;
-	const struct attribute_group *groups[3];
+	const struct attribute_group *groups[2];
 	struct mutex mutex;
 	/*
 	 * Cache the hyst value so we don't keep re-reading it. In theory
@@ -252,6 +252,28 @@ static SENSOR_DEVICE_ATTR(temp4_crit_hyst, S_IRUGO | S_IWUSR,
 static SENSOR_DEVICE_ATTR_2(power_state, S_IRUGO | S_IWUSR,
 	show_bit, store_bit, 0x03, 0x40);
 
+
+static struct attribute *emc1412_attrs[] = {
+	&sensor_dev_attr_temp1_min.dev_attr.attr,
+	&sensor_dev_attr_temp1_max.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit.dev_attr.attr,
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit_hyst.dev_attr.attr,
+
+	&sensor_dev_attr_temp2_min.dev_attr.attr,
+	&sensor_dev_attr_temp2_max.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit.dev_attr.attr,
+	&sensor_dev_attr_temp2_input.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit_hyst.dev_attr.attr,
+
+	&sensor_dev_attr_power_state.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group emc1412_group = {
+		.attrs = emc1412_attrs,
+};
+
 static struct attribute *emc1403_attrs[] = {
 	&sensor_dev_attr_temp1_min.dev_attr.attr,
 	&sensor_dev_attr_temp1_max.dev_attr.attr,
@@ -261,6 +283,7 @@ static struct attribute *emc1403_attrs[] = {
 	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp1_crit_hyst.dev_attr.attr,
+
 	&sensor_dev_attr_temp2_min.dev_attr.attr,
 	&sensor_dev_attr_temp2_max.dev_attr.attr,
 	&sensor_dev_attr_temp2_crit.dev_attr.attr,
@@ -269,6 +292,7 @@ static struct attribute *emc1403_attrs[] = {
 	&sensor_dev_attr_temp2_max_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp2_crit_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp2_crit_hyst.dev_attr.attr,
+
 	&sensor_dev_attr_temp3_min.dev_attr.attr,
 	&sensor_dev_attr_temp3_max.dev_attr.attr,
 	&sensor_dev_attr_temp3_crit.dev_attr.attr,
@@ -277,6 +301,7 @@ static struct attribute *emc1403_attrs[] = {
 	&sensor_dev_attr_temp3_max_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp3_crit_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp3_crit_hyst.dev_attr.attr,
+
 	&sensor_dev_attr_power_state.dev_attr.attr,
 	NULL
 };
@@ -286,6 +311,33 @@ static const struct attribute_group emc1403_group = {
 };
 
 static struct attribute *emc1404_attrs[] = {
+	&sensor_dev_attr_temp1_min.dev_attr.attr,
+	&sensor_dev_attr_temp1_max.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit.dev_attr.attr,
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit_hyst.dev_attr.attr,
+
+	&sensor_dev_attr_temp2_min.dev_attr.attr,
+	&sensor_dev_attr_temp2_max.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit.dev_attr.attr,
+	&sensor_dev_attr_temp2_input.dev_attr.attr,
+	&sensor_dev_attr_temp2_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_max_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit_hyst.dev_attr.attr,
+
+	&sensor_dev_attr_temp3_min.dev_attr.attr,
+	&sensor_dev_attr_temp3_max.dev_attr.attr,
+	&sensor_dev_attr_temp3_crit.dev_attr.attr,
+	&sensor_dev_attr_temp3_input.dev_attr.attr,
+	&sensor_dev_attr_temp3_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp3_max_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp3_crit_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp3_crit_hyst.dev_attr.attr,
+
 	&sensor_dev_attr_temp4_min.dev_attr.attr,
 	&sensor_dev_attr_temp4_max.dev_attr.attr,
 	&sensor_dev_attr_temp4_crit.dev_attr.attr,
@@ -294,6 +346,8 @@ static struct attribute *emc1404_attrs[] = {
 	&sensor_dev_attr_temp4_max_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp4_crit_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp4_crit_hyst.dev_attr.attr,
+
+	&sensor_dev_attr_power_state.dev_attr.attr,
 	NULL
 };
 
@@ -301,11 +355,13 @@ static const struct attribute_group emc1404_group = {
 	.attrs = emc1404_attrs,
 };
 
+
+
 static int emc1403_detect(struct i2c_client *client,
 			struct i2c_board_info *info)
 {
 	int id;
-	/* Check if thermal chip is SMSC and EMC1403 or EMC1423 */
+	/* Check whether the chip is SMSC and get its type */
 
 	id = i2c_smbus_read_byte_data(client, THERMAL_SMSC_ID_REG);
 	if (id != 0x5d)
@@ -313,6 +369,9 @@ static int emc1403_detect(struct i2c_client *client,
 
 	id = i2c_smbus_read_byte_data(client, THERMAL_PID_REG);
 	switch (id) {
+	case 0x20:
+		strlcpy(info->type, "emc1412", I2C_NAME_SIZE);
+		break;
 	case 0x21:
 		strlcpy(info->type, "emc1403", I2C_NAME_SIZE);
 		break;
@@ -330,9 +389,9 @@ static int emc1403_detect(struct i2c_client *client,
 	}
 
 	id = i2c_smbus_read_byte_data(client, THERMAL_REVISION_REG);
-	if (id != 0x01)
+	if (id != 0x01 && id != 0x04) {
 		return -ENODEV;
-
+	}
 	return 0;
 }
 
@@ -351,9 +410,17 @@ static int emc1403_probe(struct i2c_client *client,
 	mutex_init(&data->mutex);
 	data->hyst_valid = jiffies - 1;		/* Expired */
 
-	data->groups[0] = &emc1403_group;
-	if (id->driver_data)
-		data->groups[1] = &emc1404_group;
+	switch (id->driver_data) {
+	case 0:
+		data->groups[0] = &emc1412_group;
+		break;
+	case 1:
+		data->groups[0] = &emc1403_group;
+		break;
+	case 2:
+		data->groups[0] = &emc1404_group;
+		break;
+	}
 
 	hwmon_dev = hwmon_device_register_with_groups(&client->dev,
 						      client->name, data,
@@ -366,14 +433,19 @@ static int emc1403_probe(struct i2c_client *client,
 }
 
 static const unsigned short emc1403_address_list[] = {
-	0x18, 0x29, 0x4c, 0x4d, I2C_CLIENT_END
+	/* emc1403/emc1404/emc1423/emc1424 */
+	0x4c, 0x4d, 0x18, 0x29,
+	/* emc1412 */
+	0x5c, 0x4c, 0x6c, 0x1c, 0x3c, I2C_CLIENT_END
 };
 
+/* Last number in name indicates the amount of channels */
 static const struct i2c_device_id emc1403_idtable[] = {
-	{ "emc1403", 0 },
-	{ "emc1404", 1 },
-	{ "emc1423", 0 },
-	{ "emc1424", 1 },
+	{ "emc1412", 0 },
+	{ "emc1403", 1 },
+	{ "emc1423", 1 },
+	{ "emc1404", 2 },
+	{ "emc1424", 2 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, emc1403_idtable);

