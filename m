Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbaDBD55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 23:57:57 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:39458 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaDBD5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 23:57:55 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH] rtc-efi: avoid subtract day twice when computing year days
Date: Wed,  2 Apr 2014 11:55:25 +0800
Message-Id: <1396410925-5704-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compared source code of rtc-lib.c::rtc_year_days() with
efirtc.c::rtc_year_days(), found the code in rtc-efi decreases value
of day twice when it computing year days. The tc-lib.c::rtc_year_days()
has already decrease day and return the year days from 0 to 365.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/rtc/rtc-efi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index 797aa02..c4c3843 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -35,7 +35,7 @@ static inline int
 compute_yday(efi_time_t *eft)
 {
 	/* efi_time_t.month is in the [1-12] so, we need -1 */
-	return rtc_year_days(eft->day - 1, eft->month - 1, eft->year);
+	return rtc_year_days(eft->day, eft->month - 1, eft->year);
 }
 /*
  * returns day of the week [0-6] 0=Sunday
-- 
1.6.4.2

