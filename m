Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaEGVsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:48:33 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:42898 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaEGVs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:48:29 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn@kryo.se>, Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 2/4] of/platform: return error on of_platform_device_create_pdata failure
Date: Wed,  7 May 2014 16:48:16 -0500
Message-Id: <1399499298-8830-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399499298-8830-1-git-send-email-robherring2@gmail.com>
References: <1399499298-8830-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

of_platform_populate does not return an error if creating the platform
device fails. This means almost any error from driver core cannot be
detected by the caller. Fix this.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/of/platform.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 404d1da..622aeb3 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -391,7 +391,9 @@ static int of_platform_bus_create(struct device_node *bus,
 	}
 
 	dev = of_platform_device_create_pdata(bus, bus_id, platform_data, parent);
-	if (!dev || !of_match_node(matches, bus))
+	if (!dev)
+		return -ENODEV;
+	if (!of_match_node(matches, bus))
 		return 0;
 
 	for_each_child_of_node(bus, child) {
-- 
1.9.1

