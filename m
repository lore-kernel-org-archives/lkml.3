Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab3HNQWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:22:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36428 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760024Ab3HNQWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:22:54 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: mjg@redhat.com
Cc: jbarnes@virtuousgeek.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] intel_ips: blacklist ASUSTek G60JX laptops
Date: Wed, 14 Aug 2013 12:22:49 -0400
Message-Id: <d4635f76028172e872cc4be506bad1c11816f75a.1376494861.git.joseph.salisbury@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1376494861.git.joseph.salisbury@canonical.com>
References: <cover.1376494861.git.joseph.salisbury@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/1210848

On an ASUSTek G60JX laptop, the intel_ips driver spams the log with a warning message: "ME failed to update for more than 1s, likely hung".  This ME doesn't support the feature, so requesting it be blacklisted for now.   

Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Tested-by: Nick Jenkins <tech.crew.jenkins@gmail.com> 
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 drivers/platform/x86/intel_ips.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 18dcb58..6d8c5e0 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -1501,6 +1501,14 @@ static const struct dmi_system_id ips_blacklist[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook"),
 		},
 	},
+	{
+		.callback = ips_blacklist_callback,
+		.ident = "G60JX",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "G60JX"),
+		},
+	},
 	{ }	/* terminating entry */
 };
 
-- 
1.7.9.5

