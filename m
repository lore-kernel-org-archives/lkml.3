Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaFWIgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:36:18 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55621 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 038/111] libata: Blacklist queued trim for Crucial M500
Date: Mon, 23 Jun 2014 10:31:13 +0200
Message-Id: <dc99f5d68db77e0536074c394c71dd89d96899d1.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Martin K. Petersen" <martin.petersen@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3b8d2676d15d6b2326757adb66b70a9cd6650373 upstream.

Queued trim only works for some users with MU05 firmware.  Revert to
blacklisting all firmware versions.

Introduced by commit d121f7d0cbb8 ("libata: Update queued trim blacklist
for M5x0 drives") which this effectively reverts, while retaining the
blacklisting of M550.

See

    https://bugzilla.kernel.org/show_bug.cgi?id=71371

for reports of trouble with MU05 firmware.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/ata/libata-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d7f00adbc374..d2eb9df3da3d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4224,10 +4224,10 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "PIONEER DVD-RW  DVR-216D",	NULL,	ATA_HORKAGE_NOSETXFER },
 
 	/* devices that don't properly handle queued TRIM commands */
-	{ "Micron_M500*",		"MU0[1-4]*",	ATA_HORKAGE_NO_NCQ_TRIM, },
-	{ "Crucial_CT???M500SSD*",	"MU0[1-4]*",	ATA_HORKAGE_NO_NCQ_TRIM, },
-	{ "Micron_M550*",		NULL,		ATA_HORKAGE_NO_NCQ_TRIM, },
-	{ "Crucial_CT???M550SSD*",	NULL,		ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Micron_M500*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Crucial_CT???M500SSD*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Micron_M550*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Crucial_CT???M550SSD*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
 
 	/*
 	 * Some WD SATA-I drives spin up and down erratically when the link
-- 
2.0.0

