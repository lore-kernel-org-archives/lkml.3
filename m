Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab3JUIsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:48:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26895 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab3JUIsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:48:38 -0400
X-AuditID: cbfee68d-b7fa16d0000029b0-06-5264ea630447
From: =?ks_c_5601-1987?B?s7Kw/L/s?= <kw46.nam@samsung.com>
To: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Cc: kw46.nam@samsung.com, kyungmin.park@samsung.com
Subject: [PATCH] Fuel Guague: MAX17040: Use regmap to interface with internal
 registers
Date: Mon, 21 Oct 2013 17:48:35 +0900
Message-id: <002101cece3a$53eeff80$fbccfe80$%nam@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7OOlPO2ttuMFszQL+0ghQB19v5nw==
Content-language: ko
X-OriginalArrivalTime: 21 Oct 2013 08:48:35.0139 (UTC)
 FILETIME=[53E6E930:01CECE3A]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t8zPd3kVylBBitOy1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M/rftjAV7FSta7q1hamB8It3FyMEhIWAiMbvDv4uRE8gUk7hw
	bz1bFyMXh5DAMkaJvnuHmCESJhKNTctYIBKLGCV29axih3D2M0nsfLmGEa7l7fMjTCAtbAJW
	EtNnzmABsUUEnCVun98ONopZwFji4tw57CC2sECkxP9Fb8BqWARUJS5ufwJm8wrYSrTevMIM
	YQtK/Jh8jwWi10Di/aw+VghbXmLzmrfMEC+oSzz6qwuxSk/i44NONogSEYl9L94xgthCAsoS
	3/esZIH4JlRiyp+jTCA3SwisYpc4cnoLM8QNAhLfJh9igZgpK7HpANT3khIHV9xgmcAoOQvJ
	RbOQXDQLyUWzkKxewMiyilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMk5np3MN4+YH2IMRlo
	/URmKdHkfGDM5pXEGxqbGVmYmpgaG5lbmpEmrCTOm/QwKUhIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QDI7PHzVX/Dl/csWRPpKNumY/Vhdlhdxym9O2++yUm/5vcpp9bmDXfvHm69cIBodsT
	Te+cKP9yYXk3k7L7Lu5q17f/n98qf5TGUKexaMZ34wU3nC3u3PK6YxrK0Ownuf+seLbdA5uJ
	j/+0vmwREVPqO7B+5hOR/xxtaXzZTIz/txuJSWccPXzHkl+JpTgj0VCLuag4EQD65Wm0zwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jAd3kVylBBl8+SFtc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjP637YwFexUrWu6tYWpg
	fCLdxcjJISFgItHYtIwFwhaTuHBvPVsXIxeHkMAiRoldPavYIZz9TBI7X65hhHCWMUq8fX6E
	CaSFTcBKYvrMGWDtIgLOErfPb2cGsZkFjCUuzp3DDmILC0RK/F/0BqyGRUBV4uL2J2A2r4Ct
	ROvNK8wQtqDEj8n3WCB6DSTez+pjhbDlJTaveQtUwwF0nrrEo7+6EKv0JD4+6GSDKBGR2Pfi
	HSOILSSgLPF9z0qob0Ilpvw5yjSBUXgWkg2zkGyYhWTDLCSjFjCyrGIUTS1ILihOSs810itO
	zC0uzUvXS87P3cQIjuln0jsYVzVYHGIU4GBU4uENcEkJEmJNLCuuzD3EKMHBrCTCO2cBUIg3
	JbGyKrUoP76oNCe1+BBjMjAAJjJLiSbnA9NNXkm8obGJmZGlkZmxibmxMWnCSuK8B1utA4UE
	0hNLUrNTUwtSi2C2MHFwSjUwejIfNn28L+JnQv2JUNHVVXN62plEBa6U7rh1zGPxovkf7i6J
	7E/XVPS+Mc2xVWtnRWBSafy7RRVfj8nIb5f2Vv7yMWKxsxBHw4arEk8PnWLfaSufe/R+XiW/
	/ufDXiwcO90+5HRsM/y5ePMG/8Ap3zMfZD3XfPHpm9U7Z6nT87N/dbYZfVwfpMRSnJFoqMVc
	VJwIALZEeLstAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use regmap to interface with internal registers in fuel guague MAX17040.

Signed-off-by: Nam KwanWoo <kw46.nam@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/max17040_battery.c |   71 +++++++++++++++++------------------
---
 1 file changed, 32 insertions(+), 39 deletions(-)

diff --git a/drivers/power/max17040_battery.c
b/drivers/power/max17040_battery.c
index 7f08d69..a1601b4 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -20,6 +20,7 @@
 #include <linux/power_supply.h>
 #include <linux/max17040_battery.h>
 #include <linux/slab.h>
+#include <linux/regmap.h>
 
 #define MAX17040_VCELL_MSB	0x02
 #define MAX17040_VCELL_LSB	0x03
@@ -39,6 +40,7 @@
 
 struct max17040_chip {
 	struct i2c_client		*client;
+	struct regmap			*regmap;
 	struct delayed_work		work;
 	struct power_supply		battery;
 	struct max17040_platform_data	*pdata;
@@ -79,44 +81,22 @@ static int max17040_get_property(struct power_supply
*psy,
 	return 0;
 }
 
-static int max17040_write_reg(struct i2c_client *client, int reg, u8 value)
-{
-	int ret;
-
-	ret = i2c_smbus_write_byte_data(client, reg, value);
-
-	if (ret < 0)
-		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
-
-	return ret;
-}
-
-static int max17040_read_reg(struct i2c_client *client, int reg)
-{
-	int ret;
-
-	ret = i2c_smbus_read_byte_data(client, reg);
-
-	if (ret < 0)
-		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
-
-	return ret;
-}
-
 static void max17040_reset(struct i2c_client *client)
 {
-	max17040_write_reg(client, MAX17040_CMD_MSB, 0x54);
-	max17040_write_reg(client, MAX17040_CMD_LSB, 0x00);
+	struct max17040_chip *chip = i2c_get_clientdata(client);
+
+	regmap_write(chip->regmap, MAX17040_CMD_MSB, 0x54);
+	regmap_write(chip->regmap, MAX17040_CMD_LSB, 0x00);
 }
 
 static void max17040_get_vcell(struct i2c_client *client)
 {
 	struct max17040_chip *chip = i2c_get_clientdata(client);
-	u8 msb;
-	u8 lsb;
+	u32 msb;
+	u32 lsb;
 
-	msb = max17040_read_reg(client, MAX17040_VCELL_MSB);
-	lsb = max17040_read_reg(client, MAX17040_VCELL_LSB);
+	regmap_read(chip->regmap, MAX17040_VCELL_MSB, &msb);
+	regmap_read(chip->regmap, MAX17040_VCELL_LSB, &lsb);
 
 	chip->vcell = (msb << 4) + (lsb >> 4);
 }
@@ -124,22 +104,23 @@ static void max17040_get_vcell(struct i2c_client
*client)
 static void max17040_get_soc(struct i2c_client *client)
 {
 	struct max17040_chip *chip = i2c_get_clientdata(client);
-	u8 msb;
-	u8 lsb;
+	u32 msb;
+	u32 lsb;
 
-	msb = max17040_read_reg(client, MAX17040_SOC_MSB);
-	lsb = max17040_read_reg(client, MAX17040_SOC_LSB);
+	regmap_read(chip->regmap, MAX17040_SOC_MSB, &msb);
+	regmap_read(chip->regmap, MAX17040_SOC_LSB, &lsb);
 
 	chip->soc = msb;
 }
 
 static void max17040_get_version(struct i2c_client *client)
 {
-	u8 msb;
-	u8 lsb;
+	struct max17040_chip *chip = i2c_get_clientdata(client);
+	u32 msb;
+	u32 lsb;
 
-	msb = max17040_read_reg(client, MAX17040_VER_MSB);
-	lsb = max17040_read_reg(client, MAX17040_VER_LSB);
+	regmap_read(chip->regmap, MAX17040_VER_MSB, &msb);
+	regmap_read(chip->regmap, MAX17040_VER_LSB, &lsb);
 
 	dev_info(&client->dev, "MAX17040 Fuel-Gauge Ver %d%d\n", msb, lsb);
 }
@@ -197,12 +178,18 @@ static enum power_supply_property
max17040_battery_props[] = {
 	POWER_SUPPLY_PROP_CAPACITY,
 };
 
+static struct regmap_config max17040_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.val_format_endian = REGMAP_ENDIAN_NATIVE,
+};
+
 static int max17040_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct max17040_chip *chip;
-	int ret;
+	u32 ret;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE))
 		return -EIO;
@@ -212,6 +199,12 @@ static int max17040_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	chip->client = client;
+	chip->regmap = devm_regmap_init_i2c(client,
&max17040_regmap_config);
+	if (IS_ERR(chip->regmap)) {
+		dev_err(&client->dev, "Failed to initialize regmap\n");
+		return -EINVAL;
+	}
+
 	chip->pdata = client->dev.platform_data;
 
 	if (!chip->pdata) {
-- 
1.7.9.5

