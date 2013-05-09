Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab3EIKho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:37:44 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:49471 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab3EIKhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:37:42 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Jonas Bonn <jonas@southpole.se>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        Will Deacon <will.deacon@arm.com>, linux@openrisc.net,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH 13/21] openrisc: delay: remove inline marking of EXPORT_SYMBOL functions
Date: Thu,  9 May 2013 14:36:51 +0400
Message-Id: <1368095819-11011-2-git-send-email-yefremov.denis@gmail.com>
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
 arch/openrisc/lib/delay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/openrisc/lib/delay.c b/arch/openrisc/lib/delay.c
index c82b09f..808a55c 100644
--- a/arch/openrisc/lib/delay.c
+++ b/arch/openrisc/lib/delay.c
@@ -37,7 +37,7 @@ void __delay(unsigned long cycles)
 }
 EXPORT_SYMBOL(__delay);
 
-inline void __const_udelay(unsigned long xloops)
+void __const_udelay(unsigned long xloops)
 {
 	unsigned long long loops;
 
-- 
1.8.1.4

