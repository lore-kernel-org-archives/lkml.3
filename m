Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab3EIKhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:37:25 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:56538 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab3EIKhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:37:24 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Denis Efremov <yefremov.denis@gmail.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 12/21] metag: delay: remove inline marking of EXPORT_SYMBOL functions
Date: Thu,  9 May 2013 14:36:50 +0400
Message-Id: <1368095819-11011-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL and inline directives are contradictory to each other.
The patch fixes this inconsistency.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 arch/metag/lib/delay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/metag/lib/delay.c b/arch/metag/lib/delay.c
index 0b308f4..7ff0ca7 100644
--- a/arch/metag/lib/delay.c
+++ b/arch/metag/lib/delay.c
@@ -36,7 +36,7 @@ void __delay(unsigned long loops)
 }
 EXPORT_SYMBOL(__delay);
 
-inline void __const_udelay(unsigned long xloops)
+void __const_udelay(unsigned long xloops)
 {
 	u64 loops = (u64)xloops * (u64)loops_per_jiffy * HZ;
 	__delay(loops >> 32);
-- 
1.8.1.4

