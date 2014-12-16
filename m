Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaLPFme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 00:42:34 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:42281 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaLPFmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 00:42:33 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Chris Rorvick <chris@rorvick.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Greg Donald <gdonald@gmail.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Fabian Frederick <fabf@skynet.be>, James Simmons <uja.ornl@gmail.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: staging: lustre: Use mult if units not specified
Date: Mon, 15 Dec 2014 23:41:49 -0600
Message-Id: <1418708509-18196-1-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Units can be passed to lprocfs_write_frac_u64_helper() via a suffix
(e.g., "...K", "...M", etc.) tacked onto the value.  A comment states
that "specified units override the multiplier," though the multiplier is
overridden regardless.  Update the conditional logic so that it only
applies when units are specified.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/lustre/lustre/obdclass/lprocfs_status.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 61e04af..92ed0a0 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -1910,7 +1910,7 @@ int lprocfs_write_frac_u64_helper(const char *buffer, unsigned long count,
 		units <<= 10;
 	}
 	/* Specified units override the multiplier */
-	if (units)
+	if (units > 1)
 		mult = mult < 0 ? -units : units;
 
 	frac *= mult;
-- 
2.1.0

