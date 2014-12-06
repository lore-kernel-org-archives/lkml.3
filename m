Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaLFPKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:10:36 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47684 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752430AbaLFPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Christian=20S=C3=BCnkenberg?= 
	<christian.suenkenberg@hfg-karlsruhe.de>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 55/66] scsi: add Intel Multi-Flex to scsi scan blacklist
Date: Sat,  6 Dec 2014 16:07:47 +0100
Message-Id: <57c63d276bc4984cb67f8642401b55aaa3e45af6.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Sünkenberg <christian.suenkenberg@hfg-karlsruhe.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1899045510ff109980d9cc34e330fd8ca3631871 upstream.

Intel Multi-Flex LUNs choke on REPORT SUPPORTED OPERATION CODES
resulting in sd_mod hanging for several minutes on startup.
The issue was introduced with WRITE SAME discovery heuristics.

Fixes: 5db44863b6eb ("[SCSI] sd: Implement support for WRITE SAME")
Signed-off-by: Christian Sünkenberg <christian.suenkenberg@hfg-karlsruhe.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 49014a143c6a..c1d04d4d3c6c 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -202,6 +202,7 @@ static struct {
 	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
 	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
 	{"INSITE", "I325VM", NULL, BLIST_KEY},
+	{"Intel", "Multi-Flex", NULL, BLIST_NO_RSOC},
 	{"iRiver", "iFP Mass Driver", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
 	{"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
 	{"MATSHITA", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-- 
2.1.3

