Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbaA1MYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:24:41 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32551 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbaA1MTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:19:04 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-d6-52e7a0367b0d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 04/18] mfd: max14577: Add of_compatible to extcon mfd_cell
Date: Tue, 28 Jan 2014 13:18:28 +0100
Message-id: <1390911522-28209-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4NV2zBc+DDL4+5baY+vAJm8X1L89Z
	LV6/MLQ42/SG3eL+16OMFt+udDBZbHp8jdXi8q45bBZrj9xlt7jduILN4nQ3qwO3x85Zd9k9
	Nq3qZPO4c20Pm8e8k4Eem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfGnHccBd/YK+7N
	u8vUwHiarYuRk0NCwESivaePEcIWk7hwbz1QnItDSGApo8SSLzeYIZw+JomZc18wg1SxCRhL
	bF6+BKxKRGA1k8SaBVNZQBLMAr2MEjd3e4DYwgJeEpdP3WXtYuTgYBFQlfhyzBEkzCvgLvH+
	3TNGkLCEgILEnEk2IGFOAQ+JV1cbmUBsIaCSU8ffsUxg5F3AyLCKUTS1NLmgOCk910ivODG3
	uDQvXS85P3cTIyQMv+5gXHrM6hCjAAejEg/vg+5nQUKsiWXFlbmHGCU4mJVEeBNnPw8S4k1J
	rKxKLcqPLyrNSS0+xMjEwSnVwDh91pmEs/d9lxi1PdkUfWz/hFVZFsGLLCuZjAtr3Vd0tovx
	zPocbiueMkHz4f67l6VWxJ7Yd83yzfOauTdXJiiYzzvw+Pesu/nV8zl/mV8+LmXZMdFAKur3
	q9X7/LM8JvZZrdKYscCjdPNuyQmB3101vq0IkE94N6V3d5cbj9mzWDsNt7Jbq2cpsRRnJBpq
	MRcVJwIAX8PHHiECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_compatible ("maxim,max14577-muic") to the mfd_cell for extcon
driver. If entry with such compatible is present in the DTS, the extcon
driver will have of_node set.

This may be useful for extcon consumers and it is documented in
bindings documentation.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/mfd/max14577.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index ac514fb2b877..2ac2f2d7cea6 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -25,7 +25,10 @@
 #include <linux/mfd/max14577-private.h>
 
 static struct mfd_cell max14577_devs[] = {
-	{ .name = "max14577-muic", },
+	{
+		.name = "max14577-muic",
+		.of_compatible = "maxim,max14577-muic",
+	},
 	{
 		.name = "max14577-regulator",
 		.of_compatible = "maxim,max14577-regulator",
-- 
1.7.9.5

