Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3LMTXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 14:23:52 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:44976 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3LMTW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 14:22:58 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 2/4] eisa: call put_device if device_register fails
Date: Fri, 13 Dec 2013 20:22:35 +0100
Message-Id: <1386962557-8899-3-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386962557-8899-1-git-send-email-levex@linux.com>
References: <1386962557-8899-1-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to give up the last reference to edev->dev, so
we need to call put_device().

Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/eisa/eisa-bus.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/eisa/eisa-bus.c b/drivers/eisa/eisa-bus.c
index 272a3ec..8842cde 100644
--- a/drivers/eisa/eisa-bus.c
+++ b/drivers/eisa/eisa-bus.c
@@ -232,8 +232,10 @@ static int __init eisa_init_device(struct eisa_root_device *root,
 static int __init eisa_register_device(struct eisa_device *edev)
 {
 	int rc = device_register(&edev->dev);
-	if (rc)
+	if (rc) {
+		put_device(&edev->dev);
 		return rc;
+	}
 
 	rc = device_create_file(&edev->dev, &dev_attr_signature);
 	if (rc)
-- 
1.8.3.1

