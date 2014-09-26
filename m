Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaIZJyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:54:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145AbaIZJqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 136/142] libata: widen Crucial M550 blacklist matching
Date: Fri, 26 Sep 2014 11:45:47 +0200
Message-Id: <61ee2622648853cd3b2d36f9972773ec37b3c71a.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2a13772a144d2956a7fedd18685921d0a9b8b783 upstream.

Crucial M550 may cause data corruption on queued trims and is
blacklisted.  The pattern used for it fails to match 1TB one as the
capacity section will be four chars instead of three.  Widen the
pattern.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Charles Reiss <woggling@gmail.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81071
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 0d9a2f674819..5d0bc51bafea 100644
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
2.1.0

