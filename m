Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbbAKXm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 18:42:59 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:55604 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbbAKXmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 18:42:53 -0500
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
Subject: [PATCH v4 1/2] staging: lustre: Use mult if units not specified
Date: Sun, 11 Jan 2015 17:42:28 -0600
Message-Id: <1421019749-25110-2-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421019749-25110-1-git-send-email-chris@rorvick.com>
References: <1421019749-25110-1-git-send-email-chris@rorvick.com>
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

