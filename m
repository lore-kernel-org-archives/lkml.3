Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaLUREx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 12:04:53 -0500
Received: from mail-yk0-f182.google.com ([209.85.160.182]:32921 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbaLUREn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 12:04:43 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Greg Donald <gdonald@gmail.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Fabian Frederick <fabf@skynet.be>, James Simmons <uja.ornl@gmail.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] drivers: staging: lustre: Use mult if units not specified
Date: Sun, 21 Dec 2014 11:04:04 -0600
Message-Id: <1419181445-15031-2-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419181445-15031-1-git-send-email-chris@rorvick.com>
References: <1419181445-15031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Units can be passed to lprocfs_write_frac_u64_helper() via a suffix
(e.g., "...K", "...M", etc.) tacked onto the value.  A comment states
that "specified units override the multiplier," though the multiplier is
overridden regardless.  Update the conditional logic so that it only
applies when units are specified.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/lprocfs_status.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 3b7dfc3..a7b270e 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -1908,7 +1908,7 @@ int lprocfs_write_frac_u64_helper(const char *buffer, unsigned long count,
 		units <<= 10;
 	}
 	/* Specified units override the multiplier */
-	if (units)
+	if (units > 1)
 		mult = mult < 0 ? -units : units;
 
 	frac *= mult;
-- 
2.1.0

