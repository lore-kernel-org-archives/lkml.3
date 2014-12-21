Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaLUROK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 12:14:10 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:46546 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaLUROI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 12:14:08 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ralf Baechle <ralf@linux-mips.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: mips: fw: arc: file.c:  Remove some unused functions
Date: Sun, 21 Dec 2014 18:16:52 +0100
Message-Id: <1419182212-9529-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
ArcSetFileInformation() ArcGetFileInformation() ArcSeek()
ArcGetReadStatus() ArcClose() ArcOpen() ArcGetDirectoryEntry()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/mips/fw/arc/file.c |   43 -------------------------------------------
 1 file changed, 43 deletions(-)

diff --git a/arch/mips/fw/arc/file.c b/arch/mips/fw/arc/file.c
index 49fd3ff..ebd69de 100644
--- a/arch/mips/fw/arc/file.c
+++ b/arch/mips/fw/arc/file.c
@@ -13,62 +13,19 @@
 #include <asm/sgialib.h>
 
 LONG
-ArcGetDirectoryEntry(ULONG FileID, struct linux_vdirent *Buffer,
-		     ULONG N, ULONG *Count)
-{
-	return ARC_CALL4(get_vdirent, FileID, Buffer, N, Count);
-}
-
-LONG
-ArcOpen(CHAR *Path, enum linux_omode OpenMode, ULONG *FileID)
-{
-	return ARC_CALL3(open, Path, OpenMode, FileID);
-}
-
-LONG
-ArcClose(ULONG FileID)
-{
-	return ARC_CALL1(close, FileID);
-}
-
-LONG
 ArcRead(ULONG FileID, VOID *Buffer, ULONG N, ULONG *Count)
 {
 	return ARC_CALL4(read, FileID, Buffer, N, Count);
 }
 
 LONG
-ArcGetReadStatus(ULONG FileID)
-{
-	return ARC_CALL1(get_rstatus, FileID);
-}
-
-LONG
 ArcWrite(ULONG FileID, PVOID Buffer, ULONG N, PULONG Count)
 {
 	return ARC_CALL4(write, FileID, Buffer, N, Count);
 }
 
 LONG
-ArcSeek(ULONG FileID, struct linux_bigint *Position, enum linux_seekmode SeekMode)
-{
-	return ARC_CALL3(seek, FileID, Position, SeekMode);
-}
-
-LONG
 ArcMount(char *name, enum linux_mountops op)
 {
 	return ARC_CALL2(mount, name, op);
 }
-
-LONG
-ArcGetFileInformation(ULONG FileID, struct linux_finfo *Information)
-{
-	return ARC_CALL2(get_finfo, FileID, Information);
-}
-
-LONG ArcSetFileInformation(ULONG FileID, ULONG AttributeFlags,
-			   ULONG AttributeMask)
-{
-	return ARC_CALL3(set_finfo, FileID, AttributeFlags, AttributeMask);
-}
-- 
1.7.10.4

