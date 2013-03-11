Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab3CKFGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:06:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45369 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab3CKFGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:06:37 -0400
From: Lokesh Vutla <lokeshvutla@ti.com>
To: <linux-kernel@vger.kernel.org>, <santosh.shilimkar@ti.com>,
        <gregkh@linuxfoundation.org>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 6/8] memory: emif: fix timings initialization issue
Date: Mon, 11 Mar 2013 10:36:03 +0530
Message-ID: <1362978365-5593-7-git-send-email-lokeshvutla@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362978365-5593-1-git-send-email-lokeshvutla@ti.com>
References: <1362978365-5593-1-git-send-email-lokeshvutla@ti.com>
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
---
 drivers/memory/emif.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 02a94fc..f75806a 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1463,7 +1463,7 @@ static struct emif_data *__init_or_module get_device_details(
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

