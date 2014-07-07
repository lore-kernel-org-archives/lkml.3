Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbaGGPZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:25:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:54370 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbaGGPWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:22:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,618,1400050800"; 
   d="scan'208";a="558367898"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 09/10] staging: rtl8192e: use %*pEn to escape buffer
Date: Mon,  7 Jul 2014 18:21:51 +0300
Message-Id: <1404746512-12749-10-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's use kernel's native specifier to escape a buffer.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/rtl8192e/rtllib.h | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib.h b/drivers/staging/rtl8192e/rtllib.h
index 83f5f57..9840be0 100644
--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -2956,25 +2956,13 @@ extern inline int rtllib_get_scans(struct rtllib_device *ieee)
 static inline const char *escape_essid(const char *essid, u8 essid_len)
 {
 	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-	const char *s = essid;
-	char *d = escaped;
 
 	if (rtllib_is_empty_essid(essid, essid_len)) {
 		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
 		return escaped;
 	}
 
-	essid_len = min(essid_len, (u8)IW_ESSID_MAX_SIZE);
-	while (essid_len--) {
-		if (*s == '\0') {
-			*d++ = '\\';
-			*d++ = '0';
-			s++;
-		} else {
-			*d++ = *s++;
-		}
-	}
-	*d = '\0';
+	snprintf(escaped, sizeof(escaped), "%*pEn", essid_len, essid);
 	return escaped;
 }
 
-- 
2.0.1

