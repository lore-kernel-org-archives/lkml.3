Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab3LSHxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:53:25 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:50562 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3LSHxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:53:21 -0500
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Elliott@hp.com, samer.el-haj-mahmoud@hp.com,
        Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de,
        JBeulich@suse.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH 01/14] rtc-efi: fix decrease day twice when computing year days
Date: Thu, 19 Dec 2013 15:51:42 +0800
Message-Id: <1387439515-8926-2-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1387439515-8926-1-git-send-email-jlee@suse.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compared with the logic in rtc_year_days of efirtc.c, the code in
rtc-efi decreases value of day twice when it computing year days.
That's becase rtc_year_days in rtc-lib.c already decrease day for
return the year days from 0 to 365.
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

