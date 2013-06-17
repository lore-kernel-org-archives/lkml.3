Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab3FQOVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:21:12 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39812 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755436Ab3FQOVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:21:07 -0400
From: Lorenz Haspel <lorenz@badgers.com>
To: devel@linuxdriverproject.org
Cc: gregkh@linuxfoundation.org, puff65537@bansheeslibrary.com,
        viro@zeniv.linux.org.uk, michael.banken@mathe.stud.uni-erlangen.de,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de,
        Lorenz Haspel <lorenz@badgers.com>
Subject: [PATCH 4/5] silicom: checkpatch: trailing statements
Date: Mon, 17 Jun 2013 16:20:16 +0200
Message-Id: <1371478817-28357-4-git-send-email-lorenz@badgers.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371478817-28357-1-git-send-email-lorenz@badgers.com>
References: <1371478817-28357-1-git-send-email-lorenz@badgers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed checkpatch error:
trailing statements that should be on next line

Signed-off-by: Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>
Signed-off-by: Lorenz Haspel <lorenz@badgers.com>
---
 drivers/staging/silicom/bpctl_mod.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 78570dd..85aa900 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -165,7 +165,9 @@ static int bp_device_event(struct notifier_block *unused,
 			memcpy(&cbuf, drvinfo.bus_info, 32);
 			buf = &cbuf[0];
 
-			while (*buf++ != ':') ;
+			while (*buf != ':')
+				buf++;
+			buf++;
 			for (i = 0; i < 10; i++, buf++) {
 				if (*buf == ':')
 					break;
@@ -2158,12 +2160,14 @@ static void bp75_release_phy(bpctl_dev_t *pbpctl_dev)
 {
 	u16 mask = BPCTLI_SWFW_PHY0_SM;
 	u32 swfw_sync;
+	s32 ret_val;
 
 	if ((pbpctl_dev->func == 1) || (pbpctl_dev->func == 3))
 		mask = BPCTLI_SWFW_PHY1_SM;
 
-	while (bp75_get_hw_semaphore_generic(pbpctl_dev) != 0) ;
-	/* Empty */
+	do
+		ret_val = bp75_get_hw_semaphore_generic(pbpctl_dev);
+	while (ret_val != 0);
 
 	swfw_sync = BPCTL_READ_REG(pbpctl_dev, SW_FW_SYNC);
 	swfw_sync &= ~mask;
@@ -5368,7 +5372,9 @@ static void if_scan_init(void)
 		memcpy(&cbuf, drvinfo.bus_info, 32);
 		buf = &cbuf[0];
 
-		while (*buf++ != ':') ;
+		while (*buf != ':')
+			buf++;
+		buf++;
 		for (i = 0; i < 10; i++, buf++) {
 			if (*buf == ':')
 				break;
-- 
1.7.10.4

