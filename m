Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaC2SuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:50:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38013 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaC2SuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:50:15 -0400
Date: Sun, 30 Mar 2014 00:20:39 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vinayak Holikatti <vinholikatti@gmail.com>,
        Santosh Y <santoshsy@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 54/55] scsi: Add prototype declaration to header file
 ufs/ufshcd.h
Message-ID: <851b8b92b988e363d8aec2ef4b0332609c10cfc0.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype declaration of functions to header file ufs/ufshcd.h
because they are used by more than one file.

This eliminates the following warning in ufs/ufshcd.h:
drivers/scsi/ufs/ufshcd.c:2769:5: warning: no previous prototype for ‘ufshcd_suspend’ [-Wmissing-prototypes]
drivers/scsi/ufs/ufshcd.c:2790:5: warning: no previous prototype for ‘ufshcd_resume’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/ufs/ufshcd.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 577679a..9a920c3 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -317,4 +317,6 @@ static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
 	return ufshcd_dme_get_attr(hba, attr_sel, mib_val, DME_PEER);
 }
 
+int ufshcd_suspend(struct ufs_hba *hba, pm_message_t state);
+int ufshcd_resume(struct ufs_hba *hba);
 #endif /* End of Header */
-- 
1.7.9.5

