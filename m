Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484AbaICKMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:12:41 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57352 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755408AbaICJ4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:56:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Guenter Roeck <linux@roeck-us.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 30/56] hwmon: (sis5595) Prevent overflow problem when writing large limits
Date: Wed,  3 Sep 2014 11:26:49 +0200
Message-Id: <12104910bccafdba7e5afb8ef5a5a0b1dcfe8f2d.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit cc336546ddca8c22de83720632431c16a5f9fe9a upstream.

On platforms with sizeof(int) < sizeof(long), writing a temperature
limit larger than MAXINT will result in unpredictable limit values
written to the chip. Avoid auto-conversion from long to int to fix
the problem.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hwmon/sis5595.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/sis5595.c b/drivers/hwmon/sis5595.c
index 72a889702f0d..9ec7d2e2542c 100644
--- a/drivers/hwmon/sis5595.c
+++ b/drivers/hwmon/sis5595.c
@@ -159,7 +159,7 @@ static inline int TEMP_FROM_REG(s8 val)
 {
 	return val * 830 + 52120;
 }
-static inline s8 TEMP_TO_REG(int val)
+static inline s8 TEMP_TO_REG(long val)
 {
 	int nval = clamp_val(val, -54120, 157530) ;
 	return nval < 0 ? (nval - 5212 - 415) / 830 : (nval - 5212 + 415) / 830;
-- 
2.1.0

