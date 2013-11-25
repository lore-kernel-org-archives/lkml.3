Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3KYTBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:01:09 -0500
Received: from palahniuk.acksyn.org ([5.9.7.26]:39780 "EHLO
	palahniuk.acksyn.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab3KYTBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:01:04 -0500
From: Michele Baldessari <michele@acksyn.org>
To: linux-ide@vger.kernel.org
Cc: michele@acksyn.org, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8
Date: Mon, 25 Nov 2013 19:00:14 +0000
Message-Id: <1385406014-4877-1-git-send-email-michele@acksyn.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've received multiple reports in Fedora via (BZ 907193)
that the Seagate Momentus SpinPoint M8 errors out when enabling AA:
[    2.555905] ata2.00: failed to enable AA (error_mask=0x1)
[    2.568482] ata2.00: failed to enable AA (error_mask=0x1)

Add the ATA_HORKAGE_BROKEN_FPDMA_AA for this specific harddisk.

Reported-by: Nicholas <arealityfarbetween@googlemail.com>
Signed-off-by: Michele Baldessari <michele@acksyn.org>
Tested-by: Nicholas <arealityfarbetween@googlemail.com>
---
 drivers/ata/libata-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 81a94a3..f6b0892 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4156,6 +4156,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "ST3320[68]13AS",	"SD1[5-9]",	ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
 
+	/* Seagate Momentus SpinPoint M8 seem to have FPMDA_AA issues */
+	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
+
 	/* Blacklist entries taken from Silicon Image 3124/3132
 	   Windows driver .inf file - also several Linux problem reports */
 	{ "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },
-- 
1.8.4.2

