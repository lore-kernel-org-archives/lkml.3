Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbbANOJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:09:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41752 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbbANOJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:09:03 -0500
From: Colin King <colin.king@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86/time/rtc: remove duplicate const specifier
Date: Wed, 14 Jan 2015 14:07:55 +0000
Message-Id: <1421244475-313-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Building with clang:

  CC      arch/x86/kernel/rtc.o
arch/x86/kernel/rtc.c:173:29: warning: duplicate 'const' declaration
  specifier [-Wduplicate-decl-specifier]
        static const char * const  const ids[] __initconst =

Remove the duplicate const, it is not needed and causes a warning.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 arch/x86/kernel/rtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index ca9622a..fe3dbfe 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -170,7 +170,7 @@ static struct platform_device rtc_device = {
 static __init int add_rtc_cmos(void)
 {
 #ifdef CONFIG_PNP
-	static const char * const  const ids[] __initconst =
+	static const char * const ids[] __initconst =
 	    { "PNP0b00", "PNP0b01", "PNP0b02", };
 	struct pnp_dev *dev;
 	struct pnp_id *id;
-- 
2.1.4

