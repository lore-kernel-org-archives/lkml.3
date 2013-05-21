Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab3EUGQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:16:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57776 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab3EUGQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:16:26 -0400
X-AuditID: cbfee68e-b7f276d000002279-da-519b1138663a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/8] rtc: rtc-ds1307: use devm_*() functions
Date: Tue, 21 May 2013 15:16:24 +0900
Message-id: <000201ce55ea$b87581e0$296085a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5V6q1hWLOAZwCWQPevxk3gAurlMQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zQ11LwdmBBtsZLZZcvMpuMWf9GjaL
	ywsvsVpc3jWHzWJ/ZwejA6vHnokn2TxOzPjN4tG3ZRWjx/R5P5k8Pm+SC2CN4rJJSc3JLEst
	0rdL4Mr4vmQ6S8F5uYpXS7qYGxhvincxcnJICJhITP67nx3CFpO4cG89WxcjF4eQwDJGifd/
	f7PDFM2b+okJIrGIUeLf7UlQVb8YJX7NmMIKUsUmoCbx5cthoA4ODhEBfYm2Fg2QGmaBXkaJ
	M727wSYJC9hIfJlyjxHEZhFQlfgyYz+YzStgKTFn+2xmCFtQ4sfkeywgNrOAlsT6nceZIGx5
	ic1r3jJDXKQgsePsa7BeEQE9ifbPjxghakQk9r14xwiyWELgGLvEolm9rBDLBCS+TT7EAnKc
	hICsxKYDUHMkJQ6uuMEygVFsFpLVs5CsnoVk9SwkKxYwsqxiFE0tSC4oTkovMtIrTswtLs1L
	10vOz93ECIm9vh2MNw9YH2JMBlo/kVlKNDkfGLt5JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgH
	CgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDM5vmx79Jit4WRDvt8Z3Ztmq8Wd8HEd76GfLTP
	462bMkXb2uICT1Q5q/r6P1RcHKxQcNa2PubZx2d8P5p8Lb/rMgmFWV784rpBqH3LM8ZZK88s
	Sp5kXSE2/8nPXZMCV0Q2tkxR5FS/6XvMs/A+/9q/cX9XvVtcEcAsfFvUVChTlb/8y8mqVzuU
	WIozEg21mIuKEwElTVCj0wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAV0LwdmBBn2PLCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzPi+ZDpLwXm5ildLupgbGG+KdzFyckgImEjM
	m/qJCcIWk7hwbz1bFyMXh5DAIkaJf7cnQTm/GCV+zZjCClLFJqAm8eXLYfYuRg4OEQF9ibYW
	DZAaZoFeRokzvbvZQWqEBWwkvky5xwhiswioSnyZsR/M5hWwlJizfTYzhC0o8WPyPRYQm1lA
	S2L9zuNMELa8xOY1b5khLlKQ2HH2NViviICeRPvnR4wQNSIS+168Y5zAKDALyahZSEbNQjJq
	FpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCY/uZ1A7GlQ0WhxgFOBiVeHgFDGcF
	CrEmlhVX5h5ilOBgVhLh/d4MFOJNSaysSi3Kjy8qzUktPsSYDPTpRGYp0eR8YNrJK4k3NDYx
	M7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbG/GgrTuvLU6M6++etrD5x
	OGSmxLOgCrt2rZMvrwSZ63lL+zM/O3Gau/jb+aSz1xq17Y493nD9lexTI3Yp5e/iUw+V/k1/
	utciUuf83rmZszr+FxjZ+4YYaee3hqwKmzVb2fPz8oZyDbE2+dbJuyMWbtOa88nCbeW3n+w1
	6aYL/hx4KfxgvZ2zEktxRqKhFnNRcSIAmu/+EzEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ds1307.c |   43 +++++++++++++++++--------------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index b53992a..ca18fd1 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -683,7 +683,7 @@ static int ds1307_probe(struct i2c_client *client,
 	    && !i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
-	ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL);
+	ds1307 = devm_kzalloc(&client->dev, sizeof(struct ds1307), GFP_KERNEL);
 	if (!ds1307)
 		return -ENOMEM;
 
@@ -715,7 +715,7 @@ static int ds1307_probe(struct i2c_client *client,
 		if (tmp != 2) {
 			dev_dbg(&client->dev, "read error %d\n", tmp);
 			err = -EIO;
-			goto exit_free;
+			goto exit;
 		}
 
 		/* oscillator off?  turn it on, so clock can tick. */
@@ -754,7 +754,7 @@ static int ds1307_probe(struct i2c_client *client,
 		if (tmp != 2) {
 			dev_dbg(&client->dev, "read error %d\n", tmp);
 			err = -EIO;
-			goto exit_free;
+			goto exit;
 		}
 
 		/* oscillator off?  turn it on, so clock can tick. */
@@ -798,7 +798,7 @@ static int ds1307_probe(struct i2c_client *client,
 			if (tmp != 2) {
 				dev_dbg(&client->dev, "read error %d\n", tmp);
 				err = -EIO;
-				goto exit_free;
+				goto exit;
 			}
 
 			/* correct hour */
@@ -826,7 +826,7 @@ read_rtc:
 	if (tmp != 8) {
 		dev_dbg(&client->dev, "read error %d\n", tmp);
 		err = -EIO;
-		goto exit_free;
+		goto exit;
 	}
 
 	/*
@@ -868,7 +868,7 @@ read_rtc:
 		if (tmp < 0) {
 			dev_dbg(&client->dev, "read error %d\n", tmp);
 			err = -EIO;
-			goto exit_free;
+			goto exit;
 		}
 
 		/* oscillator fault?  clear flag, and warn */
@@ -927,13 +927,13 @@ read_rtc:
 				bin2bcd(tmp));
 	}
 
-	ds1307->rtc = rtc_device_register(client->name, &client->dev,
+	ds1307->rtc = devm_rtc_device_register(&client->dev, client->name,
 				&ds13xx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(ds1307->rtc)) {
 		err = PTR_ERR(ds1307->rtc);
 		dev_err(&client->dev,
 			"unable to register the class device\n");
-		goto exit_free;
+		goto exit;
 	}
 
 	if (want_irq) {
@@ -942,7 +942,7 @@ read_rtc:
 		if (err) {
 			dev_err(&client->dev,
 				"unable to request IRQ!\n");
-			goto exit_irq;
+			goto exit;
 		}
 
 		device_set_wakeup_capable(&client->dev, 1);
@@ -951,11 +951,12 @@ read_rtc:
 	}
 
 	if (chip->nvram_size) {
-		ds1307->nvram = kzalloc(sizeof(struct bin_attribute),
-							GFP_KERNEL);
+		ds1307->nvram = devm_kzalloc(&client->dev,
+					sizeof(struct bin_attribute),
+					GFP_KERNEL);
 		if (!ds1307->nvram) {
 			err = -ENOMEM;
-			goto exit_nvram;
+			goto exit;
 		}
 		ds1307->nvram->attr.name = "nvram";
 		ds1307->nvram->attr.mode = S_IRUGO | S_IWUSR;
@@ -965,21 +966,15 @@ read_rtc:
 		ds1307->nvram->size = chip->nvram_size;
 		ds1307->nvram_offset = chip->nvram_offset;
 		err = sysfs_create_bin_file(&client->dev.kobj, ds1307->nvram);
-		if (err) {
-			kfree(ds1307->nvram);
-			goto exit_nvram;
-		}
+		if (err)
+			goto exit;
 		set_bit(HAS_NVRAM, &ds1307->flags);
 		dev_info(&client->dev, "%zu bytes nvram\n", ds1307->nvram->size);
 	}
 
 	return 0;
 
-exit_nvram:
-exit_irq:
-	rtc_device_unregister(ds1307->rtc);
-exit_free:
-	kfree(ds1307);
+exit:
 	return err;
 }
 
@@ -992,13 +987,9 @@ static int ds1307_remove(struct i2c_client *client)
 		cancel_work_sync(&ds1307->work);
 	}
 
-	if (test_and_clear_bit(HAS_NVRAM, &ds1307->flags)) {
+	if (test_and_clear_bit(HAS_NVRAM, &ds1307->flags))
 		sysfs_remove_bin_file(&client->dev.kobj, ds1307->nvram);
-		kfree(ds1307->nvram);
-	}
 
-	rtc_device_unregister(ds1307->rtc);
-	kfree(ds1307);
 	return 0;
 }
 
-- 
1.7.10.4


