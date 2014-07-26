Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaGZQpQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 12:45:16 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:61909 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbaGZQpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 12:45:14 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Herrmann <dh.herrmann@googlemail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hid: uhid.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 18:46:38 +0200
Message-Id: <1406393198-5306-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
And removed unnecessary magic numbers.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/hid/uhid.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 0cb92e3..b72ab0c 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -392,12 +392,9 @@ static int uhid_dev_create(struct uhid_device *uhid,
 		goto err_free;
 	}
 
-	strncpy(hid->name, ev->u.create.name, 127);
-	hid->name[127] = 0;
-	strncpy(hid->phys, ev->u.create.phys, 63);
-	hid->phys[63] = 0;
-	strncpy(hid->uniq, ev->u.create.uniq, 63);
-	hid->uniq[63] = 0;
+	strlcpy(hid->name, ev->u.create.name, sizeof(hid->name));
+	strlcpy(hid->phys, ev->u.create.phys, sizeof(hid->phys));
+	strlcpy(hid->uniq, ev->u.create.uniq, sizeof(hid->uniq));
 
 	hid->ll_driver = &uhid_hid_driver;
 	hid->bus = ev->u.create.bus;
@@ -452,12 +449,9 @@ static int uhid_dev_create2(struct uhid_device *uhid,
 		goto err_free;
 	}
 
-	strncpy(hid->name, ev->u.create2.name, 127);
-	hid->name[127] = 0;
-	strncpy(hid->phys, ev->u.create2.phys, 63);
-	hid->phys[63] = 0;
-	strncpy(hid->uniq, ev->u.create2.uniq, 63);
-	hid->uniq[63] = 0;
+	strlcpy(hid->name, ev->u.create2.name, sizeof(hid->name));
+	strlcpy(hid->phys, ev->u.create2.phys, sizeof(hid->phys));
+	strlcpy(hid->uniq, ev->u.create2.uniq, sizeof(hid->uniq));
 
 	hid->ll_driver = &uhid_hid_driver;
 	hid->bus = ev->u.create2.bus;
-- 
1.7.10.4

