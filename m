Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab3BLXGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:06:50 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35839 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678Ab3BLXGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:06:48 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v3 1/5] of/selftest: Fix GPIOs selftest to cover the 7th case
Date: Tue, 12 Feb 2013 23:06:37 +0000
Message-Id: <1360710401-16757-2-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360710401-16757-1-git-send-email-grant.likely@secretlab.ca>
References: <1360710401-16757-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_gpio_named_count() self test doesn't hit the out-of-range
condition even though it is coded. Fix the bug by increasing the for
loop range by one.

Reported-by: Andreas Larsson <andreas@gaisler.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/selftest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index f24ffd7..9f62eb5 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -35,7 +35,7 @@ static void __init of_selftest_parse_phandle_with_args(void)
 		return;
 	}
 
-	for (i = 0; i < 7; i++) {
+	for (i = 0; i < 8; i++) {
 		bool passed = true;
 		rc = of_parse_phandle_with_args(np, "phandle-list",
 						"#phandle-cells", i, &args);
-- 
1.7.10.4

