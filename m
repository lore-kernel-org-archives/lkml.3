Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaLSB57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:57:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:35924 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbaLSB55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:57:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,604,1413270000"; 
   d="scan'208";a="626330256"
Date: Fri, 19 Dec 2014 09:56:59 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: kbuild-all@01.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH hisi] Input: i2c_atmel_read() can be static
Message-ID: <20141219015659.GA49367@snb.sh.intel.com>
References: <201412190926.IzkyYvvl%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201412190926.IzkyYvvl%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/input/touchscreen/atmel_mXT224E.c:460:5: sparse: symbol 'i2c_atmel_read' was not declared. Should it be static?
drivers/input/touchscreen/atmel_mXT224E.c:496:5: sparse: symbol 'i2c_atmel_write' was not declared. Should it be static?
drivers/input/touchscreen/atmel_mXT224E.c:532:5: sparse: symbol 'i2c_atmel_write_byte_data' was not declared. Should it be static?
drivers/input/touchscreen/atmel_mXT224E.c:538:10: sparse: symbol 'get_object_address' was not declared. Should it be static?
drivers/input/touchscreen/atmel_mXT224E.c:547:9: sparse: symbol 'get_object_size' was not declared. Should it be static?
drivers/input/touchscreen/atmel_mXT224E.c:557:9: sparse: symbol 'get_object_size_from_address' was not declared. Should it be static?
drivers/input/touchscreen/atmel_mXT224E.c:847:32: sparse: symbol 'atmel_ts_get_pdata' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 atmel_mXT224E.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mXT224E.c b/drivers/input/touchscreen/atmel_mXT224E.c
index 0a7fab2..99bcfde 100644
--- a/drivers/input/touchscreen/atmel_mXT224E.c
+++ b/drivers/input/touchscreen/atmel_mXT224E.c
@@ -457,7 +457,7 @@ static struct atmel_ts_data *private_ts;
 #define LDO_POWR_VOLTAGE 2700000 /*2.7v*/
 static	struct regulator		*LDO;
 
-int i2c_atmel_read(struct i2c_client *client, uint16_t address, uint8_t *data, uint8_t length)
+static int i2c_atmel_read(struct i2c_client *client, uint16_t address, uint8_t *data, uint8_t length)
 {
 	int retry, ret;
 	uint8_t addr[2];
@@ -493,7 +493,7 @@ int i2c_atmel_read(struct i2c_client *client, uint16_t address, uint8_t *data, u
 	return 0;
 }
 
-int i2c_atmel_write(struct i2c_client *client, uint16_t address, uint8_t *data, uint8_t length)
+static int i2c_atmel_write(struct i2c_client *client, uint16_t address, uint8_t *data, uint8_t length)
 {
 	int retry, loop_i, ret;
 	uint8_t buf[length + 2];
@@ -529,13 +529,13 @@ int i2c_atmel_write(struct i2c_client *client, uint16_t address, uint8_t *data,
 
 }
 
-int i2c_atmel_write_byte_data(struct i2c_client *client, uint16_t address, uint8_t value)
+static int i2c_atmel_write_byte_data(struct i2c_client *client, uint16_t address, uint8_t value)
 {
 	i2c_atmel_write(client, address, &value, 1);
 	return 0;
 }
 
-uint16_t get_object_address(struct atmel_ts_data *ts, uint8_t object_type)
+static uint16_t get_object_address(struct atmel_ts_data *ts, uint8_t object_type)
 {
 	uint8_t loop_i;
 	for (loop_i = 0; loop_i < ts->id->num_declared_objects; loop_i++) {
@@ -544,7 +544,7 @@ uint16_t get_object_address(struct atmel_ts_data *ts, uint8_t object_type)
 	}
 	return 0;
 }
-uint8_t get_object_size(struct atmel_ts_data *ts, uint8_t object_type)
+static uint8_t get_object_size(struct atmel_ts_data *ts, uint8_t object_type)
 {
 	uint8_t loop_i;
 	for (loop_i = 0; loop_i < ts->id->num_declared_objects; loop_i++) {
@@ -554,7 +554,7 @@ uint8_t get_object_size(struct atmel_ts_data *ts, uint8_t object_type)
 	return 0;
 }
 
-uint8_t get_object_size_from_address(struct atmel_ts_data *ts, int address)
+static uint8_t get_object_size_from_address(struct atmel_ts_data *ts, int address)
 {
 	uint8_t loop_i;
 	for (loop_i = 0; loop_i < ts->id->num_declared_objects; loop_i++) {
@@ -844,7 +844,7 @@ static int read_object_table(struct atmel_ts_data *ts)
 	return 0;
 }
 
-struct atmel_i2c_platform_data *atmel_ts_get_pdata(struct i2c_client *client)
+static struct atmel_i2c_platform_data *atmel_ts_get_pdata(struct i2c_client *client)
 {
 	struct device_node *node = client->dev.of_node;
 	struct atmel_i2c_platform_data *pdata = client->dev.platform_data;
