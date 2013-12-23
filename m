Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab3LWVzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:55:52 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:47415 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3LWVzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:55:40 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 23 Dec 2013 13:55:33 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Henk de Groot <pe1dnn@amsat.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] staging: wlags49_h2: Drop debug macro recording build
 date/time
Message-ID: <11720c5ede7441bc26c732b24e47189841dfd36d.1387833347.git.josh@joshtriplett.org>
References: <cover.1387833347.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387833347.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already has this information, and individual drivers
shouldn't duplicate that.  This also eliminates the use of __DATE__ and
__TIME__, which make the build non-deterministic.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/staging/wlags49_h2/wl_version.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_version.h b/drivers/staging/wlags49_h2/wl_version.h
index 037b526..019ebb2 100644
--- a/drivers/staging/wlags49_h2/wl_version.h
+++ b/drivers/staging/wlags49_h2/wl_version.h
@@ -129,11 +129,7 @@ err: define bus type;
 #endif  /* HERMES25 */
 #endif  /* BUS_XXX */
 
-#ifdef DBG
-#define MODULE_DATE         __DATE__ " " __TIME__
-#else
 #define MODULE_DATE         "07/18/2004 13:30:00"
-#endif // DBG
 
 //#define STR2(m) #m
 //#define STR1(m) STR2(m)
-- 
1.8.5.2

