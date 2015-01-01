Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbbAAQ7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 11:59:13 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62251 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbbAAQ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 11:59:12 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Joshua Thompson <funaho@jurai.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: m68k: mac: misc.c:  Remove some unused functions
Date: Thu,  1 Jan 2015 18:02:12 +0100
Message-Id: <1420131732-31039-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
mac_pram_write() mac_pram_read()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/m68k/mac/misc.c |   46 ----------------------------------------------
 1 file changed, 46 deletions(-)

diff --git a/arch/m68k/mac/misc.c b/arch/m68k/mac/misc.c
index 707b61a..6fe7eb6 100644
--- a/arch/m68k/mac/misc.c
+++ b/arch/m68k/mac/misc.c
@@ -453,52 +453,6 @@ void pmu_shutdown(void)
  *-------------------------------------------------------------------
  */
 
-void mac_pram_read(int offset, __u8 *buffer, int len)
-{
-	__u8 (*func)(int);
-	int i;
-
-	switch(macintosh_config->adb_type) {
-	case MAC_ADB_IISI:
-		func = maciisi_read_pram; break;
-	case MAC_ADB_PB1:
-	case MAC_ADB_PB2:
-		func = pmu_read_pram; break;
-	case MAC_ADB_CUDA:
-		func = cuda_read_pram; break;
-	default:
-		func = via_read_pram;
-	}
-	if (!func)
-		return;
-	for (i = 0 ; i < len ; i++) {
-		buffer[i] = (*func)(offset++);
-	}
-}
-
-void mac_pram_write(int offset, __u8 *buffer, int len)
-{
-	void (*func)(int, __u8);
-	int i;
-
-	switch(macintosh_config->adb_type) {
-	case MAC_ADB_IISI:
-		func = maciisi_write_pram; break;
-	case MAC_ADB_PB1:
-	case MAC_ADB_PB2:
-		func = pmu_write_pram; break;
-	case MAC_ADB_CUDA:
-		func = cuda_write_pram; break;
-	default:
-		func = via_write_pram;
-	}
-	if (!func)
-		return;
-	for (i = 0 ; i < len ; i++) {
-		(*func)(offset++, buffer[i]);
-	}
-}
-
 void mac_poweroff(void)
 {
 	/*
-- 
1.7.10.4

