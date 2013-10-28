Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab3J1RFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:05:51 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:34685 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab3J1RFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:05:48 -0400
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
To: <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] misc/93xx46: avoid infinite loop on write()
Date: Mon, 28 Oct 2013 19:05:16 +0200
Message-ID: <1382979916-3494-3-git-send-email-vladimir_zapolskiy@mentor.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1382979916-3494-1-git-send-email-vladimir_zapolskiy@mentor.com>
References: <1382979916-3494-1-git-send-email-vladimir_zapolskiy@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 28 Oct 2013 17:05:48.0341 (UTC) FILETIME=[F2C48650:01CED3FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change fixes a problem of infinite zero byte write() without
an error status, if there is an attempt to write a file bigger than
EEPROM size over sysfs interface.

Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/eeprom/eeprom_93xx46.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/eeprom/eeprom_93xx46.c b/drivers/misc/eeprom/eeprom_93xx46.c
index 94cfc12..3a015ab 100644
--- a/drivers/misc/eeprom/eeprom_93xx46.c
+++ b/drivers/misc/eeprom/eeprom_93xx46.c
@@ -202,7 +202,7 @@ eeprom_93xx46_bin_write(struct file *filp, struct kobject *kobj,
 	edev = dev_get_drvdata(dev);
 
 	if (unlikely(off >= edev->bin.size))
-		return 0;
+		return -EFBIG;
 	if ((off + count) > edev->bin.size)
 		count = edev->bin.size - off;
 	if (unlikely(!count))
-- 
1.7.10.4

