Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab3AYI0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:26:08 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:65235 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab3AYI0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:26:05 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-ac-5102419ad089
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Axel Lin <axel.lin@ingics.com>,
        stable@vger.kernel.org
Subject: [PATCH] regulators: max8998: fix incorrect min_uV value for ldo10
Date: Fri, 25 Jan 2013 09:25:40 +0100
Message-id: <1359102341-22321-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t9jAd1ZjkyBBrOvqFhc3jWHzWLBxkeM
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX8P/2GqWA6R8XFM0fZGhhfsnUxcnBICJhIdLfYdzFy
	ApliEhfurQcKc3EICSxilHi2r4cFwmlnkljVu4ANpIpNwFCi620XmC0ioCCxufcZK0gRs8BO
	Roney9dYQRLCAl4Sf75MAitiEVCVOPG3kwnE5hXwkLj5/yUrxGYFiTmTbCYwci9gZFjFKJpa
	kFxQnJSea6hXnJhbXJqXrpecn7uJEezLZ1I7GFc2WBxiFOBgVOLhtUhjDBRiTSwrrsw9xCjB
	wawkwitjwhQoxJuSWFmVWpQfX1Sak1p8iFGag0VJnJfx1JMAIYH0xJLU7NTUgtQimCwTB6dU
	A6PWua5J8sviv9T95hGPqzcoEVRP6/aWL9u0f2r0v4v8wY9OnZnScOnkavevH3/fny2g/tZ3
	8z/H1Zznww3zNMPy11bJ/z9wvkKxKX/PQdmouXNcNJOKxA5OzVA+pfj33wnP4L4IAyPN8mks
	QnpqIkdPz3mptZN1St7pY/GL1aeWH92yPUHzerQSS3FGoqEWc1FxIgBND6h64QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct value for minimal voltage for ldo10 output is 950000 uV. This
patch fixes the typo introduced by patch adf6178ad5552a7f2f742a8c85343c50
("regulator: max8998: Use uV in voltage_map_desc"), what solves broken
probe of max8998 in v3.8-rc4.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: stable@vger.kernel.org
---
 drivers/regulator/max8998.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 1f0df40..0a8dd1c 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -65,7 +65,7 @@ static const struct voltage_map_desc ldo9_voltage_map_desc = {
 	.min = 2800000,	.step = 100000,	.max = 3100000,
 };
 static const struct voltage_map_desc ldo10_voltage_map_desc = {
-	.min = 95000,	.step = 50000,	.max = 1300000,
+	.min = 950000,	.step = 50000,	.max = 1300000,
 };
 static const struct voltage_map_desc ldo1213_voltage_map_desc = {
 	.min = 800000,	.step = 100000,	.max = 3300000,
-- 
1.7.9.5

