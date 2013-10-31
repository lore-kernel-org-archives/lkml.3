Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3JaMDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:03:10 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:42395 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227Ab3JaMDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:03:08 -0400
From: <srinivas.kandagatla@st.com>
To: <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@kernel.org>, <srinivas.kandagatla@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH RFC 2/2] regmap: move to using BITS_MASK macro
Date: Thu, 31 Oct 2013 11:54:01 +0000
Message-ID: <1383220441-18519-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1383220389-18420-1-git-send-email-srinivas.kandagatla@st.com>
References: <1383220389-18420-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch uses the new BITS_MASK macro for generating mask for multiple
bits.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/base/regmap/regmap.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 7d689a1..7433939 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -816,11 +816,10 @@ EXPORT_SYMBOL_GPL(devm_regmap_init);
 static void regmap_field_init(struct regmap_field *rm_field,
 	struct regmap *regmap, struct reg_field reg_field)
 {
-	int field_bits = reg_field.msb - reg_field.lsb + 1;
 	rm_field->regmap = regmap;
 	rm_field->reg = reg_field.reg;
 	rm_field->shift = reg_field.lsb;
-	rm_field->mask = ((BIT(field_bits) - 1) << reg_field.lsb);
+	rm_field->mask = BITS_MASK(reg_field.lsb, reg_field.msb);
 }
 
 /**
-- 
1.7.6.5

