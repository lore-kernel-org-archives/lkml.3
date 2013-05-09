Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3EIKhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:37:55 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:63449 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3EIKhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:37:53 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 14/21] arm64: delay: remove inline marking of EXPORT_SYMBOL functions
Date: Thu,  9 May 2013 14:36:52 +0400
Message-Id: <1368095819-11011-3-git-send-email-yefremov.denis@gmail.com>
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
 arch/arm64/lib/delay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/lib/delay.c b/arch/arm64/lib/delay.c
index dad4ec9..368ca15 100644
--- a/arch/arm64/lib/delay.c
+++ b/arch/arm64/lib/delay.c
@@ -33,7 +33,7 @@ void __delay(unsigned long cycles)
 }
 EXPORT_SYMBOL(__delay);
 
-inline void __const_udelay(unsigned long xloops)
+void __const_udelay(unsigned long xloops)
 {
 	unsigned long loops;
 
-- 
1.8.1.4

