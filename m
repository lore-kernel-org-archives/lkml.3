Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab3LLI7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 03:59:08 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:46747 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab3LLI7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 03:59:05 -0500
X-Spam-Check-By: orbis-terrarum.net
From: "Robin H. Johnson" <robbat2@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, "Robin H. Johnson" <robbat2@gentoo.org>
Subject: [PATCH] libata: provide the ability to disable a disk via the params.
Date: Sat,  7 Dec 2013 16:56:27 -0800
Message-Id: <1386464187-6993-1-git-send-email-robbat2@gentoo.org>
X-Mailer: git-send-email 1.8.4.3
X-Virus-Checked: Checked by ClamAV on orbis-terrarum.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was posted by a user on StackExchange, who has a failing SSD that's
soldered directly onto the motherboard of his system. The BIOS does not
give any option to disable it at all, so he can't just hide it that way.

The old IDE layer had hdX=noprobe override for situations like this, but
that was never ported to the libata layer.

Signed-off-by: Robin H. Johnson <robbat2@gentoo.org>
X-URL: http://unix.stackexchange.com/questions/102648/how-to-tell-linux-kernel-3-0-to-completely-ignore-a-failing-disk
X-URL: http://askubuntu.com/questions/352836/how-can-i-tell-linux-kernel-to-completely-ignore-a-disk-as-if-it-was-not-even-co
X-URL: http://superuser.com/questions/599333/how-to-disable-kernel-probing-for-drive
---
 Documentation/kernel-parameters.txt | 2 ++
 drivers/ata/libata-core.c           | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 50680a5..40bf5ff 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1529,6 +1529,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 			* atapi_dmadir: Enable ATAPI DMADIR bridge support
 
+			* [no]disable: Enable or disable this device.
+
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 75b9367..5069a96 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6519,6 +6519,8 @@ static int __init ata_parse_force_one(char **cur,
 		{ "norst",	.lflags		= ATA_LFLAG_NO_HRST | ATA_LFLAG_NO_SRST },
 		{ "rstonce",	.lflags		= ATA_LFLAG_RST_ONCE },
 		{ "atapi_dmadir", .horkage_on	= ATA_HORKAGE_ATAPI_DMADIR },
+		{ "disable",	.horkage_on	= ATA_HORKAGE_DISABLE },
+		{ "nodisable",	.horkage_off	= ATA_HORKAGE_DISABLE },
 	};
 	char *start = *cur, *p = *cur;
 	char *id, *val, *endp;
-- 
1.8.4.3

