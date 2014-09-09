Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbaIIBm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 21:42:27 -0400
Received: from linuxhacker.ru ([217.76.32.60]:35854 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387AbaIIBmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 21:42:02 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Hugues <morisset.hugues@gmail.com>, Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 2/2] staging/lustre: remove unused function is_osp_on_mdt
Date: Mon,  8 Sep 2014 21:41:28 -0400
Message-Id: <1410226888-20377-3-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410226888-20377-1-git-send-email-green@linuxhacker.ru>
References: <1410226888-20377-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is no longer used anywhere.

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
---
 drivers/staging/lustre/lustre/include/obd.h | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 66fc457..63e9ca8 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -660,35 +660,6 @@ struct niobuf_local {
 #define LUSTRE_MGS_OBDNAME "MGS"
 #define LUSTRE_MGC_OBDNAME "MGC"
 
-static inline int is_osp_on_mdt(char *name)
-{
-	char   *ptr;
-
-	ptr = strrchr(name, '-');
-	if (ptr == NULL) {
-		CERROR("%s is not a obdname\n", name);
-		return 0;
-	}
-
-	/* 1.8 OSC/OSP name on MDT is fsname-OSTxxxx-osc */
-	if (strncmp(ptr + 1, "osc", 3) == 0)
-		return 1;
-
-	if (strncmp(ptr + 1, "MDT", 3) != 0)
-		return 0;
-
-	while (*(--ptr) != '-' && ptr != name);
-
-	if (ptr == name)
-		return 0;
-
-	if (strncmp(ptr + 1, LUSTRE_OSP_NAME, strlen(LUSTRE_OSP_NAME)) != 0 &&
-	    strncmp(ptr + 1, LUSTRE_OSC_NAME, strlen(LUSTRE_OSC_NAME)) != 0)
-		return 0;
-
-	return 1;
-}
-
 /* Don't conflict with on-wire flags OBD_BRW_WRITE, etc */
 #define N_LOCAL_TEMP_PAGE 0x10000000
 
-- 
1.9.3

