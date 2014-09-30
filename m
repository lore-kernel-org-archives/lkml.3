Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaI3WDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:03:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60853 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaI3Vgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:36:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 024/103] libata: widen Crucial M550 blacklist matching
Date: Tue, 30 Sep 2014 14:30:29 -0700
Message-Id: <1412112708-27356-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 2a13772a144d2956a7fedd18685921d0a9b8b783 upstream.

Crucial M550 may cause data corruption on queued trims and is
blacklisted.  The pattern used for it fails to match 1TB one as the
capacity section will be four chars instead of three.  Widen the
pattern.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Charles Reiss <woggling@gmail.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81071
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f761603..538574f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4227,7 +4227,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "Micron_M500*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
 	{ "Crucial_CT???M500SSD*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
 	{ "Micron_M550*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
-	{ "Crucial_CT???M550SSD*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
+	{ "Crucial_CT*M550SSD*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM, },
 
 	/*
 	 * Some WD SATA-I drives spin up and down erratically when the link
-- 
1.9.1

