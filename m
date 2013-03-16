Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3CPGRN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 02:17:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38666 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab3CPGRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 02:17:10 -0400
From: Lokesh Vutla <lokeshvutla@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <santosh.shilimkar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lokeshvutla@ti.com>,
        Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
Subject: [PATCH V2 6/8] memory: emif: Fix the incorrect 'size' parameter in memcpy
Date: Sat, 16 Mar 2013 11:46:46 +0530
Message-ID: <1363414608-7448-7-git-send-email-lokeshvutla@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363414608-7448-1-git-send-email-lokeshvutla@ti.com>
References: <1363414608-7448-1-git-send-email-lokeshvutla@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>

The issue was that only the first timings table was added to the
emif platform data at the emif driver registration. All other
timings tables was filled with zeros. Now all emif timings table
are added to the platform data.

Signed-off-by: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
Changes since V1: Updated $subject

 drivers/memory/emif.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 8db74e4..d27111e 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1468,7 +1468,7 @@ static struct emif_data *__init_or_module get_device_details(
 	if (pd->timings) {
 		temp = devm_kzalloc(dev, size, GFP_KERNEL);
 		if (temp) {
-			memcpy(temp, pd->timings, sizeof(*pd->timings));
+			memcpy(temp, pd->timings, size);
 			pd->timings = temp;
 		} else {
 			dev_warn(dev, "%s:%d: allocation error\n", __func__,
-- 
1.7.9.5

