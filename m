Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab3EIH75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 03:59:57 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:64286 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3EIH7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 03:59:54 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Denis Efremov <yefremov.denis@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, trivial@kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 03/21] x86: remove inline marking of EXPORT_SYMBOL functions
Date: Thu,  9 May 2013 11:58:25 +0400
Message-Id: <1368086323-9412-3-git-send-email-yefremov.denis@gmail.com>
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
 arch/x86/lib/delay.c | 2 +-
 arch/x86/um/delay.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
index 7c3bee6..6ce3f87 100644
--- a/arch/x86/lib/delay.c
+++ b/arch/x86/lib/delay.c
@@ -113,7 +113,7 @@ void __delay(unsigned long loops)
 }
 EXPORT_SYMBOL(__delay);
 
-inline void __const_udelay(unsigned long xloops)
+void __const_udelay(unsigned long xloops)
 {
 	int d0;
 
diff --git a/arch/x86/um/delay.c b/arch/x86/um/delay.c
index f3fe1a6..6e35993 100644
--- a/arch/x86/um/delay.c
+++ b/arch/x86/um/delay.c
@@ -33,7 +33,7 @@ void __delay(unsigned long loops)
 }
 EXPORT_SYMBOL(__delay);
 
-inline void __const_udelay(unsigned long xloops)
+void __const_udelay(unsigned long xloops)
 {
 	int d0;
 
-- 
1.8.1.4

