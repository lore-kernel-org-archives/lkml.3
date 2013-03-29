Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab3C2PUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 11:20:42 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:56845 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754333Ab3C2PUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 11:20:41 -0400
Message-ID: <1364570435.1345.82.camel@x61.thuisdomein>
Subject: [PATCH] ARM: Fix typo "CONFIG_SAMSUNG_DEV_RTC"
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 29 Mar 2013 16:20:35 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2013 15:20:36.0271 (UTC) FILETIME=[F67E53F0:01CE2C90]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s3c_rtc_setname() tests for CONFIG_SAMSUNG_DEV_RTC or
CONFIG_PLAT_S3C24XX. But of these two macros only CONFIG_PLAT_S3C24XX
actually exists. Now we can see that s3c_device_rtc is only defined if
either CONFIG_PLAT_S3C24XX or CONFIG_S3C_DEV_RTC are defined. So,
apparently, it was intended to use CONFIG_S3C_DEV_RTC here.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) Introduced in commit commit b2994d318dc78c9a4a43605629f00217335ada28
("ARM: S3C2443/S3C2416: add s3c_rtc_setname and rename rtc devices"),
which shipped in v3.4. Should this go to stable too (after testing)?

 arch/arm/plat-samsung/include/plat/rtc-core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-samsung/include/plat/rtc-core.h b/arch/arm/plat-samsung/include/plat/rtc-core.h
index 21d8594..7b542f7 100644
--- a/arch/arm/plat-samsung/include/plat/rtc-core.h
+++ b/arch/arm/plat-samsung/include/plat/rtc-core.h
@@ -19,7 +19,7 @@
 /* re-define device name depending on support. */
 static inline void s3c_rtc_setname(char *name)
 {
-#if defined(CONFIG_SAMSUNG_DEV_RTC) || defined(CONFIG_PLAT_S3C24XX)
+#if defined(CONFIG_S3C_DEV_RTC) || defined(CONFIG_PLAT_S3C24XX)
 	s3c_device_rtc.name = name;
 #endif
 }
-- 
1.7.11.7

