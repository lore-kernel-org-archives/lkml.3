Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaHTMQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:16:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59575 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773AbaHTMQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:16:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Lee, Chun-Yi" <jlee@suse.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 102/104] drivers/rtc/rtc-efi.c: avoid subtracting day twice when computing year days
Date: Wed, 20 Aug 2014 13:44:05 +0200
Message-Id: <44a3aa6b1f9ded206117d516d35e6ba1d5dc646f.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 809d9627087e1db63b8672c1f264af73b13116fb upstream.

Compared source code of rtc-lib.c::rtc_year_days() with
efirtc.c::rtc_year_days(), found the code in rtc-efi decreases value of
day twice when it computing year days.  rtc-lib.c::rtc_year_days() has
already decrease days and return the year days from 0 to 365.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/rtc/rtc-efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index 797aa0252ba9..c4c38431012e 100644
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
2.0.4

