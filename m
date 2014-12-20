Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaLTMkD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 07:40:03 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36299 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaLTMkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 07:40:01 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: sparc: kernel: starfire.c:  Remove unused function
Date: Sat, 20 Dec 2014 13:42:47 +0100
Message-Id: <1419079367-32084-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function starfire_hard_smp_processor_id() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/sparc/include/asm/starfire.h |    1 -
 arch/sparc/kernel/starfire.c      |    5 -----
 2 files changed, 6 deletions(-)

diff --git a/arch/sparc/include/asm/starfire.h b/arch/sparc/include/asm/starfire.h
index c100dc2..176fa0a 100644
--- a/arch/sparc/include/asm/starfire.h
+++ b/arch/sparc/include/asm/starfire.h
@@ -12,7 +12,6 @@
 extern int this_is_starfire;
 
 void check_if_starfire(void);
-int starfire_hard_smp_processor_id(void);
 void starfire_hookup(int);
 unsigned int starfire_translate(unsigned long imap, unsigned int upaid);
 
diff --git a/arch/sparc/kernel/starfire.c b/arch/sparc/kernel/starfire.c
index 82281a5..167fdfd 100644
--- a/arch/sparc/kernel/starfire.c
+++ b/arch/sparc/kernel/starfire.c
@@ -28,11 +28,6 @@ void check_if_starfire(void)
 		this_is_starfire = 1;
 }
 
-int starfire_hard_smp_processor_id(void)
-{
-	return upa_readl(0x1fff40000d0UL);
-}
-
 /*
  * Each Starfire board has 32 registers which perform translation
  * and delivery of traditional interrupt packets into the extended
-- 
1.7.10.4

