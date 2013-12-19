Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3LSPEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:04:54 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59040 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3LSPEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:04:51 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: [PATCH 19/38] net: atm: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:30 +0100
Message-Id: <1387465429-3568-20-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 net/atm/atm_sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/atm/atm_sysfs.c b/net/atm/atm_sysfs.c
index 350bf62..0e070c2 100644
--- a/net/atm/atm_sysfs.c
+++ b/net/atm/atm_sysfs.c
@@ -154,8 +154,10 @@ int atm_register_sysfs(struct atm_dev *adev, struct device *parent)
 
 	dev_set_name(cdev, "%s%d", adev->type, adev->number);
 	err = device_register(cdev);
-	if (err < 0)
+	if (err < 0) {
+		put_device(cdev);
 		return err;
+	}
 
 	for (i = 0; atm_attrs[i]; i++) {
 		err = device_create_file(cdev, atm_attrs[i]);
-- 
1.8.3.1

