Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaCJR0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:26:16 -0400
Received: from ring0.de ([5.45.105.125]:40571 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbaCJR0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:26:11 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCHv3 4/9] mfd: twl-core: Add twl_i2c_read/write_u16
Date: Mon, 10 Mar 2014 18:25:24 +0100
Message-Id: <1394472329-15485-5-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394472329-15485-1-git-send-email-sre@debian.org>
References: <1394472329-15485-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a simple twl_i2c_read/write_u16 wrapper over
the twl_i2c_read/write, which is similar to the
twl_i2c_read/write_u8 wrapper.

Signed-off-by: Sebastian Reichel <sre@debian.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Jonathan Cameron <jic23@kernel.org>
Tested-by: Marek Belisko <marek@goldelico.com>
---
 include/linux/i2c/twl.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index ade1c06..d2b1670 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -195,6 +195,18 @@ static inline int twl_i2c_read_u8(u8 mod_no, u8 *val, u8 reg) {
 	return twl_i2c_read(mod_no, val, reg, 1);
 }
 
+static inline int twl_i2c_write_u16(u8 mod_no, u16 val, u8 reg) {
+	val = cpu_to_le16(val);
+	return twl_i2c_write(mod_no, (u8*) &val, reg, 2);
+}
+
+static inline int twl_i2c_read_u16(u8 mod_no, u16 *val, u8 reg) {
+	int ret;
+	ret = twl_i2c_read(mod_no, (u8*) val, reg, 2);
+	*val = le16_to_cpu(*val);
+	return ret;
+}
+
 int twl_get_type(void);
 int twl_get_version(void);
 int twl_get_hfclk_rate(void);
-- 
1.9.0

