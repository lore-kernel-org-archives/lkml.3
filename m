Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3LMGHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:07:09 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33259 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab3LMGHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:07:07 -0500
Date: Fri, 13 Dec 2013 11:36:54 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 2/3] drivers: message: Mark function mptscsih_quiesce_raid()
 as static in mptspi.c
Message-ID: <ca5bfbf90534e77ef7333f36286dcb36c563b368.1386914148.git.rashika.kheria@gmail.com>
References: <0a6b017550306ed600769dbe4fac868aa88cd9d6.1386914148.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a6b017550306ed600769dbe4fac868aa88cd9d6.1386914148.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function mptscsih_quiesce_raid() as static in
fusion/mptspi.c because it is not used outside this function.

Thus, it also eliminates the following warning in fusion/mptspi.c:
drivers/message/fusion/mptspi.c:624:1: warning: no previous prototype for ‘mptscsih_quiesce_raid’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/message/fusion/mptspi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 5653e50..ed8de0a 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -620,7 +620,7 @@ static void mptspi_read_parameters(struct scsi_target *starget)
 	spi_width(starget) = (nego & MPI_SCSIDEVPAGE0_NP_WIDE) ? 1 : 0;
 }
 
-int
+static int
 mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, u8 channel, u8 id)
 {
 	MPT_ADAPTER	*ioc = hd->ioc;
-- 
1.7.9.5

