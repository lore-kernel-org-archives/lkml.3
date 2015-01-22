Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbbAVN7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:59:23 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58252 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbbAVN7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:59:21 -0500
From: Anshul Garg <aksgarg1989@gmail.com>
X-Google-Original-From: Anshul Garg
To: akpm@linux-foundation.org, levex@linux.com, felipe.contreras@gmail.com,
        linux-kernel@vger.kernel.org
Cc: aksgarg1989@gmail.com, anshul.g@samsung.com
Subject: [PATCH] lib/kstrtox.c Stop parsing integer on overflow
Date: Thu, 22 Jan 2015 05:58:50 -0800
Message-Id: <1421935130-77563-1-git-send-email-aksgarg1989@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <aksgarg1989@gmail.com>
References: <aksgarg1989@gmail.com>
X-Antivirus: avast! (VPS 150122-1, 01/22/2015), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anshul Garg <aksgarg1989@gmail.com>

While converting string representation to integer
break the loop if overflow is detected.

Signed-off-by: Anshul Garg <aksgarg1989@gmail.com>
---
 lib/kstrtox.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index ec8da78..6f30209 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -70,8 +70,10 @@ unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long
 		 * it in the max base we support (16)
 		 */
 		if (unlikely(res & (~0ull << 60))) {
-			if (res > div_u64(ULLONG_MAX - val, base))
+			if (res > div_u64(ULLONG_MAX - val, base)) {
 				overflow = 1;
+				break;
+			}
 		}
 		res = res * base + val;
 		rv++;
-- 
1.7.9.5


---
This email has been checked for viruses by Avast antivirus software.
http://www.avast.com

